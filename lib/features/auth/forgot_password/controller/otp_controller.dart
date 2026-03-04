import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../core/network/api_Service.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../view/reset_password.dart';

class VerificationCodeController extends GetxController {
  static VerificationCodeController get instance => Get.find();

  /// OTP value
  var otp = "".obs;

  /// Timer countdown 20 seconds
  var secondsRemaining = 20.obs;
  Timer? _timer;

  /// Whether user can resend OTP
  var canResend = false.obs;

  // email variable passed
  late final String email;

  @override
  void onInit() {
    super.onInit();
    // Use the null-aware operator and provide a fallback to prevent crashing
    if (Get.arguments != null && Get.arguments["email"] != null) {
      email = Get.arguments["email"];
    } else {
      email = "Unknown"; // Or handle this error appropriately
    }
    startTimer();
  }

  /// Start 20-second countdown
  void startTimer() {
    secondsRemaining.value = 20;
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
      final body = {"email": email, "otp": otp.value};

      final response = await ApiService.post(
        ApiEndpoints.verifyResetOtp,
        body: body,
      );

      EasyLoading.dismiss();

      final token = response['data']?['token'] ?? response['token'] ?? '';

      Get.to(() => ResetPassword(), arguments: {"token": token});

      SnackbarUtils.showSnackbar(
        'Success',
        response['message'] ?? 'OTP verified successfully',
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
      final body = {"email": email};

      final response = await ApiService.post(
        ApiEndpoints.sendResetOtp,
        body: body,
      );

      EasyLoading.dismiss();

      SnackbarUtils.showSnackbar(
        'Success',
        response['message'] ?? 'New code sent',
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
