import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  static ResetPasswordController get instance => Get.find();

  // Add these two variables
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  void togglePasswordVisibility() => isPasswordVisible.value = !isPasswordVisible.value;
  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  /// Controllers
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void resetPassword() {
    String pass = passwordController.text.trim();
    String confirmPass = confirmPasswordController.text.trim();

    if (pass.isEmpty || confirmPass.isEmpty) {
      Get.snackbar("Error", "Please fill all fields", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (pass != confirmPass) {
      Get.snackbar("Error", "Passwords do not match", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (pass.length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // If successful:
    print("Password reset successfully for code logic");
    // Get.offAllNamed('/login');
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
