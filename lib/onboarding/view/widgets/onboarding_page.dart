import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constant/app_colors.dart';
import '../../model/onboarding_data.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;

    return Column(
      children: [
        SizedBox(height: sh * 0.27),
        /// ----------- Image -----------
        Image.asset(data.image, width: double.infinity, fit: BoxFit.contain),

        /// ----------- Title + Subtitle -----------
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          child: Column(
            children: [
              SizedBox(height: sh * 0.025),
              Text(
                data.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(fontSize: sw * 0.064, fontWeight: FontWeight.w700, color: AppColors.whiteColor),
              ),
              SizedBox(height: sh * 0.015),
              Text(
                data.subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(fontSize: sw * 0.037, fontWeight: FontWeight.w600, color: AppColors.whiteColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
