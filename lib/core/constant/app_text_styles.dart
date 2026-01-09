import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle header24(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    return GoogleFonts.plusJakartaSans(
      color: AppColors.blackColor,
      fontSize: sw * 0.064,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle body3(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    return GoogleFonts.plusJakartaSans(
      color: AppColors.boxTextColor,
      fontSize: sw * 0.0373, // 14
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle body3_400(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    return GoogleFonts.plusJakartaSans(
      color: AppColors.boxTextColor,
      fontSize: sw * 0.0373, // 14
      fontWeight: FontWeight.w400,
    );
  }

  // static TextStyle body3 = GoogleFonts.plusJakartaSans(
  //   color: AppColors.subTextColor,
  //   fontSize: 14.sp,
  //   fontWeight: FontWeight.w600,
  // );

}