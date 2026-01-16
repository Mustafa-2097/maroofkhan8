import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

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
    email = Get.arguments["email"];
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

    //await AuthService.verifyOtpCode(email: email, code: otp.value);
  }

  /// Resend OTP
  Future<void> resendOtp() async {
    if (!canResend.value) return;

    EasyLoading.show(status: "Sending new code...");

    await Future.delayed(const Duration(seconds: 2));

    EasyLoading.dismiss();
    //EasyLoading.showSuccess("New code sent");

    startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}