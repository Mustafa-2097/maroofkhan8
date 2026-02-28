import 'package:get/get.dart';
import '../../../core/network/api_Service.dart';
import '../../../core/network/api_endpoints.dart';
import '../model/ahle_bait_model.dart';
import 'package:flutter/foundation.dart';

class AhleBaitController extends GetxController {
  static AhleBaitController get instance => Get.find();

  var ahlalbaytList = <AhleBait>[].obs;
  var isLoading = false.obs;

  var selectedMember = Rxn<AhleBait>();
  var isDetailLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAhlAlBayt();
  }

  Future<void> fetchAhlAlBayt() async {
    isLoading.value = true;
    try {
      final response = await ApiService.get(ApiEndpoints.ahlalbayt);
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        ahlalbaytList.value = data
            .map((json) => AhleBait.fromJson(json))
            .toList();
      }
    } catch (e) {
      if (kDebugMode) print("Error fetching Ahl Al Bayt: $e");
      ahlalbaytList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMemberDetails(String id) async {
    isDetailLoading.value = true;
    try {
      final response = await ApiService.get(ApiEndpoints.ahlalbaytDetails(id));
      if (response['success'] == true) {
        selectedMember.value = AhleBait.fromJson(response['data']);
      }
    } catch (e) {
      if (kDebugMode) print("Error fetching Ahl Al Bayt details: $e");
    } finally {
      isDetailLoading.value = false;
    }
  }
}
