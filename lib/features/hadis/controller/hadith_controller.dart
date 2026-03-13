import 'package:get/get.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maroofkhan8/core/utils/snackbar_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/network/api_Service.dart';
import '../../../core/network/api_endpoints.dart';
import '../models/hadith_book.dart';
import '../models/hadith_chapter.dart';
import '../models/hadith.dart';
import '../models/popular_hadith.dart';
import '../models/last_read_hadith.dart';
import '../data/hadith_data.dart';

class HadithController extends GetxController {
  static HadithController get instance => Get.find();

  var isLoading = false.obs;
  var hadithBooks = <HadithBook>[].obs;
  var isSavedLoading = false.obs;
  var savedHadiths = <Hadith>[].obs;

  var isChaptersLoading = false.obs;
  var chapters = <HadithChapter>[].obs;

  var isHadithLoading = false.obs;
  var hadithList = <Hadith>[].obs;

  var isPopularLoading = false.obs;
  var popularHadiths = <PopularHadith>[].obs;

  var isLastReadLoading = false.obs;
  var lastReadHadiths = <LastReadHadith>[].obs;

  // Offline Chapter Download tracking
  // Key: slug_chapterNum, Value: Local File Path
  var downloadedChapters = <String, String>{}.obs;
  var isDownloadingChapter = <String, bool>{}.obs;
  static const String _downloadedChaptersKey = 'downloaded_hadith_chapters';

  // Offline Hadith Download tracking
  // Key: slug_hadithNo, Value: Local File Path
  var downloadedHadiths = <String, String>{}.obs;
  var isDownloadingHadith = <String, bool>{}.obs;
  static const String _downloadedHadithsKey = 'downloaded_hadiths';

  var searchQuery = ''.obs; // For Main Hadith Screen
  var chapterSearchQuery = ''.obs; // For Chapters Screen
  var hadithSearchQuery = ''.obs; // For Hadith List Screen

  List<HadithBook> get filteredHadithBooks {
    if (searchQuery.value.isEmpty) return hadithBooks;
    return hadithBooks
        .where(
          (b) => b.name.toLowerCase().contains(searchQuery.value.toLowerCase()),
        )
        .toList();
  }

  List<PopularHadith> get filteredPopularHadiths {
    if (searchQuery.value.isEmpty) return popularHadiths;
    return popularHadiths.where((h) {
      final query = searchQuery.value.toLowerCase();
      final textMatches = h.hadith.toLowerCase().contains(query);
      final refMatches = h.reference.toLowerCase().contains(query);
      final idMatches = (h.hadithNo ?? 0).toString() == searchQuery.value;
      return textMatches || refMatches || idMatches;
    }).toList();
  }

  List<LastReadHadith> get filteredLastReadHadiths {
    if (searchQuery.value.isEmpty) return lastReadHadiths;
    return lastReadHadiths.where((h) {
      final query = searchQuery.value.toLowerCase();
      final textMatches = h.hadith.toLowerCase().contains(query);
      final refMatches = h.book.toLowerCase().contains(query);
      final idMatches = (h.hadithNo ?? '').toString() == searchQuery.value;
      return textMatches || refMatches || idMatches;
    }).toList();
  }

  List<HadithChapter> get filteredChapters {
    if (chapterSearchQuery.value.isEmpty) return chapters;
    return chapters.where((c) {
      final query = chapterSearchQuery.value.toLowerCase();
      return c.name.toLowerCase().contains(query) ||
          c.number.toLowerCase().contains(query);
    }).toList();
  }

