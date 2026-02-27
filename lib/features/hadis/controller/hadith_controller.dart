import 'package:get/get.dart';
import '../../../core/network/api_Service.dart';
import '../../../core/network/api_endpoints.dart';
import '../models/hadith_book.dart';

class HadithController extends GetxController {
  static HadithController get instance => Get.find();

  var isLoading = false.obs;
  var hadithBooks = <HadithBook>[].obs;

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
      // Error is handled in ApiService (snackbar shown)
    } finally {
      isLoading.value = false;
    }
  }
}
