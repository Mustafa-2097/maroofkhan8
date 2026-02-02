import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view/otp_verification_page.dart';

class ForgotPasswordController extends GetxController {
  static ForgotPasswordController get instance => Get.find();

  /// Form Key for validation
  final forgotPasswordFormKey = GlobalKey<FormState>();

  /// Controllers
  final emailController = TextEditingController();

  /// Method to handle button click
  void sendCode() {
    // This triggers the "validator" functions in the TextFormFields
    if (!forgotPasswordFormKey.currentState!.validate()) {
      return;
    }

    // Logic for sending code
    print("Sending code to: ${emailController.text}");
    Get.to(() => OtpVerificationPage());
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
