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
          ? AppColors.primaryColorLight
          : AppColors.primaryColorLight,
      colorText: Colors.white,
      margin: const EdgeInsets.all(15),
      borderRadius: 10,
      duration: const Duration(seconds: 3),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }
}
