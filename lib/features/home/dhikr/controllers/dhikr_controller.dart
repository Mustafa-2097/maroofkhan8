import 'package:get/get.dart';
import '../../../../core/network/api_Service.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/dhikr_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class DhikrController extends GetxController {
  static DhikrController get instance => Get.find();

  var tasbihList = <DhikrModel>[].obs;
  var isLoading = false.obs;

  final AudioPlayer _audioPlayer = AudioPlayer();
  var isPlaying = false.obs;
  var currentPlayingId = "".obs;

  var isAudioLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTasbihs();

    _audioPlayer.onPlayerStateChanged.listen((state) {
      isPlaying.value = state == PlayerState.playing;
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      isPlaying.value = false;
      currentPlayingId.value = "";
    });
  }

  @override
  void onClose() {
    stopTasbihAudio();
    _audioPlayer.dispose();
    super.onClose();
  }

  Future<void> playTasbihAudio(DhikrModel dhikr) async {
    if (dhikr.id.isEmpty || dhikr.file.isEmpty) {
      Get.snackbar("Error", "No audio file available");
      return;
    }

    try {
      if (currentPlayingId.value == dhikr.id) {
        if (isPlaying.value) {
          await _audioPlayer.pause();
        } else {
          await _audioPlayer.resume();
        }
        return;
      }

      // New audio selection
      isAudioLoading.value = true;
      currentPlayingId.value = dhikr.id;
      
      await _audioPlayer.stop();
      
      // Increased timeout to 60 seconds for very slow servers
      await _audioPlayer.play(UrlSource(dhikr.file)).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw TimeoutException("Connection timed out. The server took too long to respond.");
        },
      );
    } catch (e) {
      if (kDebugMode) print("Error playing Tasbih audio: $e | URL: ${dhikr.file}");
      
      // Reset states on error
      isAudioLoading.value = false;
      currentPlayingId.value = "";
      isPlaying.value = false;
      await _audioPlayer.stop();

      String message = "Could not play audio";
      if (e is TimeoutException || e.toString().contains("timeout")) {
        message = "Connection timed out. Please check your internet.";
      }
      
      Get.snackbar(
        "Playback Error", 
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF8D3C1F).withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isAudioLoading.value = false;
    }
  }

  Future<void> stopTasbihAudio() async {
    try {
      await _audioPlayer.stop();
      currentPlayingId.value = "";
      isPlaying.value = false;
      isAudioLoading.value = false;
    } catch (e) {
      if (kDebugMode) print("Error stopping Tasbih audio: $e");
    }
  }

  Future<void> fetchTasbihs() async {
    isLoading.value = true;
    try {
      final response = await ApiService.get(ApiEndpoints.tasbih);
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        tasbihList.value =
            data.map((json) => DhikrModel.fromJson(json)).toList();
      }
    } catch (e) {
      if (kDebugMode) print("Error fetching Tasbihs: $e");
      tasbihList.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
