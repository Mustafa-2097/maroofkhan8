import 'package:get/get.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_service.dart';
import '../model/surah_model.dart';
import '../../../core/offline_storage/shared_pref.dart';

class QuranController extends GetxController {
  var surahList = <SurahModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSurahs();
  }

  Future<void> fetchSurahs() async {
    try {
      isLoading.value = true;
      final token = await SharedPreferencesHelper.getToken();
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await ApiService.get(
        ApiEndpoints.Surah,
        headers: headers,
      );

      if (response['data'] != null && response['data'] is List) {
        final List<dynamic> chapters = response['data'];
        surahList.value = chapters
            .map((json) => SurahModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      // Error is already handled by ApiService.get with a snackbar
      print("Error fetching surahs: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
