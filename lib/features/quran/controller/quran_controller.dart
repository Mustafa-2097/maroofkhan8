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
import 'package:easy_localization/easy_localization.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // Offline Download tracking
  // Key: Surah ID, Value: Local File Path
  var downloadedSurahs = <int, String>{}.obs;
  var isDownloading = <int, bool>{}.obs;
  static const String _downloadedSurahsKey = 'downloaded_quran_surahs';

  List<SurahModel> get filteredSurahList {
    if (searchQuery.value.isEmpty) return surahList;
    return surahList
        .where(
          (s) =>
              // s.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
              // s.translatedName.toLowerCase().contains(
              //   searchQuery.value.toLowerCase(),
              // ) ||
              s.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
              s.translatedName.toLowerCase().contains(
                searchQuery.value.toLowerCase(),
              ) ||
              tr(
                "surah_${s.id}_name",
              ).toLowerCase().contains(searchQuery.value.toLowerCase()) ||
              tr(
                "surah_${s.id}_trans",
              ).toLowerCase().contains(searchQuery.value.toLowerCase()) ||
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
              // (lr.chapter?.name ?? '').toLowerCase().contains(
              //   searchQuery.value.toLowerCase(),
              // ) ||
              // (lr.chapter?.nameTranslated ?? '').toLowerCase().contains(
              //   searchQuery.value.toLowerCase(),
              // ) ||
              (lr.chapter?.name ?? '').toLowerCase().contains(
                searchQuery.value.toLowerCase(),
              ) ||
              (lr.chapter?.nameTranslated ?? '').toLowerCase().contains(
                searchQuery.value.toLowerCase(),
              ) ||
              (lr.chapter != null
                  ? tr(
                      "surah_${lr.chapter!.id}_name",
                    ).toLowerCase().contains(searchQuery.value.toLowerCase())
                  : false) ||
              (lr.chapter != null
                  ? tr(
                      "surah_${lr.chapter!.id}_trans",
                    ).toLowerCase().contains(searchQuery.value.toLowerCase())
                  : false) ||
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
    _loadDownloadedSurahs();

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

  Future<void> fetchSurahVerses(int id, {String? langCode}) async {
    try {
      isVerseLoading.value = true;
      verseList.clear();

      // Try local storage first
      final localData = await _readLocalJson("surah_${id}_verses_${langCode ?? 'en'}");
      if (localData != null) {
        final verseResponse = vm.VerseModel.fromJson(localData);
        if (verseResponse.data != null) {
          verseList.value = verseResponse.data!;
          return;
        }
      }

      final token = await SharedPreferencesHelper.getToken();
      final headers = {
        if (token != null) 'Authorization': '$token',
        if (token != null) 'token': '$token',
        if (token != null) 'access_token': '$token',
        if (langCode != null) 'lang': langCode,
      };

      final url = Uri.parse(ApiEndpoints.surahDetails(id.toString()));
      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        final verseResponse = vm.VerseModel.fromJson(decoded);
        if (verseResponse.data != null) {
          verseList.value = verseResponse.data!;
          // Save for offline if audio is already downloaded or being downloaded
          if (downloadedSurahs.containsKey(id)) {
            await _writeLocalJson("surah_${id}_verses_${langCode ?? 'en'}", decoded);
          }
        }
      } else {
        print("DEBUG: Surah Details API rejected request with status ${response.statusCode}");
        verseList.clear();
      }
    } catch (e) {
      print("Error fetching surah verses: $e");
      verseList.clear();
    } finally {
      isVerseLoading.value = false;
    }
  }

  Future<void> fetchSurahTafsir(int id, {String? langCode}) async {
    try {
      isTafsirLoading.value = true;
      tafsirList.clear();

      // Try local storage first
      final localData = await _readLocalJson("surah_${id}_tafsir_${langCode ?? 'en'}");
      if (localData != null) {
        final tafsirResponse = tm.TafsirModel.fromJson(localData);
        if (tafsirResponse.data != null) {
          tafsirList.value = tafsirResponse.data!;
          return;
        }
      }

      final token = await SharedPreferencesHelper.getToken();
      final headers = {
        if (token != null) 'Authorization': '$token',
        if (token != null) 'token': '$token',
        if (token != null) 'access_token': '$token',
        if (langCode != null) 'lang': langCode,
      };

      final url = Uri.parse(ApiEndpoints.surahTafsir(id.toString()));
      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        final tafsirResponse = tm.TafsirModel.fromJson(decoded);
        if (tafsirResponse.data != null) {
          tafsirList.value = tafsirResponse.data!;
          // Save for offline if audio is already downloaded or being downloaded
          if (downloadedSurahs.containsKey(id)) {
            await _writeLocalJson("surah_${id}_tafsir_${langCode ?? 'en'}", decoded);
          }
        }
      } else {
        print("DEBUG: Surah Tafsir API rejected request with status ${response.statusCode}");
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
      currentDuration.value = Duration.zero;
      totalDuration.value = Duration.zero;
      currentSurahId.value = id;

      // 1. Check local storage first
      if (downloadedSurahs.containsKey(id)) {
        final localPath = downloadedSurahs[id]!;
        if (await File(localPath).exists()) {
          print("DEBUG: Loading offline audio for Surah $id");
          
          // Try to load saved metadata (segments) for offline verse-by-verse
          final meta = await _readLocalJson("surah_${id}_audio_meta");
          if (meta != null) {
            surahAudio.value = am.Data.fromJson(meta);
          }

          await audioPlayer.setSource(DeviceFileSource(localPath));
          isAudioLoading.value = false;
          return;
        } else {
          downloadedSurahs.remove(id);
          _saveDownloadedSurahs();
        }
      }

      // 2. If not offline, fetch from API
      print("DEBUG: Fetching audio from API for Surah $id");
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
          
          // Set source immediately to load duration metadata
          if (surahAudio.value?.url != null) {
            await audioPlayer.setSource(UrlSource(surahAudio.value!.url!));
          }
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
      // If we have a local file, currentSurahId should tell us
      final id = currentSurahId.value;
      final localPath = id != null ? downloadedSurahs[id] : null;
      final hasLocal = localPath != null && await File(localPath).exists();

      if (!hasLocal && surahAudio.value?.url == null) {
        print("DEBUG: Cannot play audio, no local file and URL is null");
        return;
      }

      print("DEBUG: Attempting to play: ${surahAudio.value!.url}");

      /* Old Logic:
      if (playerState.value == PlayerState.paused ||
          playerState.value == PlayerState.stopped ||
          playerState.value == PlayerState.completed) {
        await audioPlayer.resume();
      } else if (playerState.value != PlayerState.playing) {
        await audioPlayer.play(UrlSource(surahAudio.value!.url!));
      }
      */

      // New Logic: If the player is completed or stopped, play from source again
      if (playerState.value == PlayerState.completed ||
          playerState.value == PlayerState.stopped) {
        Source source;
        if (currentSurahId.value != null &&
            downloadedSurahs.containsKey(currentSurahId.value)) {
          source = DeviceFileSource(downloadedSurahs[currentSurahId.value!]!);
        } else {
          source = UrlSource(surahAudio.value!.url!);
        }
        await audioPlayer.play(source);
      } else if (playerState.value == PlayerState.paused) {
        await audioPlayer.resume();
      } else if (playerState.value != PlayerState.playing) {
        Source source;
        if (currentSurahId.value != null &&
            downloadedSurahs.containsKey(currentSurahId.value)) {
          source = DeviceFileSource(downloadedSurahs[currentSurahId.value!]!);
        } else {
          source = UrlSource(surahAudio.value!.url!);
        }
        await audioPlayer.play(source);
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
    // await audioPlayer.seek(Duration.zero);
    // await playAudio();

    await stopAudio();
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
    if (verseKey == null) return;
    
    // Check if we have audio loaded (either offline or online)
    if (surahAudio.value == null) return;

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
          // SnackbarUtils.showSnackbar(
          //   "Success",
          //   "${surah.name} removed from bookmarks",
          // );
          SnackbarUtils.showSnackbar(
            tr("success"),
            "${tr("surah_${surah.id}_name")} ${tr("removed_from_bookmarks")}",
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
          // SnackbarUtils.showSnackbar(
          //   "Success",
          //   "${surah.name} added to bookmarks",
          // );
          SnackbarUtils.showSnackbar(
            tr("success"),
            "${tr("surah_${surah.id}_name")} ${tr("added_to_bookmarks")}",
          );
        }
      }
      _syncSavedSurahs();
    } catch (e) {
      print("Error toggling surah bookmark: $e");
    }
  }

  Future<void> downloadSurahAudio(SurahModel surah) async {
    try {
      // 1. Show "Starting download" snackbar
      SnackbarUtils.showSnackbar(
        tr("download"),
        "${tr("starting_download_for")} ${tr("surah_${surah.id}_name")}...",
      );

      // 2. Fetch the audio URL for this surah
      final token = await SharedPreferencesHelper.getToken();
      final headers = {
        if (token != null) 'Authorization': '$token',
        if (token != null) 'token': '$token',
        if (token != null) 'access_token': '$token',
      };
      final url = Uri.parse(ApiEndpoints.surahAudio(surah.id.toString()));
      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(
          "Failed to fetch audio URL (Status: ${response.statusCode})",
        );
      }

      final decoded = jsonDecode(response.body);
      final audioData = am.AudioResponse.fromJson(decoded).data;
      if (audioData == null || audioData.url == null) {
        throw Exception("Audio URL not found for this surah.");
      }

      final downloadUrl = audioData.url!;

      // 4. Get internal app directory (always)
      final dir = await getApplicationDocumentsDirectory();
      final quranDir = Directory("${dir.path}/quran_audio");
      if (!await quranDir.exists()) {
        await quranDir.create(recursive: true);
      }

      // 5. Download the file
      isDownloading[surah.id] = true;

      // Also Download Verses and Tafsir for offline use (in current language)
      final langCode = Get.context?.locale.languageCode ?? 'en';
      await _downloadSurahMetadata(surah.id, langCode);

      // Sanitize filename
      final fileName = "surah_${surah.id}.mp3";
      final filePath = "${quranDir.path}/$fileName";
      final file = File(filePath);

      final audioResponse = await http.get(Uri.parse(downloadUrl));
      if (audioResponse.statusCode == 200) {
        await file.writeAsBytes(audioResponse.bodyBytes);

        // Update tracking
        downloadedSurahs[surah.id] = filePath;
        await _saveDownloadedSurahs();
        
        // Save audio metadata locally for offline segments
        if (audioData.toJson() != null) {
           await _writeLocalJson("surah_${surah.id}_audio_meta", audioData.toJson());
        }

        // Update player source if currently viewing this surah
        if (currentSurahId.value == surah.id) {
          await audioPlayer.setSource(DeviceFileSource(filePath));
        }

        // 6. Show "Download complete" snackbar
        SnackbarUtils.showSnackbar(
          tr("download_complete"),
          "${tr("surah_${surah.id}_name")} ${tr("downloaded_successfully")}",
        );
      } else {
        throw Exception(
          "Failed to download audio file (Status: ${audioResponse.statusCode})",
        );
      }
    } catch (e) {
      print("Download error: $e");
      SnackbarUtils.showSnackbar(
        tr("error"),
        "${tr("download_failed")}: ${e.toString().replaceAll('Exception: ', '')}",
      );
    } finally {
      isDownloading[surah.id] = false;
    }
  }

  Future<void> deleteDownloadedSurah(int surahId) async {
    try {
      if (downloadedSurahs.containsKey(surahId)) {
        final path = downloadedSurahs[surahId]!;
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
        }
        // Delete metadata files too
        final dir = await getApplicationDocumentsDirectory();
        final metadataDir = Directory("${dir.path}/quran_metadata");
        if (await metadataDir.exists()) {
          final files = metadataDir.listSync();
          for (var f in files) {
            if (f.path.contains("surah_${surahId}_")) {
              await f.delete();
            }
          }
        }

        downloadedSurahs.remove(surahId);
        await _saveDownloadedSurahs();

        // If currently playing this surah, stop it or update source to URL
        if (currentSurahId.value == surahId) {
          await stopAudio();
          final langCode = Get.context?.locale.languageCode ?? 'en';
          fetchSurahVerses(surahId, langCode: langCode);
          fetchSurahAudio(surahId);
        }

        SnackbarUtils.showSnackbar(
          tr("success"),
          tr("surah_deleted_from_offline"),
        );
      }
    } catch (e) {
      print("Delete error: $e");
      SnackbarUtils.showSnackbar(tr("error"), tr("failed_to_delete_surah"));
    }
  }

  Future<void> _loadDownloadedSurahs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? encoded = prefs.getString(_downloadedSurahsKey);
      if (encoded != null) {
        final Map<String, dynamic> decoded = jsonDecode(encoded);
        downloadedSurahs.value = decoded.map(
          (key, value) => MapEntry(int.parse(key), value.toString()),
        );
      }
    } catch (e) {
      print("Error loading downloaded surahs: $e");
    }
  }

  Future<void> _saveDownloadedSurahs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = jsonEncode(
        downloadedSurahs.map((key, value) => MapEntry(key.toString(), value)),
      );
      await prefs.setString(_downloadedSurahsKey, encoded);
    } catch (e) {
      print("Error saving downloaded surahs: $e");
    }
  }

  Future<void> _writeLocalJson(String fileName, dynamic data) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final metadataDir = Directory("${dir.path}/quran_metadata");
      if (!await metadataDir.exists()) {
        await metadataDir.create(recursive: true);
      }
      final file = File("${metadataDir.path}/$fileName.json");
      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      print("Error writing local JSON: $e");
    }
  }

  Future<dynamic> _readLocalJson(String fileName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File("${dir.path}/quran_metadata/$fileName.json");
      if (await file.exists()) {
        final content = await file.readAsString();
        return jsonDecode(content);
      }
    } catch (e) {
      print("Error reading local JSON: $e");
    }
    return null;
  }

  Future<void> _downloadSurahMetadata(int id, String langCode) async {
    final token = await SharedPreferencesHelper.getToken();
    final headers = {
      if (token != null) 'Authorization': '$token',
      if (langCode != null) 'lang': langCode,
    };

    // Download Verses
    try {
      final vUrl = Uri.parse(ApiEndpoints.surahDetails(id.toString()));
      final vRes = await http.get(vUrl, headers: headers);
      if (vRes.statusCode == 200) {
        await _writeLocalJson("surah_${id}_verses_$langCode", jsonDecode(vRes.body));
      }
    } catch (e) {
      print("Error downloading verses metadata: $e");
    }

    // Download Tafsir
    try {
      final tUrl = Uri.parse(ApiEndpoints.surahTafsir(id.toString()));
      final tRes = await http.get(tUrl, headers: headers);
      if (tRes.statusCode == 200) {
        await _writeLocalJson("surah_${id}_tafsir_$langCode", jsonDecode(tRes.body));
      }
    } catch (e) {
      print("Error downloading tafsir metadata: $e");
    }
  }

  void _syncSavedSurahs() {
    savedSurahs.value = surahList
        .where((s) => surahBookmarkIds.containsKey(s.id))
        .toList();
  }
}