  List<Hadith> get filteredHadithList {
    if (hadithSearchQuery.value.isEmpty) return hadithList;
    return hadithList.where((h) {
      final query = hadithSearchQuery.value.toLowerCase();
      return h.hadith.toLowerCase().contains(query) ||
          h.heading.toLowerCase().contains(query) ||
          h.number.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchHadithBooks();
    fetchPopularHadith();
    fetchLastReadHadith();
    fetchSavedHadiths();
    _loadDownloadedChapters();
    _loadDownloadedHadiths();
  }

  String _normalize(String? text) {
    if (text == null) return '';
    return text
        .trim()
        .replaceAll('\r', '')
        .replaceAll('\n', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .toLowerCase();
  }

  Future<void> fetchSavedHadiths() async {
    isSavedLoading.value = true;
    try {
      final response = await ApiService.get(ApiEndpoints.savedHadith);
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        savedHadiths.value = data.map((json) {
          // The saved record might have 'hadith' field
          final h = Hadith(
            id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
            number: (json['hadithNo'] ?? json['number'] ?? '').toString(),
            hadith: json['hadith'] ?? '',
            heading: json['book'] ?? '',
          );
          h.isSaved = true;
          h.savedId = json['id']?.toString();
          return h;
        }).toList();
        _syncSaveStatus();
      }
    } catch (e) {
    } finally {
      isSavedLoading.value = false;
    }
  }

  void _syncSaveStatus() {
    if (savedHadiths.isEmpty && !isSavedLoading.value) {
      // If savedHadiths is empty but not loading, it means none are saved
      for (var h in hadithList) h.isSaved = false;
      for (var h in popularHadiths) h.isSaved = false;
      for (var h in lastReadHadiths) h.isSaved = false;
    } else {
      // Normalize saved hadiths once
      final savedTexts = savedHadiths.map((s) => _normalize(s.hadith)).toSet();
      final savedMap = {
        for (var s in savedHadiths) _normalize(s.hadith): s.savedId,
      };

      for (var h in hadithList) {
        final norm = _normalize(h.hadith);
        h.isSaved = savedTexts.contains(norm);
        h.savedId = savedMap[norm];
      }
      for (var h in popularHadiths) {
        final norm = _normalize(h.hadith);
        h.isSaved = savedTexts.contains(norm);
        h.savedId = savedMap[norm];
      }
      for (var h in lastReadHadiths) {
        final norm = _normalize(h.hadith);
        h.isSaved = savedTexts.contains(norm);
        h.savedId = savedMap[norm];
      }
    }

    hadithList.refresh();
    popularHadiths.refresh();
    lastReadHadiths.refresh();
  }

  bool isHadithSaved(String hadithText) {
    final norm = _normalize(hadithText);
    return savedHadiths.any((s) => _normalize(s.hadith) == norm);
  }

  String? getSavedId(String hadithText) {
    final norm = _normalize(hadithText);
    return savedHadiths
        .firstWhereOrNull((s) => _normalize(s.hadith) == norm)
        ?.savedId;
  }

  Future<void> fetchHadithBooks() async {
    isLoading.value = true;
    try {
      // Using static data from separate file
      hadithBooks.value = HadithData.staticHadithBooks;

      /*
      final response = await ApiService.get(ApiEndpoints.hadithBooks);
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        hadithBooks.value = data
            .map((json) => HadithBook.fromJson(json))
            .toList();
      }
      */
    } catch (e) {
      // Error is handled in ApiService
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchHadithChapters(String slug) async {
    isChaptersLoading.value = true;
    chapters.clear();
    try {
      final dir = await getApplicationDocumentsDirectory();
      final cacheDir = Directory("${dir.path}/hadith_chapters_meta");
      if (!await cacheDir.exists()) {
        await cacheDir.create(recursive: true);
      }
      final file = File('${cacheDir.path}/chapters_$slug.json');

      bool apiSuccess = false;
      try {
        final response = await ApiService.get(ApiEndpoints.hadithChapters(slug), showErrorSnackbar: false);
        if (response['success'] == true) {
          final List<dynamic> data = response['data'];
          chapters.value = data
              .map((json) => HadithChapter.fromJson(json))
              .toList();
          await file.writeAsString(jsonEncode(data));
          apiSuccess = true;
        }
      } catch (e) {
        print("API failed for chapters, trying cache: $e");
      }

      if (!apiSuccess && await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> data = jsonDecode(content);
        chapters.value = data
            .map((json) => HadithChapter.fromJson(json))
            .toList();
      }
    } catch (e) {
      print("Error in fetchHadithChapters: $e");
    } finally {
      isChaptersLoading.value = false;
    }
  }

  Future<void> fetchHadithList(String slug, String chapterNum) async {
    isHadithLoading.value = true;
    hadithList.clear();
    final key = "${slug}_$chapterNum";
    
    try {
      // 1. Try to load from offline storage first
      if (downloadedChapters.containsKey(key)) {
        final path = downloadedChapters[key]!;
        final file = File(path);
        if (await file.exists()) {
          final content = await file.readAsString();
          final data = jsonDecode(content);
          if (data is List) {
            hadithList.value = data.map((json) => Hadith.fromJson(json)).toList();
            _syncSaveStatus();
            isHadithLoading.value = false;
            return;
          }
        } else {
          downloadedChapters.remove(key);
          await _saveDownloadedChapters();
        }
      }

      // 2. Fallback to API if not offline
      final response = await ApiService.get(
        ApiEndpoints.hadithList(slug, chapterNum),
      );
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        hadithList.value = data.map((json) => Hadith.fromJson(json)).toList();
        _syncSaveStatus();
      }
    } catch (e) {
      // Error is handled in ApiService
    } finally {
      isHadithLoading.value = false;
    }
  }

  Future<void> fetchPopularHadith() async {
    isPopularLoading.value = true;
    try {
      final response = await ApiService.get(ApiEndpoints.popularHadith);
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        popularHadiths.value = data
            .map((json) => PopularHadith.fromJson(json))
            .toList();
        _syncSaveStatus();
      }
    } catch (e) {
      // Error is handled in ApiService
    } finally {
      isPopularLoading.value = false;
    }
  }

  Future<void> fetchLastReadHadith() async {
    isLastReadLoading.value = true;
    try {
      final response = await ApiService.get(ApiEndpoints.lastReadHadith);
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        lastReadHadiths.value = data
            .map((json) => LastReadHadith.fromJson(json))
            .toList();
        _syncSaveStatus();
      }
    } catch (e) {
      // Error handled in ApiService
    } finally {
      isLastReadLoading.value = false;
    }
  }

  Future<void> toggleSaveHadith({
    required String hadithText,
    required String book,
    required String chapterNo,
    required String hadithNo,
    required bool currentlySaved,
    String? savedId,
  }) async {
    // Optimistic Update
    void setLocalStatus(bool status, String? sId) {
      final normTarget = _normalize(hadithText);
      for (var h in hadithList) {
        if (_normalize(h.hadith) == normTarget) {
          h.isSaved = status;
          h.savedId = sId;
        }
      }
      for (var h in popularHadiths) {
        if (_normalize(h.hadith) == normTarget) {
          h.isSaved = status;
          h.savedId = sId;
        }
      }
      for (var h in lastReadHadiths) {
        if (_normalize(h.hadith) == normTarget) {
          h.isSaved = status;
          h.savedId = sId;
        }
      }
      hadithList.refresh();
      popularHadiths.refresh();
      lastReadHadiths.refresh();
    }

    final prevSaved = currentlySaved;
    final prevId = savedId;
    setLocalStatus(!currentlySaved, currentlySaved ? null : "pending");

    try {
      if (currentlySaved) {
        if (savedId == null || savedId == "pending") return;
        final response = await ApiService.delete(
          ApiEndpoints.deleteSavedHadith(savedId),
        );
        if (response['success'] != true) {
          setLocalStatus(prevSaved, prevId);
        } else {
          fetchSavedHadiths();
        }
      } else {
        final body = {
          "hadith": hadithText,
          "book": book,
          "chapterNo": int.tryParse(chapterNo) ?? 0,
          "hadithNo": int.tryParse(hadithNo) ?? 0,
        };
        final response = await ApiService.post(
          ApiEndpoints.savedHadith,
          body: body,
        );
        if (response['success'] != true) {
          setLocalStatus(prevSaved, prevId);
        } else {
          fetchSavedHadiths();
        }
      }
    } catch (e) {
      setLocalStatus(prevSaved, prevId);
    }
  }

  Future<void> updateLastReadHadith(LastReadHadith lastRead) async {
    try {
      final response = await ApiService.post(
        ApiEndpoints.lastReadHadith,
        body: lastRead.toJson(),
      );
      if (response['success'] == true) {
        fetchLastReadHadith(); // Refresh list after update
      }
    } catch (e) {
      // Error handled in ApiService
    }
  }

  Future<void> _loadDownloadedChapters() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? encoded = prefs.getString(_downloadedChaptersKey);
      if (encoded != null) {
        final Map<String, dynamic> decoded = jsonDecode(encoded);
        downloadedChapters.value = decoded.map(
          (key, value) => MapEntry(key, value.toString()),
        );
      }
    } catch (e) {
      print("Error loading downloaded hadith chapters: $e");
    }
  }

  Future<void> _saveDownloadedChapters() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = jsonEncode(downloadedChapters);
      await prefs.setString(_downloadedChaptersKey, encoded);
    } catch (e) {
      print("Error saving downloaded hadith chapters: $e");
    }
  }

  Future<void> downloadChapter(String bookSlug, String bookName, String chapterNum) async {
    final key = "${bookSlug}_$chapterNum";
    try {
      isDownloadingChapter[key] = true;

      // Fetch from API directly
      final response = await ApiService.get(
        ApiEndpoints.hadithList(bookSlug, chapterNum),
      );

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> data = response['data'];

        final dir = await getApplicationDocumentsDirectory();
        final hdDir = Directory("${dir.path}/hadith_chapters");
        if (!await hdDir.exists()) {
          await hdDir.create(recursive: true);
        }

        final fileName = 'chapter_$key.json';
        final filePath = '${hdDir.path}/$fileName';
        final file = File(filePath);

        await file.writeAsString(jsonEncode(data));

        downloadedChapters[key] = filePath;
        await _saveDownloadedChapters();

        SnackbarUtils.showSnackbar(
          tr("download_complete"),
          "$bookName ${tr("chapters")} ${tr("hadith_chapter")} $chapterNum ${tr("downloaded_successfully")}",
        );
      } else {
        throw Exception("Failed to fetch chapter data");
      }
    } catch (e) {
      SnackbarUtils.showSnackbar(
        tr("error"),
        "${tr("download_failed")}: ${e.toString().replaceAll('Exception: ', '')}",
        isError: true,
      );
    } finally {
      isDownloadingChapter[key] = false;
    }
  }

  Future<void> deleteDownloadedChapter(String bookSlug, String chapterNum) async {
    final key = "${bookSlug}_$chapterNum";
    try {
      if (downloadedChapters.containsKey(key)) {
        final path = downloadedChapters[key]!;
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
        }

        downloadedChapters.remove(key);
        await _saveDownloadedChapters();

        SnackbarUtils.showSnackbar(
          tr("success"),
          tr("hadith_deleted_from_offline"), 
        );
      }
    } catch (e) {
      print("Delete chapter error: $e");
      SnackbarUtils.showSnackbar(tr("error"), "${tr("error")}: $e", isError: true);
    }
  }

  Future<void> _loadDownloadedHadiths() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? encoded = prefs.getString(_downloadedHadithsKey);
      if (encoded != null) {
        final Map<String, dynamic> decoded = jsonDecode(encoded);
        downloadedHadiths.value = decoded.map(
          (key, value) => MapEntry(key, value.toString()),
        );
      }
    } catch (e) {
      print("Error loading downloaded hadiths: $e");
    }
  }

  Future<void> _saveDownloadedHadiths() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = jsonEncode(downloadedHadiths);
      await prefs.setString(_downloadedHadithsKey, encoded);
    } catch (e) {
      print("Error saving downloaded hadiths: $e");
    }
  }

  Future<void> downloadHadith({
    required String hadithText,
    required String bookSlug,
    required String bookName,
    required String chapterNum,
    required String hadithNumber,
    String? heading,
  }) async {
    final key = "${bookSlug}_$hadithNumber";
    try {
      isDownloadingHadith[key] = true;

      final dir = await getApplicationDocumentsDirectory();
      final hdDir = Directory("${dir.path}/hadith_saves");
      if (!await hdDir.exists()) {
        await hdDir.create(recursive: true);
      }

      final fileName = 'hadith_$key.json';
      final filePath = '${hdDir.path}/$fileName';
      final file = File(filePath);

      final fullData = {
        "hadith": hadithText,
        "bookSlug": bookSlug,
        "bookName": bookName,
        "chapterNum": chapterNum,
        "hadithNumber": hadithNumber,
        "heading": heading ?? "",
      };

      await file.writeAsString(jsonEncode(fullData));

      downloadedHadiths[key] = filePath;
      await _saveDownloadedHadiths();

      SnackbarUtils.showSnackbar(
        tr("download_complete"),
        "$bookName ${tr("hadith")} $hadithNumber ${tr("downloaded_successfully")}",
      );
    } catch (e) {
      SnackbarUtils.showSnackbar(
        tr("error"),
        "${tr("download_failed")}: ${e.toString().replaceAll('Exception: ', '')}",
        isError: true,
      );
    } finally {
      isDownloadingHadith[key] = false;
    }
  }

  Future<void> deleteDownloadedHadith(String bookSlug, String hadithNumber) async {
    final key = "${bookSlug}_$hadithNumber";
    try {
      if (downloadedHadiths.containsKey(key)) {
        final path = downloadedHadiths[key]!;
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
        }
        
        downloadedHadiths.remove(key);
        await _saveDownloadedHadiths();

        SnackbarUtils.showSnackbar(
          tr("success"),
          tr("hadith_deleted_from_offline"), 
        );
      }
    } catch (e) {
      print("Delete error: $e");
      SnackbarUtils.showSnackbar(tr("error"), "${tr("error")}: $e", isError: true);
    }
  }
}
