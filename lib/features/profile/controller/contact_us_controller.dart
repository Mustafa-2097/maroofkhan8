import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ContactUsController extends GetxController {
  static ContactUsController get instance => Get.find();

  /// Text Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();

  /// Submit logic
  Future<void> contactChange(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;

    try {
      EasyLoading.show(status: 'Sending...');
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      EasyLoading.dismiss();
      Get.snackbar(
        "Success",
        "Your message has been sent!",
        backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.9),
        colorText: Colors.white,
      );
      messageController.clear();

    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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