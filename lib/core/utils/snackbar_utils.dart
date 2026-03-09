import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constant/app_colors.dart';

class SnackbarUtils {
  static void showSnackbar(
    String title,
    String message, {
    bool isError = false,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: isError
          ? AppColors.redColor.withOpacity(0.9)
          : AppColors.primaryColorLight.withOpacity(0.9),
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
