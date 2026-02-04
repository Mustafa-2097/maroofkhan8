import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonalDataController extends GetxController {
  // Use Get.isDarkMode instead of Theme.of(context)
  bool get isDark => Get.isDarkMode;

  final formKey = GlobalKey<FormState>();

  // Controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();

  // Reactive variables for dropdowns
  var selectedCountry = "Bangladesh".obs;
  var selectedGender = "Male".obs;

  void saveProfile() {
    // Check if the form is valid
    if (formKey.currentState?.validate() ?? false) {

      // Logic for saving (e.g., API call) goes here

      Get.back();

      Get.snackbar(
        "Success",
        "Profile updated successfully!",
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  void onClose() {
    // Always dispose of controllers to prevent memory leaks
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    dobController.dispose();
    super.onClose();
  }
}