import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:share_plus/share_plus.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/offline_storage/shared_pref.dart';
import '../model/salawat_model.dart';

class SalawatController extends GetxController {
  var isLoading = false.obs;
  var salawatList = <SalawatData>[].obs;
  var searchQuery = ''.obs;

  List<SalawatData> get filteredSalawat {
    if (searchQuery.value.isEmpty) {
      return salawatList;
    }
    return salawatList
        .where(
          (salawat) =>
              salawat.title?.toLowerCase().contains(
                searchQuery.value.toLowerCase(),
              ) ??
              false,
        )
        .toList();
  }

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

  Future<SalawatData?> fetchSalawatDetails(String id) async {
    try {
      isLoading.value = true;
      final token = await SharedPreferencesHelper.getToken();
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': '$token',
      };

      final url = Uri.parse("${ApiEndpoints.salawat}/$id");
      final response = await http.get(url, headers: headers);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true) {
          return SalawatData.fromJson(decoded['data']);
        }
      }
    } catch (e) {
      print("Error fetching salawat details: $e");
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  void shareSalawat(SalawatData salawat) {
    if (salawat.title == null) return;
    String content = "Salawat: ${salawat.title}\n\n";
    if (salawat.arabic != null) content += "${salawat.arabic}\n\n";
    if (salawat.translation != null)
      content += "Translation: ${salawat.translation}\n\n";
    if (salawat.transliteration != null)
      content += "Transliteration: ${salawat.transliteration}\n\n";
    content += "Shared via Maroof Khan App";

    Share.share(content);
  }

  Future<void> downloadSalawat(SalawatData salawat) async {
    if (salawat.audio == null) {
      Get.snackbar("Error", "No audio file available for download");
      return;
    }
    // Simulated download logic as done in AudioController
    Get.snackbar(
      "Download Started",
      "Downloading audio for ${salawat.title}...",
    );
    await Future.delayed(const Duration(seconds: 2));
    Get.snackbar(
      "Download Complete",
      "Audio for ${salawat.title} has been saved.",
    );
  }
}
