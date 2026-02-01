import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../bottom_nav_bar.dart';

class SignInSignUpController extends GetxController {
  static SignInSignUpController get instance => Get.find();

  // 1. Add Form Key and Error Tracker
  final formKey = GlobalKey<FormState>();
  var showErrors = false.obs;

  final isLogin = true.obs;
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  void togglePasswordVisibility() => isPasswordVisible.value = !isPasswordVisible.value;
  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void showLogin() {
    isLogin.value = true;
    showErrors.value = false; // Reset error state when switching
  }

  void showRegister() {
    isLogin.value = false;
    showErrors.value = false; // Reset error state when switching
  }

  void submit() {
    // 2. Enable error visibility on button click
    showErrors.value = true;

    if (formKey.currentState!.validate()) {
      if (isLogin.value) {
        Get.to(const CustomBottomNavBar());
      } else {
        print("Sign Up Logic Here");
      }
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
