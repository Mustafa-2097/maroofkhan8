import 'package:get/get.dart';

class LanguageController extends GetxController {
  static LanguageController get instance => Get.find();
  final selectedLanguage = 'Arabic'.obs;

  final languages = [
    'Arabic',
    'Urdu',
    'English',
    'Hindi',
  ];

  void selectLanguage(String language) {
    selectedLanguage.value = language;
  }

  void onGetStarted() {
    // Save language / navigate next
    // Example:
    // Get.offAll(() => const SignInScreen());
  }
}
