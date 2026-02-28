import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:maroofkhan8/features/auth/forgot_password/view/password_changed.dart';
import '../../../../core/network/api_Service.dart';
import '../../../../core/network/api_endpoints.dart';

class ResetPasswordController extends GetxController {
  static ResetPasswordController get instance => Get.find();

  // Form Key for validation
  final resetPasswordFormKey = GlobalKey<FormState>();

  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;
  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  late final String token;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      token = Get.arguments['token'] ?? "";
    } else {
      token = "";
    }
  }

  void resetPassword() async {
    // This triggers the "validator" functions in the TextFormFields
    if (!resetPasswordFormKey.currentState!.validate()) {
      return;
    }

    EasyLoading.show(status: 'Resetting password...');

    try {
      final body = {"token": token, "password": passwordController.text};

      final response = await ApiService.post(
        ApiEndpoints.resetPassword,
        body: body,
      );

      EasyLoading.dismiss();

      Get.offAll(() => PasswordChange());

      Get.snackbar(
        'Success',
        response['message'] ?? 'Password reset successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
