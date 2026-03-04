import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../core/utils/snackbar_utils.dart';

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
      SnackbarUtils.showSnackbar("Success", "Your message has been sent!");
      messageController.clear();
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
