import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constant/app_colors.dart';
import '../../core/constant/image_path.dart';
import '../Controller/splash_controller.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    //final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 200.h),
          Image.asset(
            'assets/images/onboarding01.png',
            height: sh*0.38,
          ),
          Text(
            "AI Murshid",
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Color(0xFFEE7600).withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          Image.asset(
            "assets/images/splash02.png",
            height: sh*0.2,
            width: double.infinity,
            fit: BoxFit.cover,
          )
        ],
      ),
    );
  }
}