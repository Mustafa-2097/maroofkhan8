import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constant/app_colors.dart';

class SnackbarUtils {
  static String? _lastShownMessage;
  static DateTime? _lastShownTime;

  static void showSnackbar(
    String title,
    String message, {
    bool isError = false,
  }) {
    final now = DateTime.now();
    if (_lastShownMessage == message &&
        _lastShownTime != null &&
        now.difference(_lastShownTime!) < const Duration(seconds: 3)) {
      return; // Skip if the same message was shown recently
    }

    _lastShownMessage = message;
    _lastShownTime = now;

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.primaryColorLight.withOpacity(0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(15),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      icon: Icon(
        isError ? Icons.error_outline : Icons.check_circle_outline,
        color: Colors.white,
      ),
      shouldIconPulse: true,
      barBlur: 10,
      overlayBlur: 0.5,
    );
  }
}
