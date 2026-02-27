import 'package:get/get.dart';
import '../../../core/network/api_Service.dart';
import '../../../core/network/api_endpoints.dart';
import '../models/hadith_book.dart';
import '../models/hadith_chapter.dart';
import '../models/hadith.dart';
import '../models/popular_hadith.dart';
import '../models/last_read_hadith.dart';

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
      final response = await ApiService.get(ApiEndpoints.hadithBooks);
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        hadithBooks.value = data
            .map((json) => HadithBook.fromJson(json))
            .toList();
      }
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
