import 'package:get/get.dart';
import '../../../core/network/api_Service.dart';
import '../../../core/network/api_endpoints.dart';
import '../model/sahaba_model.dart';
import 'package:flutter/foundation.dart';

class SahabaController extends GetxController {
  static SahabaController get instance => Get.find();

  var sahabaList = <Sahaba>[].obs;
  var isLoading = false.obs;

  var selectedSahaba = Rxn<Sahaba>();
  var isDetailLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSahaba();
  }

  Future<void> fetchSahaba() async {
    isLoading.value = true;
    try {
      final response = await ApiService.get(ApiEndpoints.sahaba);
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        sahabaList.value = data.map((json) => Sahaba.fromJson(json)).toList();
      }
    } catch (e) {
      if (kDebugMode) print("Error fetching Sahaba: $e");
      sahabaList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSahabaDetails(String id) async {
    isDetailLoading.value = true;
    try {
      final response = await ApiService.get(ApiEndpoints.sahabaDetails(id));
      if (response['success'] == true) {
        selectedSahaba.value = Sahaba.fromJson(response['data']);
      }
    } catch (e) {
      if (kDebugMode) print("Error fetching Sahaba details: $e");
    } finally {
      isDetailLoading.value = false;
    }
  }
}
