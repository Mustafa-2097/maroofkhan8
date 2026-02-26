import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../core/network/api_Service.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../bottom_nav_bar.dart';
import '../view/signup_otp_verification_page.dart';

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
  final phoneController = TextEditingController();

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;
  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

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
    // phoneController.clear();

    // Reset visibility icons to hidden
    isPasswordVisible.value = false;
    isConfirmPasswordVisible.value = false;
  }

  // --- FIX ENDS HERE ---

  void submit() async {
    showErrors.value = true;
    if (formKey.currentState!.validate()) {
      if (isLogin.value) {
        await _loginUser();
      } else {
        await _registerUser();
      }
    }
  }

  Future<void> _loginUser() async {
    EasyLoading.show(status: 'Logging in...');
    try {
      final body = {
        "email": emailController.text.trim(),
        "password": passwordController.text,
      };

      final response = await ApiService.post(ApiEndpoints.login, body: body);

      EasyLoading.dismiss();

      Get.snackbar(
        'Success',
        response['message'] ?? 'Login successful',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAll(() => const CustomBottomNavBar());
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  Future<void> _registerUser() async {
    EasyLoading.show(status: 'Registering...');
    try {
      final body = {
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": phoneController.text.trim(),
        "password": passwordController.text,
      };

      final response = await ApiService.post(ApiEndpoints.register, body: body);

      EasyLoading.dismiss();

      Get.snackbar(
        'Success',
        response['message'] ?? 'OTP Sent to your Email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.to(
        () => SignupOtpVerificationPage(),
        arguments: {'email': emailController.text.trim()},
      );
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
