import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maroofkhan8/features/auth/forgot_password/view/password_changed.dart';

class ResetPasswordController extends GetxController {
  static ResetPasswordController get instance => Get.find();

  // Form Key for validation
  final resetPasswordFormKey = GlobalKey<FormState>();

  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  void togglePasswordVisibility() => isPasswordVisible.value = !isPasswordVisible.value;
  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void resetPassword() {
    // This triggers the "validator" functions in the TextFormFields
    if (!resetPasswordFormKey.currentState!.validate()) {
      return;
    }

    // If validation passes, proceed with logic
    print("Password reset successfully logic here");
    Get.offAll(() => PasswordChange());
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
