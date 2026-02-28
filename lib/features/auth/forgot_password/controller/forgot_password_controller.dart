import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../../core/network/api_Service.dart';
import '../../../../core/network/api_endpoints.dart';
import '../view/otp_verification_page.dart';

class ForgotPasswordController extends GetxController {
  static ForgotPasswordController get instance => Get.find();

  /// Form Key for validation
  final forgotPasswordFormKey = GlobalKey<FormState>();

  /// Controllers
  final emailController = TextEditingController();

  /// Method to handle button click
  void sendCode() async {
    // This triggers the "validator" functions in the TextFormFields
    if (!forgotPasswordFormKey.currentState!.validate()) {
      return;
    }

    EasyLoading.show(status: 'Sending code...');
    try {
      final body = {"email": emailController.text.trim()};

      final response = await ApiService.post(
        ApiEndpoints.sendResetOtp,
        body: body,
      );

      EasyLoading.dismiss();

      Get.snackbar(
        'Success',
        response['message'] ?? 'OTP Sent to your Email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.to(
        () => OtpVerificationPage(),
        arguments: {'email': emailController.text.trim()},
      );
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
