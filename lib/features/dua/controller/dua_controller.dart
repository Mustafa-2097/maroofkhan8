import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/network/api_endpoints.dart';
import '../../../core/offline_storage/shared_pref.dart';
import '../model/dua_model.dart';

class DuaController extends GetxController {
  var duaList = <DuaData>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDuas();
  }

  Future<void> fetchDuas() async {
    try {
      isLoading.value = true;
      final token = await SharedPreferencesHelper.getToken();

      final headers = {
        if (token != null) 'Authorization': '$token',
        if (token != null) 'token': '$token',
        if (token != null) 'access_token': '$token',
      };

      final url = Uri.parse(ApiEndpoints.duas);
      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 30));

      print("DEBUG: Duas Status Code: ${response.statusCode}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        dynamic data = decoded['data'];
        if (data != null && data is List) {
          duaList.value = data.map((json) => DuaData.fromJson(json)).toList();
        }
      } else {
        print(
          "DEBUG: Duas API rejected request with status ${response.statusCode}",
        );
        duaList.clear();
      }
    } catch (e) {
      print("Error fetching duas: $e");
      duaList.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
