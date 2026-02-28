import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/network/api_endpoints.dart';
import '../../../core/offline_storage/shared_pref.dart';
import '../model/meditation_model.dart';

class MeditationController extends GetxController {
  var isLoading = false.obs;
  var meditationList = <MeditationData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMeditation();
  }

  Future<void> fetchMeditation() async {
    try {
      isLoading.value = true;
      final token = await SharedPreferencesHelper.getToken();

      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': '$token',
        if (token != null) 'token': '$token',
        if (token != null) 'access_token': '$token',
      };

      final url = Uri.parse(ApiEndpoints.meditation);
      final response = await http.get(url, headers: headers);

      print("DEBUG: Meditation Status Code: ${response.statusCode}");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        final medRes = MeditationResponse.fromJson(decoded);
        if (medRes.data != null) {
          meditationList.value = medRes.data!;
        }
      }
    } catch (e) {
      print("Error fetching meditation: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
