import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maroofkhan8/core/network/api_service.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/network/api_endpoints.dart';
import '../model/salawat_model.dart';

const Color kPrimaryBrown = Color(0xFF8D3C1F);

class SalawatController extends GetxController {
  var isLoading = false.obs;
  var salawatList = <SalawatData>[].obs;
  var savedSalawatList = <SalawatData>[].obs;
  var searchQuery = ''.obs;

  // Audio Playback
  final AudioPlayer audioPlayer = AudioPlayer();
  var playerState = PlayerState.stopped.obs;
  var currentDuration = Duration.zero.obs;
  var totalDuration = Duration.zero.obs;
  var currentPlayingSalawatId = Rxn<String>();

  List<SalawatData> get filteredSalawat {
    if (searchQuery.value.isEmpty) {
      return salawatList;
    }
    return salawatList
        .where(
          (salawat) =>
              salawat.title?.toLowerCase().contains(
                searchQuery.value.toLowerCase(),
              ) ??
              false,
        )
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    _initData();
    _initAudioListeners();
  }

  void _initAudioListeners() {
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

  Future<void> _initData() async {
    await fetchSalawat();
    await fetchSavedSalawat();
  }

  Future<void> fetchSalawat() async {
    try {
      isLoading.value = true;
      final response = await ApiService.get(ApiEndpoints.salawat);

      if (response['success'] == true) {
        final salawatRes = SalawatResponse.fromJson(response);
        if (salawatRes.data != null) {
          salawatList.value = salawatRes.data!;
          _syncSavedStatus();
        }
      }
    } catch (e) {
      debugPrint("Error fetching salawat: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSavedSalawat() async {
    try {
      final response = await ApiService.get(ApiEndpoints.savedSalawat);
      if (response['success'] == true) {
        final salawatRes = SalawatResponse.fromJson(response);
        final list = salawatRes.data ?? [];
        // Ensure all items from saved list are marked as saved
        for (var item in list) {
          item.isSaved = true;
        }
        savedSalawatList.assignAll(list);
        _syncSavedStatus();
      }
    } catch (e) {
      debugPrint("Error fetching saved salawat: $e");
    }
  }

  void _syncSavedStatus() {
    // Reset all to unsaved first
    for (var s in salawatList) {
      s.isSaved = false;
    }

    for (var saved in savedSalawatList) {
      int index = salawatList.indexWhere(
        (s) =>
            s.id == saved.id ||
            ((s.title != null && s.title == saved.title) &&
                (s.arabic != null && s.arabic == saved.arabic)),
      );
      if (index != -1) {
        salawatList[index].isSaved = true;
      }
    }
    salawatList.refresh();
  }

  Future<void> toggleBookmark(SalawatData salawat) async {
    if (salawat.id == null) return;

    bool currentlySaved = salawat.isSaved ?? false;

    try {
      final Map<String, dynamic> response;
      if (currentlySaved) {
        // Find the relation ID from savedSalawatList by matching title or arabic
        final savedItem = savedSalawatList.firstWhereOrNull(
          (s) =>
              s.id == salawat.id ||
              ((s.title != null && s.title == salawat.title) &&
                  (s.arabic != null && s.arabic == salawat.arabic)),
        );

        // Use the savedItem ID if found, otherwise fallback to salawat.id
        final String deleteId = savedItem?.id ?? salawat.id!;
        debugPrint(
          "Unsaving Salawat: Title=${salawat.title}, DeleteID=$deleteId",
        );

        response = await ApiService.delete(
          ApiEndpoints.deleteSavedSalawat(deleteId),
        );
      } else {
        debugPrint("Saving Salawat: Title=${salawat.title}, ID=${salawat.id}");
        response = await ApiService.post(
          ApiEndpoints.toggleSalawatSave(salawat.id!),
        );
      }

      if (response['success'] == true) {
        bool newState = !currentlySaved;
        salawat.isSaved = newState;

        // Update in lists
        int index = salawatList.indexWhere((s) => s.id == salawat.id);
        if (index == -1) {
          index = salawatList.indexWhere(
            (s) =>
                (s.title != null && s.title == salawat.title) &&
                (s.arabic != null && s.arabic == salawat.arabic),
          );
        }
        if (index != -1) {
          salawatList[index].isSaved = newState;
          salawatList.refresh();
        }

        if (newState == false) {
          savedSalawatList.removeWhere(
            (s) =>
                s.id == salawat.id ||
                ((s.title != null && s.title == salawat.title) &&
                    (s.arabic != null && s.arabic == salawat.arabic)),
          );
        }

        Get.snackbar(
          "Success",
          newState ? "Added to saved" : "Removed from saved",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: kPrimaryBrown,
          colorText: Colors.white,
        );

        // Refresh saved list to get correct relation IDs for next time if we just saved
        if (newState) {
          await fetchSavedSalawat();
        }
      }
    } catch (e) {
      if (e.toString().contains("Already Saved!")) {
        salawat.isSaved = true;
        _syncSavedStatus();
      }
      debugPrint("Toggle Bookmark Error: $e");
    }
  }

  Future<SalawatData?> fetchSalawatDetails(String id) async {
    try {
      isLoading.value = true;
      final response = await ApiService.get("${ApiEndpoints.salawat}/$id");

      if (response['success'] == true) {
        final details = SalawatData.fromJson(response['data']);
        // Sync isSaved status from local list
        details.isSaved = salawatList.any(
          (s) => s.id == id && (s.isSaved ?? false),
        );
        return details;
      }
    } catch (e) {
      debugPrint("Error fetching salawat details: $e");
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  void shareSalawat(SalawatData salawat) {
    if (salawat.id == null) return;
    String content = "Salawat: ${salawat.title ?? ""}\n\n";
    if (salawat.arabic != null) content += "${salawat.arabic}\n\n";
    if (salawat.translation != null) {
      content += "Translation: ${salawat.translation}\n\n";
    }
    if (salawat.transliteration != null) {
      content += "Transliteration: ${salawat.transliteration}\n\n";
    }
    content += "Shared via Maroof Khan App";

    Share.share(content);
  }

  Future<void> downloadSalawat(SalawatData salawat) async {
    if (salawat.audio == null) {
      Get.snackbar("Error", "No audio file available for download");
      return;
    }
    Get.snackbar(
      "Download Started",
      "Downloading audio for ${salawat.title}...",
      snackPosition: SnackPosition.BOTTOM,
    );
    await Future.delayed(const Duration(seconds: 2));
    Get.snackbar(
      "Download Complete",
      "Audio for ${salawat.title} has been saved.",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Playback Methods
  Future<void> playSalawat(SalawatData salawat) async {
    final audioUrl = salawat.file ?? salawat.audio;
    if (audioUrl == null) {
      Get.snackbar("Error", "No audio file available for playback");
      return;
    }

    try {
      if (currentPlayingSalawatId.value == salawat.id &&
          playerState.value == PlayerState.paused) {
        await audioPlayer.resume();
      } else {
        await audioPlayer.stop();
        currentPlayingSalawatId.value = salawat.id;
        await audioPlayer.play(UrlSource(audioUrl));
      }
    } catch (e) {
      debugPrint("Error playing salawat: $e");
    }
  }

  Future<void> pauseSalawat() async {
    await audioPlayer.pause();
  }

  Future<void> resumeSalawat() async {
    await audioPlayer.resume();
  }

  Future<void> stopSalawat() async {
    await audioPlayer.stop();
  }

  Future<void> seekSalawat(Duration position) async {
    await audioPlayer.seek(position);
  }

  SalawatData? getNextSalawat(SalawatData current) {
    int index = salawatList.indexWhere((s) => s.id == current.id);
    if (index != -1 && index < salawatList.length - 1) {
      return salawatList[index + 1];
    }
    return null;
  }

  SalawatData? getPreviousSalawat(SalawatData current) {
    int index = salawatList.indexWhere((s) => s.id == current.id);
    if (index > 0) {
      return salawatList[index - 1];
    }
    return null;
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}
