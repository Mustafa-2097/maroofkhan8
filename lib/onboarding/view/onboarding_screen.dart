import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';
import '../controller/onboarding_controller.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  OnboardingScreen({super.key});
  final controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

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
                tr("assalamualaikum"),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Color(0xFFEE7600).withValues(alpha: 0.8),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: sh * 0.01),
              Text(
                tr("welcome_to_digital_khanqah"),
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: sh * 0.04),
              Image.asset('assets/images/onboarding01.png', height: sh * 0.4),
              Text(
                tr("ai_murshid"),
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
              Image.asset('assets/images/onboarding02.png', height: sh * 0.12),
              SizedBox(height: sh * 0.05),
              Text(
                tr("ai_murshid"),
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Color(0xFFEE7600).withValues(alpha: 0.8),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: sh * 0.01),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: sw * 0.1),
                child: Text(
                  tr("ai_spiritual_guide_desc"),
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontSize: sw * 0.037),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: sh * 0.03),
              _FeatureChip(label: tr("real_time_chat")),
              _FeatureChip(label: tr("quran_sunnah")),
              _FeatureChip(label: tr("spiritual_wisdom")),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(sw * 0.06, 0, sw * 0.06, sh * 0.12),
        child: SizedBox(
          height: sh * 0.06,
          child: Obx(
            () => ElevatedButton(
              onPressed: controller.onGetStarted,
              child: Text(
                controller.currentIndex.value == 0
                    ? tr("continue_btn")
                    : tr("get_started"),
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
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(bottom: sh * 0.01),
      child: SizedBox(
        width: sw * 0.5,
        child: OutlinedButton(
          style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
            padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(horizontal: sw * 0.04, vertical: sh * 0.01),
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
          onPressed: null,
          child: Text(label, style: Theme.of(context).textTheme.titleMedium),
        ),
      ),
    );
  }
}
