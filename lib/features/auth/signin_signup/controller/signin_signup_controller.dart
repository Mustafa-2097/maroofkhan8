import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maroofkhan8/features/auth/forgot_password/view/forgot_password_page.dart';

class SignInSignUpController extends GetxController {
  static SignInSignUpController get instance => Get.find();

  /// Determines whether Sign In or Sign Up UI is shown
  final isLogin = true.obs;

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
      ///
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
