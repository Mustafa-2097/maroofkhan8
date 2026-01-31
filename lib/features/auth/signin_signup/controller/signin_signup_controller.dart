import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../bottom_nav_bar.dart';

class SignInSignUpController extends GetxController {
  static SignInSignUpController get instance => Get.find();

  /// Determines whether Sign In or Sign Up UI is shown
  final isLogin = true.obs;

  // Add these two variables
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  void togglePasswordVisibility() => isPasswordVisible.value = !isPasswordVisible.value;
  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  /// Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  /// Switch to Sign In
  void showLogin() {
    isLogin.value = true;
  }

  /// Switch to Sign Up
  void showRegister() {
    isLogin.value = false;
  }

  /// Submit handler
  void submit() {
    if (isLogin.value) {
      Get.to(CustomBottomNavBar());
    } else {
      /// Handle sign up
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
