import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/onboarding_controller.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  OnboardingScreen({super.key});
  final controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        onPageChanged: controller.onPageChanged,
        children: [
          /// First screen
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Assalamu’alaikum",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Color(0xFFEE7600).withValues(alpha: 0.8),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                "Welcome to Digital Khanqah",
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Image.asset(
                'assets/images/onboarding01.png',
                height: 355,
              ),
              Text(
                "AI Murshid",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Color(0xFFEE7600).withValues(alpha: 0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),

          /// Second screen
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/onboarding02.png',
                height: 100,
              ),
              SizedBox(height: 44.h),
              Text(
                "AI Murshid",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Color(0xFFEE7600).withValues(alpha: 0.8),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 6.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal:50),
                child: Text(
                  "Your 24/7 AI Spiritual Guide Embodies wisdom of Sufi Awliya Powered by advanced AI",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: sw*0.037,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 22.h),
              _FeatureChip(label: 'Real-time Chat'),
              _FeatureChip(label: 'Quran & Sunnah'),
              _FeatureChip(label: 'Spiritual Wisdom'),
            ],
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 111.h),
        child: SizedBox(
          height: 48.h,
          child: Obx(() => ElevatedButton(
              onPressed: controller.onGetStarted,
              child: Text(
                controller.currentIndex.value == 0
                    ? 'Continue'
                    : 'Get Started',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final String label;
  const _FeatureChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: SizedBox(
        width: 180.w,
        child: OutlinedButton(
          style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
            padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
          onPressed: null,
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }
}
