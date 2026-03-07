import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../features/auth/signin_signup/view/signin_signup_page.dart';

class LanguageController extends GetxController {
  static LanguageController get instance => Get.find();
  final selectedLanguage = 'English'.obs;

  final languages = ['English', 'Arabic', 'Urdu', 'Hindi'];

  void selectLanguage(String language, BuildContext context) {
    selectedLanguage.value = language;
    Locale newLocale = const Locale('en');
    if (language == 'Arabic') newLocale = const Locale('ar');
    if (language == 'Urdu') newLocale = const Locale('ur');
    if (language == 'Hindi') newLocale = const Locale('hi');

    context.setLocale(newLocale);
    Get.updateLocale(newLocale);
  }

  void onGetStarted() {
    // Save language / navigate next
    Get.offAll(() => SignInSignUpPage());
  }
}
