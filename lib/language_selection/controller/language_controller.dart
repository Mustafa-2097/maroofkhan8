import 'package:get/get.dart';
import '../../features/auth/signin_signup/view/signin_signup_page.dart';

class LanguageController extends GetxController {
  static LanguageController get instance => Get.find();
  final selectedLanguage = 'English'.obs;

  final languages = [
    'English',
    'Arabic',
    'Urdu',
    'Hindi',
  ];

  void selectLanguage(String language) {
    selectedLanguage.value = language;
  }

  void onGetStarted() {
    // Save language / navigate next
    Get.offAll(() => SignInSignUpPage());
  }
}
