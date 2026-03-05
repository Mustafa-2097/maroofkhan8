import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/network/api_Service.dart';
import 'dart:convert';
import '../../../core/network/api_endpoints.dart';
import 'package:maroofkhan8/core/utils/snackbar_utils.dart';
import '../model/surah_model.dart';
import '../model/juz_model.dart' as jm;
import '../model/last_read_model.dart';
import '../model/verse_model.dart' as vm;
import '../model/tafsir_model.dart' as tm;
import '../model/audio_model.dart' as am;
import '../model/static_surah_data.dart';
import '../../../core/offline_storage/shared_pref.dart';

class QuranController extends GetxController {
  var surahList = <SurahModel>[].obs;
  var isLoading = false.obs;
  var juzList = <jm.Data>[].obs;
  var isJuzLoading = false.obs;
  var lastReadList = <LastReadData>[].obs;
  var isLastReadLoading = false.obs;
  var verseList = <vm.Data>[].obs;
  var isVerseLoading = false.obs;
  var tafsirList = <tm.Data>[].obs;
  var isTafsirLoading = false.obs;
  var surahAudio = Rxn<am.Data>();
  var isAudioLoading = false.obs;
  var currentSurahId = Rxn<int>();

  // Quran Bookmarks (Surahs)
  var savedSurahs = <SurahModel>[].obs;
  var isSavedLoading = false.obs;
  // Key: Surah ID, Value: Relation ID for deletion
  var surahBookmarkIds = <int, String>{}.obs;

  // Search functionality
  var searchQuery = ''.obs;

  List<SurahModel> get filteredSurahList {
    if (searchQuery.value.isEmpty) return surahList;
    return surahList
        .where(
          (s) =>
              s.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
              s.translatedName.toLowerCase().contains(
                searchQuery.value.toLowerCase(),
              ) ||
              s.id.toString() == searchQuery.value,
        )
        .toList();
  }

  List<jm.Data> get filteredJuzList {
    if (searchQuery.value.isEmpty) return juzList;
    return juzList.where((j) {
      final juzStr = j.number?.toString() ?? "";
      final chaptersStr =
          j.verses?.map((v) => v.chapter?.toString() ?? "").join(" ") ?? "";
      return juzStr.contains(searchQuery.value) ||
          chaptersStr.contains(searchQuery.value);
    }).toList();
  }

  List<LastReadData> get filteredLastReadList {
    if (searchQuery.value.isEmpty) return lastReadList;
    return lastReadList
        .where(
          (lr) =>
              (lr.chapter?.name ?? '').toLowerCase().contains(
                searchQuery.value.toLowerCase(),
              ) ||
              (lr.chapter?.nameTranslated ?? '').toLowerCase().contains(
                searchQuery.value.toLowerCase(),
              ) ||
              (lr.chapter?.chapterNumber ?? 0).toString() == searchQuery.value,
        )
        .toList();
  }

  final AudioPlayer audioPlayer = AudioPlayer();
  var playerState = PlayerState.stopped.obs;
  var currentDuration = Duration.zero.obs;
  var totalDuration = Duration.zero.obs;

