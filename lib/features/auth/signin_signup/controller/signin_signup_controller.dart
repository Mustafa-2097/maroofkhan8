import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../bottom_nav_bar.dart';

class SignInSignUpController extends GetxController {
  static SignInSignUpController get instance => Get.find();

  final formKey = GlobalKey<FormState>();
  var showErrors = false.obs;

  final isLogin = true.obs;
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void togglePasswordVisibility() => isPasswordVisible.value = !isPasswordVisible.value;
  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  // --- FIX STARTS HERE ---

  void showLogin() {
    if (isLogin.value) return; // Do nothing if already on Login
    isLogin.value = true;
    _resetFormState();
  }

  void showRegister() {
    if (!isLogin.value) return; // Do nothing if already on Register
    isLogin.value = false;
    _resetFormState();
  }

  /// Clears validation errors and sensitive fields when switching tabs
  void _resetFormState() {
    showErrors.value = false;

    // 1. Reset the UI validation (removes red error text)
    formKey.currentState?.reset();

    // 2. Clear password fields for security/UX when switching
    passwordController.clear();
    confirmPasswordController.clear();

    // Optional: If you want to clear EVERYTHING (including email/name) when switching:
    // emailController.clear();
    // nameController.clear();

    // Reset visibility icons to hidden
    isPasswordVisible.value = false;
    isConfirmPasswordVisible.value = false;
  }

  // --- FIX ENDS HERE ---

  void submit() {
    showErrors.value = true;
    if (formKey.currentState!.validate()) {
      if (isLogin.value) {
        Get.to(() => const CustomBottomNavBar());
      } else {
        print("Sign Up Logic: ${nameController.text}, ${emailController.text}");
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
