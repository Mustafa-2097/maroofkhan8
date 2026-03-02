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
      }
    } catch (e) {
      // Error handled in ApiService
    } finally {
      isLastReadLoading.value = false;
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
