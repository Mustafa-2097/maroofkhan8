import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroofkhan8/onboarding/view/widgets/onboarding_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/constant/app_colors.dart';
import '../controllers/onboarding_controller.dart';
import '../model/onboarding_data.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Stack(
          children: [
            /// ---------------- PageView ----------------
            PageView.builder(
              controller: controller.pageController,
              itemCount: pages.length,
              onPageChanged: controller.onPageChanged,
              itemBuilder: (context, index) {
                return OnboardingPage(data: pages[index]);
              },
            ),

            /// ---------------- Skip Button ----------------
            Positioned(
              top: 20,
              right: 20,
              child: Obx(() {
                final page = controller.currentPage.value;
                return page < 2
                    ? GestureDetector(
                  onTap: controller.skip,
                  child: Text(
                    "Skip",
                    style: GoogleFonts.plusJakartaSans(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.whiteColor),
                  ),
                )
                    : const SizedBox.shrink();
              }),
            ),

            /// ---------------- Page Indicator ----------------
            Positioned(
              bottom: kBottomNavigationBarHeight * 1.8,
              left: 0,
              right: 0,
              child: Center(
                child: Obx(() {
                  /// This ensures reactive update
                  final page = controller.currentPage.value;
                  return SmoothPageIndicator(
                    controller: controller.pageController,
                    count: pages.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: AppColors.whiteColor,
                      dotColor: AppColors.whiteColor.withOpacity(0.16),
                      dotHeight: 10.h,
                      dotWidth: 10.w,
                      expansionFactor: 3,
                    ),
                  );
                }),
              ),
            ),

            /// ---------------- Next / Study Now Button ----------------
            Positioned(
              bottom: kBottomNavigationBarHeight / 2,
              left: 0,
              right: 0,
              child: Center(
                child: Obx(() {
                  final isLast = controller.currentPage.value == pages.length - 1;
                  return GestureDetector(
                    onTap: controller.nextPage,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        isLast ? "Study Now" : "Next",
                        style: GoogleFonts.plusJakartaSans(fontSize: sw * 0.042, fontWeight: FontWeight.w600, color: AppColors.primaryColor),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
