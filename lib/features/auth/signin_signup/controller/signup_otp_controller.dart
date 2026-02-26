import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../core/network/api_Service.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/offline_storage/shared_pref.dart';
import '../controller/signin_signup_controller.dart';

class SignupOtpController extends GetxController {
  static SignupOtpController get instance => Get.find();

  /// OTP value
  var otp = "".obs;

  /// Timer countdown 60 seconds
  var secondsRemaining = 60.obs;
  Timer? _timer;

  /// Whether user can resend OTP
  var canResend = false.obs;

  // email variable passed
  var email = "".obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments["email"] != null) {
      email.value = Get.arguments["email"];
    }
    startTimer();
  }

  /// Start 60-second countdown
  void startTimer() {
    secondsRemaining.value = 60;
    canResend.value = false;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  /// Validate OTP
  String? validateOtp() {
    if (otp.value.length < 6) return "Enter the 6-digit code";
    return null;
  }

  /// Verify OTP
  Future<void> verifyOtp() async {
    final error = validateOtp();

    if (error != null) {
      EasyLoading.showError(error);
      return;
    }

    EasyLoading.show(status: 'Verifying...');

    try {
      final body = {"email": email.value, "otp": otp.value};

      final response = await ApiService.post(
        ApiEndpoints.verifySignUpOtp,
        body: body,
      );

      if (response['data'] != null && response['data']['accessToken'] != null) {
        await SharedPreferencesHelper.saveToken(
          response['data']['accessToken'],
        );
      }

      EasyLoading.dismiss();

      // Close the OTP page first
      Get.back();

      if (Get.isRegistered<SignInSignUpController>()) {
        Get.find<SignInSignUpController>().showLogin();
      }

      // Show snackbar AFTER navigating back so Get.back() doesn't accidentally dismiss the snackbar
      Get.snackbar(
        'Success',
        response['message'] ?? 'Email verified successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  /// Resend OTP
  Future<void> resendOtp() async {
    if (!canResend.value) return;

    EasyLoading.show(status: "Sending new code...");

    try {
      final body = {"email": email.value};

      final response = await ApiService.post(
        ApiEndpoints.resendOtp,
        body: body,
      );

      EasyLoading.dismiss();

      Get.snackbar(
        'Success',
        response['message'] ?? 'OTP resent successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      startTimer();
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
