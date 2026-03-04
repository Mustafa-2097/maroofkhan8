import 'package:get/get.dart';
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
      final response = await ApiService.get(ApiEndpoints.hadithChapters(slug));
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        chapters.value = data
            .map((json) => HadithChapter.fromJson(json))
            .toList();
      }
    } finally {
      isChaptersLoading.value = false;
    }
  }

  Future<void> fetchHadithList(String slug, String chapterNum) async {
    isHadithLoading.value = true;
    hadithList.clear();
    try {
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
}
