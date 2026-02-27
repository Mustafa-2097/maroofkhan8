import 'package:get/get.dart';
import '../../../core/network/api_Service.dart';
import '../../../core/network/api_endpoints.dart';
import '../models/hadith_book.dart';
import '../models/hadith_chapter.dart';

class HadithController extends GetxController {
  static HadithController get instance => Get.find();

  var isLoading = false.obs;
  var hadithBooks = <HadithBook>[].obs;

  var isChaptersLoading = false.obs;
  var chapters = <HadithChapter>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHadithBooks();
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
    } catch (e) {
      // Error is handled in ApiService
    } finally {
      isChaptersLoading.value = false;
    }
  }
}
