import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/network/api_endpoints.dart';
import '../../../core/offline_storage/shared_pref.dart';
import '../model/salawat_model.dart';

class SalawatController extends GetxController {
  var isLoading = false.obs;
  var salawatList = <SalawatData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSalawat();
  }

  Future<void> fetchSalawat() async {
    try {
      isLoading.value = true;
      final token = await SharedPreferencesHelper.getToken();

      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': '$token',
        if (token != null) 'token': '$token',
        if (token != null) 'access_token': '$token',
      };

      final url = Uri.parse(ApiEndpoints.salawat);
      final response = await http.get(url, headers: headers);

      print("DEBUG: Salawat Status Code: ${response.statusCode}");
      print("DEBUG: Salawat Response Body: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        final salawatRes = SalawatResponse.fromJson(decoded);
        if (salawatRes.data != null) {
          salawatList.value = salawatRes.data!;
        }
      }
    } catch (e) {
      print("Error fetching salawat: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
