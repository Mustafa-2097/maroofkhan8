import 'package:get/get.dart';
import '../../../../core/network/api_Service.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/dhikr_model.dart';
import 'package:flutter/foundation.dart';

class DhikrController extends GetxController {
  static DhikrController get instance => Get.find();

  var tasbihList = <DhikrModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTasbihs();
  }

  Future<void> fetchTasbihs() async {
    isLoading.value = true;
    try {
      final response = await ApiService.get(ApiEndpoints.tasbih);
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        tasbihList.value = data
            .map((json) => DhikrModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      if (kDebugMode) print("Error fetching Tasbihs: $e");
      tasbihList.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
