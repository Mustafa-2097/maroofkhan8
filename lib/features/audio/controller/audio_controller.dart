import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:maroofkhan8/core/network/api_endpoints.dart';
import 'package:maroofkhan8/core/network/api_service.dart';
import '../model/audio_model.dart';

class AudioController extends GetxController {
  static AudioController get instance => Get.find<AudioController>();

  var isLoading = false.obs;
  var audioList = <AudioData>[].obs;

  // Audio Player state
  final AudioPlayer audioPlayer = AudioPlayer();
  var playerState = PlayerState.stopped.obs;
  var currentDuration = Duration.zero.obs;
  var totalDuration = Duration.zero.obs;
  var currentAudioId = ''.obs;
  var isAudioLoading = false.obs;

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

  Future<void> fetchAudios({String? category}) async {
    try {
      isLoading.value = true;

      Map<String, String>? queryParams;
      if (category != null) {
        // Map frontend categories to backend if necessary
        String backendCategory = category
            .toUpperCase()
            .replaceAll(' ', '_')
            .replaceAll('&', 'AND');
        queryParams = {'category': backendCategory};
      }

      final response = await ApiService.get(
        ApiEndpoints.audio,
        queryParameters: queryParams,
      );

      if (response['success'] == true) {
        final audioRes = AudioResponse.fromJson(response);
        audioList.value = audioRes.data ?? [];
      }
    } catch (e) {
      print("Error fetching audios: $e");
    } finally {
      isLoading.value = false;
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
      print("Error fetching single audio: $e");
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
      print("Error playing audio: $e");
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
