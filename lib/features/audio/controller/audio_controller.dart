import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:maroofkhan8/core/network/api_endpoints.dart';
import 'package:maroofkhan8/core/network/api_service.dart';
import 'package:share_plus/share_plus.dart';
import '../model/audio_model.dart';

class AudioController extends GetxController {
  static AudioController get instance => Get.find<AudioController>();

  var isLoading = false.obs;
  var audioList = <AudioData>[].obs;
  var featuredAudio = Rxn<AudioData>(); // Track which audio is in the main card

  // Category mapping: UI Label -> Backend Enum
  final Map<String, String> categoryMapping = {
    "All": "All",
    "Sufi Lectures": "SUFI_LECTURES",
    "Malfuzat": "MALFUZAT",
    "Naats & Manqabats": "NAATS_AND_MANQABATS",
  };

  // Reverse mapping for display if needed: Backend Enum -> UI Label
  final Map<String, String> reverseCategoryMapping = {
    "SUFI_LECTURES": "Sufi Lectures",
    "MALFUZAT": "Malfuzat",
    "NAATS_AND_MANQABATS": "Naats & Manqabats",
  };

  // Audio Player state
  final AudioPlayer audioPlayer = AudioPlayer();
  var playerState = PlayerState.stopped.obs;
  var currentDuration = Duration.zero.obs;
  var totalDuration = Duration.zero.obs;
  var currentAudioId = ''.obs;
  var isAudioLoading = false.obs;
  var cachedDurations = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Pre-fetch all audio or wait for specific category
    fetchAudios();

    audioPlayer.onPlayerStateChanged.listen((state) {
      playerState.value = state;
    });

    audioPlayer.onDurationChanged.listen((duration) {
      totalDuration.value = duration;
      if (currentAudioId.value.isNotEmpty) {
        cachedDurations[currentAudioId.value] = _formatDuration(duration);
      }
    });

    audioPlayer.onPositionChanged.listen((position) {
      currentDuration.value = position;
    });
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  Future<void> fetchAudios({String? category}) async {
    try {
      isLoading.value = true;
      audioList.clear();

      Map<String, String>? queryParams;
      if (category != null && category != "All") {
        String backendCategory =
            categoryMapping[category] ??
            category.toUpperCase().replaceAll(' ', '_').replaceAll('&', 'AND');
        queryParams = {'category': backendCategory};
      }

      final response = await ApiService.get(
        ApiEndpoints.audio,
        queryParameters: queryParams,
      );

      if (response['success'] == true) {
        final audioRes = AudioResponse.fromJson(response);
        var fetchedData = audioRes.data ?? [];

        // Client-side filtering as a fallback for backend consistency
        if (category != null && category != "All") {
          String backendCategory =
              categoryMapping[category] ??
              category
                  .toUpperCase()
                  .replaceAll(' ', '_')
                  .replaceAll('&', 'AND');

          fetchedData = fetchedData.where((audio) {
            // Ignore case and underscores to be safe
            return audio.category?.toUpperCase().replaceAll('_', '') ==
                backendCategory.toUpperCase().replaceAll('_', '');
          }).toList();
        }

        audioList.assignAll(fetchedData);

        // Initialize featuredAudio if it's null or not in the new list
        if (audioList.isNotEmpty) {
          if (featuredAudio.value == null ||
              !audioList.any((a) => a.id == featuredAudio.value?.id)) {
            featuredAudio.value = audioList.first;
          }
        } else {
          featuredAudio.value = null;
        }

        // Pre-fetch durations for the list if needed, but doing it on-demand in UI or here
        _fetchListDurations(audioList);
      }
    } catch (e) {
      debugPrint("Error fetching audios: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> shareAudio(AudioData audio) async {
    if (audio.file == null) {
      Get.snackbar("Error", "No audio link available to share");
      return;
    }
    final String shareText =
        "Listen to '${audio.title ?? 'Audio'}' from Digital Khanqah App: ${audio.file}";
    await Share.share(shareText);
  }

  Future<void> _fetchListDurations(List<AudioData> list) async {
    for (var audio in list) {
      if (audio.id != null &&
          audio.file != null &&
          !cachedDurations.containsKey(audio.id)) {
        getAudioDuration(audio.id!, audio.file!);
      }
    }
  }

  Future<void> getAudioDuration(String id, String url) async {
    if (cachedDurations.containsKey(id)) return;

    try {
      final tempPlayer = AudioPlayer();
      await tempPlayer.setSource(UrlSource(url));
      final duration = await tempPlayer.getDuration();
      if (duration != null) {
        cachedDurations[id] = _formatDuration(duration);
      }
      await tempPlayer.dispose();
    } catch (e) {
      debugPrint("Error fetching duration for $id: $e");
      cachedDurations[id] = "--:--";
    }
  }

  Future<AudioData?> fetchAudioById(String id) async {
    try {
      isLoading.value = true;
      final response = await ApiService.get(ApiEndpoints.singleAudio(id));
      if (response['success'] == true) {
        return AudioData.fromJson(response['data']);
      }
    } catch (e) {
      debugPrint("Error fetching single audio: $e");
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<void> downloadAudio(AudioData audio) async {
    if (audio.file == null) {
      Get.snackbar("Error", "No file to download");
      return;
    }
    // For now, notifying user as actual file saving depends on platform-specific implementation
    // often involving path_provider and dio/http for large files.
    Get.snackbar("Download Started", "Downloading ${audio.title}...");

    // Simulating download logic
    await Future.delayed(const Duration(seconds: 2));
    Get.snackbar(
      "Download Complete",
      "${audio.title} has been saved to your device.",
    );
  }

  Future<void> playAudio(AudioData audio) async {
    try {
      if (currentAudioId.value == audio.id &&
          playerState.value == PlayerState.paused) {
        await audioPlayer.resume();
        return;
      }

      if (audio.file == null) {
        Get.snackbar("Error", "No audio file available");
        return;
      }

      isAudioLoading.value = true;
      currentAudioId.value = audio.id ?? '';
      featuredAudio.value = audio; // Update featured card to the playing audio

      await audioPlayer.stop();

      // Adding a timeout to the play call to handle slow networks
      await audioPlayer
          .play(UrlSource(audio.file!))
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw "Playback timed out. Please check your internet connection.";
            },
          );
    } catch (e) {
      debugPrint("Error playing audio: $e");
      String errorMsg = "Could not play audio";
      if (e.toString().contains("timeout")) {
        errorMsg = "Connection timed out. Please try again.";
      }
      Get.snackbar("Error", errorMsg);
      currentAudioId.value = '';
    } finally {
      isAudioLoading.value = false;
    }
  }

  Future<void> pauseAudio() async {
    await audioPlayer.pause();
  }

  Future<void> stopAudio() async {
    await audioPlayer.stop();
    currentAudioId.value = '';
  }

  Future<void> seekAudio(Duration position) async {
    await audioPlayer.seek(position);
  }

  bool isPlaying(String id) =>
      currentAudioId.value == id && playerState.value == PlayerState.playing;
}
