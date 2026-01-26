import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/offline_storage/shared_pref.dart';
import '../../language_selection/view/language_screen.dart';

class OnboardingController extends GetxController {
  /// Page controller for PageView
  final PageController pageController = PageController();

  /// Current onboarding page index
  final currentIndex = 0.obs;

  /// Total pages count
  final int totalPages = 2;

  /// Page change handler
  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  /// Handle Get Started / Next button
  void onGetStarted() {
    if (currentIndex.value < totalPages - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      finishOnboarding();
    }
  }

  /// Final navigation after onboarding
  Future<void> finishOnboarding() async {
    await SharedPreferencesHelper.setOnboardingCompleted();
    Get.offAll(() =>  LanguageScreen());
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
