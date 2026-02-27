import 'package:get/get.dart';
import '../../../../core/network/api_Service.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/awliya_allah_model.dart';
import 'package:flutter/foundation.dart';

class AwliyaAllahController extends GetxController {
  static AwliyaAllahController get instance => Get.find();

  var awliyaList = <AwliyaAllah>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAwliya();
  }

  Future<void> fetchAwliya() async {
    isLoading.value = true;
    try {
      final response = await ApiService.get(ApiEndpoints.awliya);
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        awliyaList.value = data
            .map((json) => AwliyaAllah.fromJson(json))
            .toList();
      }
    } catch (e) {
      if (kDebugMode) print("Error fetching Awliya Allah: $e");
      awliyaList.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