  // Dummy data for fallback
  final List<SurahModel> dummySurahs = [
    SurahModel(
      id: 1,
      name: "Al-Fatihah",
      translatedName: "The Opener",
      versesCount: 7,
      revelationPlace: "MAKKAH",
    ),
    SurahModel(
      id: 2,
      name: "Al-Baqarah",
      translatedName: "The Cow",
      versesCount: 286,
      revelationPlace: "MADINAH",
    ),
    SurahModel(
      id: 3,
      name: "Ali 'Imran",
      translatedName: "Family of Imran",
      versesCount: 200,
      revelationPlace: "MADINAH",
    ),
    SurahModel(
      id: 4,
      name: "An-Nisa",
      translatedName: "The Women",
      versesCount: 176,
      revelationPlace: "MADINAH",
    ),
    SurahModel(
      id: 5,
      name: "Al-Ma'idah",
      translatedName: "The Table Spread",
      versesCount: 120,
      revelationPlace: "MADINAH",
    ),
    SurahModel(
      id: 6,
      name: "Al-An'am",
      translatedName: "The Cattle",
      versesCount: 165,
      revelationPlace: "MAKKAH",
    ),
    SurahModel(
      id: 7,
      name: "Al-A'raf",
      translatedName: "The Heights",
      versesCount: 206,
      revelationPlace: "MAKKAH",
    ),
    SurahModel(
      id: 8,
      name: "Al-Anfal",
      translatedName: "The Spoils of War",
      versesCount: 75,
      revelationPlace: "MADINAH",
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    fetchSurahs();
    fetchJuzs();
    fetchLastRead();
    fetchSavedSurahs();

    audioPlayer.onPlayerStateChanged.listen((state) {
      print("DEBUG: Player State Changed: $state");
      playerState.value = state;
    });

    audioPlayer.onDurationChanged.listen((duration) {
      print("DEBUG: Audio Duration: $duration");
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

  Future<void> fetchSurahs() async {
    try {
      isLoading.value = true;
      // Use static data instead of fetching from API
      surahList.value = StaticSurahData.surahs;
      print("DEBUG: Successfully loaded ${surahList.length} static surahs");
    } catch (e) {
      print("Error loading static surahs: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchJuzs() async {
    try {
      isJuzLoading.value = true;
      final token = await SharedPreferencesHelper.getToken();

      final headers = {
        if (token != null) 'Authorization': '$token',
        if (token != null) 'token': '$token',
        if (token != null) 'access_token': '$token',
      };

      final url = Uri.parse(ApiEndpoints.juzs);
      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        dynamic juzData = decoded['data'];
        if (juzData != null && juzData is List) {
          juzList.value = juzData
              .map((json) => jm.Data.fromJson(json))
              .toList();
        }
      } else {
        print(
          "DEBUG: Juz API rejected request with status ${response.statusCode}",
        );
        // juzList remains empty as per requirement
        juzList.clear();
      }
    } catch (e) {
      print("Error fetching juzs: $e");
      // juzList remains empty as per requirement
      juzList.clear();
    } finally {
      isJuzLoading.value = false;
    }
  }

  Future<void> fetchLastRead() async {
    try {
      isLastReadLoading.value = true;
      final token = await SharedPreferencesHelper.getToken();

      final headers = {
        if (token != null) 'Authorization': '$token',
        if (token != null) 'token': '$token',
        if (token != null) 'access_token': '$token',
      };

      final url = Uri.parse(ApiEndpoints.lastRead);
      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 30));

      print("DEBUG: Last Read Status Code: ${response.statusCode}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print("DEBUG: Last Read Response Body: ${response.body}");
        final decoded = jsonDecode(response.body);
        print("DEBUG: Decoded type: ${decoded.runtimeType}");

        dynamic lastReadData = decoded['data'];
        print("DEBUG: lastReadData type: ${lastReadData.runtimeType}");

        if (lastReadData != null && lastReadData is List) {
          print("DEBUG: lastReadData is List, size: ${lastReadData.length}");
          if (lastReadData.isNotEmpty) {
            print(
              "DEBUG: first element type: ${lastReadData.first.runtimeType}",
            );
          }

          lastReadList.value = lastReadData.map((json) {
            if (json is String) {
              print("DEBUG: Found string instead of Map: $json");
              // If it's a string, maybe it's double encoded?
              try {
                final innerDecoded = jsonDecode(json);
                return LastReadData.fromJson(innerDecoded);
              } catch (e) {
                print("DEBUG: Failed to decode inner string: $e");
                return LastReadData(); // Return empty if failed
              }
            }
            return LastReadData.fromJson(json);
          }).toList();
        }
      } else {
        print(
          "DEBUG: Last Read API rejected request with status ${response.statusCode}",
        );
        lastReadList.clear();
      }
    } catch (e) {
      print("Error fetching last read: $e");
      lastReadList.clear();
    } finally {
      isLastReadLoading.value = false;
    }
  }

  Future<void> fetchSurahVerses(int id) async {
    try {
      isVerseLoading.value = true;
      verseList.clear();
      final token = await SharedPreferencesHelper.getToken();

      final headers = {
        if (token != null) 'Authorization': '$token',
        if (token != null) 'token': '$token',
        if (token != null) 'access_token': '$token',
      };

      final url = Uri.parse(ApiEndpoints.surahDetails(id.toString()));
      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 30));

      print("DEBUG: Surah Verses Status Code: ${response.statusCode}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        final verseResponse = vm.VerseModel.fromJson(decoded);
        if (verseResponse.data != null) {
          verseList.value = verseResponse.data!;
        }
      } else {
        print(
          "DEBUG: Surah Details API rejected request with status ${response.statusCode}",
        );
        verseList.clear();
      }
    } catch (e) {
      print("Error fetching surah verses: $e");
      verseList.clear();
    } finally {
      isVerseLoading.value = false;
    }
  }

  Future<void> fetchSurahTafsir(int id) async {
    try {
      isTafsirLoading.value = true;
      tafsirList.clear();
      final token = await SharedPreferencesHelper.getToken();

      final headers = {
        if (token != null) 'Authorization': '$token',
        if (token != null) 'token': '$token',
        if (token != null) 'access_token': '$token',
      };

      final url = Uri.parse(ApiEndpoints.surahTafsir(id.toString()));
      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 30));

      print("DEBUG: Surah Tafsir Status Code: ${response.statusCode}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        final tafsirResponse = tm.TafsirModel.fromJson(decoded);
        if (tafsirResponse.data != null) {
          tafsirList.value = tafsirResponse.data!;
        }
      } else {
        print(
          "DEBUG: Surah Tafsir API rejected request with status ${response.statusCode}",
        );
        tafsirList.clear();
      }
    } catch (e) {
      print("Error fetching surah tafsir: $e");
      tafsirList.clear();
    } finally {
      isTafsirLoading.value = false;
    }
  }

  Future<void> fetchSurahAudio(int id) async {
    try {
      isAudioLoading.value = true;
      surahAudio.value = null;
      currentSurahId.value = id;
      print("DEBUG: Fetching audio for Surah $id");
      final token = await SharedPreferencesHelper.getToken();

      final headers = {
        if (token != null) 'Authorization': '$token',
        if (token != null) 'token': '$token',
        if (token != null) 'access_token': '$token',
      };

      final url = Uri.parse(ApiEndpoints.surahAudio(id.toString()));
      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 30));

      print("DEBUG: Surah Audio Status Code: ${response.statusCode}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        final audioResponse = am.AudioResponse.fromJson(decoded);
        if (audioResponse.data != null) {
          surahAudio.value = audioResponse.data;
          print("DEBUG: Fetched Audio URL: ${surahAudio.value?.url}");
        } else {
          print("DEBUG: Audio data is null in response");
        }
      } else {
        print(
          "DEBUG: Surah Audio API rejected request with status ${response.statusCode}",
        );
        surahAudio.value = null;
      }
    } catch (e) {
      print("Error fetching surah audio: $e");
      surahAudio.value = null;
    } finally {
      isAudioLoading.value = false;
    }
  }

  Future<void> playAudio() async {
    try {
      if (surahAudio.value?.url == null) {
        print("DEBUG: Cannot play audio, URL is null");
        return;
      }

      print("DEBUG: Attempting to play: ${surahAudio.value!.url}");
      if (playerState.value == PlayerState.paused) {
        await audioPlayer.resume();
      } else {
        await audioPlayer.play(UrlSource(surahAudio.value!.url!));
      }
    } catch (e) {
      print("DEBUG: Error playing audio: $e");
    }
  }

  Future<void> pauseAudio() async {
    await audioPlayer.pause();
  }

  Future<void> stopAudio() async {
    await audioPlayer.stop();
  }

  Future<void> resetAudio() async {
    await audioPlayer.seek(Duration.zero);
    await playAudio();
  }

  Future<void> seekAudio(Duration duration) async {
    await audioPlayer.seek(duration);
  }

  Future<void> seekRelative(Duration offset) async {
    final newPosition = currentDuration.value + offset;
    // Clamp between zero and total duration
    if (newPosition < Duration.zero) {
      await audioPlayer.seek(Duration.zero);
    } else if (newPosition > totalDuration.value) {
      await audioPlayer.seek(totalDuration.value);
    } else {
      await audioPlayer.seek(newPosition);
    }
  }

  Future<void> playVerse(String? verseKey) async {
    if (verseKey == null || surahAudio.value == null) return;

    final segment = surahAudio.value!.segments?.firstWhereOrNull(
      (s) => s.verseKey == verseKey,
    );

    if (segment != null && segment.timestampFrom != null) {
      await seekAudio(Duration(milliseconds: segment.timestampFrom!));
      await playAudio();

      // Update last read when a specific verse is played
      final verseParts = verseKey.split(':');
      if (verseParts.length == 2) {
        final chapterId = int.tryParse(verseParts[0]);
        final verseNum = int.tryParse(verseParts[1]);
        if (chapterId != null && verseNum != null) {
          updateLastRead(chapterId, verseNum);
        }
      }
    }
  }

  Future<void> updateLastRead(int chapterId, int verse) async {
    try {
      final token = await SharedPreferencesHelper.getToken();
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': '$token',
        if (token != null) 'token': '$token',
        if (token != null) 'access_token': '$token',
      };

      final body = jsonEncode({"chapter": chapterId, "verse": verse});

      final url = Uri.parse(ApiEndpoints.lastRead);
      final response = await http.post(url, headers: headers, body: body);

      print("DEBUG: Update Last Read Status Code: ${response.statusCode}");
      print("DEBUG: Update Last Read Response: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        fetchLastRead();
      }
    } catch (e) {
      print("Error updating last read: $e");
    }
  }

  Future<void> postChapters(int chapterId) async {
    try {
      final token = await SharedPreferencesHelper.getToken();
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': '$token',
        if (token != null) 'token': '$token',
        if (token != null) 'access_token': '$token',
      };

      final body = jsonEncode({"chapter": chapterId});
      final url = Uri.parse(ApiEndpoints.surah);
      final response = await http.post(url, headers: headers, body: body);

      print("DEBUG: Post Chapters Status Code: ${response.statusCode}");
      print("DEBUG: Post Chapters Response: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        fetchSurahs();
      }
    } catch (e) {
      print("Error posting chapters: $e");
    }
  }

  Future<void> deleteLastReadRecord(String id) async {
    try {
      final token = await SharedPreferencesHelper.getToken();
      final headers = {
        if (token != null) 'Authorization': '$token',
        if (token != null) 'token': '$token',
        if (token != null) 'access_token': '$token',
      };

      final url = Uri.parse(ApiEndpoints.deleteLastRead(id));
      final response = await http.delete(url, headers: headers);

      print("DEBUG: Delete Last Read Status Code: ${response.statusCode}");
      print("DEBUG: Delete Last Read Response: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Refresh the list after deletion
        fetchLastRead();
      }
    } catch (e) {
      print("Error deleting last read record: $e");
    }
  }

  Future<void> playSurahDirectly(SurahModel surah) async {
    // If it's already playing this surah, just toggle
    if (currentSurahId.value == surah.id && surahAudio.value?.url != null) {
      if (playerState.value == PlayerState.playing) {
        await pauseAudio();
      } else {
        await playAudio();
      }
      return;
    }

    // Otherwise, fetch and play
    await fetchSurahAudio(surah.id);
    await playAudio();
  }

  Future<void> fetchSavedSurahs() async {
    isSavedLoading.value = true;
    try {
      final response = await ApiService.get(ApiEndpoints.quranSaved);

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> data = response['data'];
        surahBookmarkIds.clear();
        for (var item in data) {
          final relationId = item['id'].toString();
          final chapterData = item['chapter'];
          final surahId = chapterData is Map
              ? chapterData['id']
              : (chapterData ?? item['chapterId']);
          if (surahId != null) {
            surahBookmarkIds[int.parse(surahId.toString())] = relationId;
          }
        }
        _syncSavedSurahs();
      }
    } catch (e) {
      print("Error fetching saved surahs: $e");
    } finally {
      isSavedLoading.value = false;
    }
  }

  Future<void> toggleSaveSurah(SurahModel surah) async {
    try {
      final isSaved = surahBookmarkIds.containsKey(surah.id);

      if (isSaved) {
        final relationId = surahBookmarkIds[surah.id];
        final response = await ApiService.delete(
          ApiEndpoints.deleteQuranSaved(relationId!),
        );

        if (response['success'] == true) {
          surahBookmarkIds.remove(surah.id);
          SnackbarUtils.showSnackbar(
            "Success",
            "${surah.name} removed from bookmarks",
          );
        }
      } else {
        final response = await ApiService.post(
          ApiEndpoints.quranSaved,
          body: {"chapter": surah.id, "verse": 1},
        );

        if (response['success'] == true) {
          final relationId = response['data']['id'].toString();
          surahBookmarkIds[surah.id] = relationId;
          SnackbarUtils.showSnackbar(
            "Success",
            "${surah.name} added to bookmarks",
          );
        }
      }
      _syncSavedSurahs();
    } catch (e) {
      print("Error toggling surah bookmark: $e");
    }
  }

  Future<void> downloadSurahAudio(SurahModel surah) async {
    SnackbarUtils.showSnackbar(
      "Download",
      "Starting download for ${surah.name}...",
    );
  }

  void _syncSavedSurahs() {
    savedSurahs.value = surahList
        .where((s) => surahBookmarkIds.containsKey(s.id))
        .toList();
  }
}
