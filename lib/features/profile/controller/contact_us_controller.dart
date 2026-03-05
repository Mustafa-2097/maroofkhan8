import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../core/network/api_Service.dart';
import '../../../core/network/api_endpoints.dart';
import 'profile_controller.dart';

class ContactUsController extends GetxController {
  static ContactUsController get instance => Get.find();

  /// Text Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    try {
      if (Get.isRegistered<ProfileController>()) {
        final profileController = Get.find<ProfileController>();
        nameController.text = profileController.name.value;
        emailController.text = profileController.email.value;
      }
    } catch (e) {
      debugPrint("ProfileController error: $e");
    }
  }

  /// Submit logic
  Future<void> contactChange(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;

    try {
      EasyLoading.show(status: 'Sending...');

      final response = await ApiService.post(
        ApiEndpoints.contactUs,
        body: {'message': messageController.text.trim()},
      );

      EasyLoading.dismiss();
      if (response['success'] == true) {
        SnackbarUtils.showSnackbar(
          "Success",
          response['message'] ?? "Your message has been sent!",
        );
        messageController.clear();
      } else {
        SnackbarUtils.showSnackbar(
          "Error",
          response['message'] ?? "Failed to send message",
          isError: true,
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      SnackbarUtils.showSnackbar("Error", e.toString(), isError: true);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
