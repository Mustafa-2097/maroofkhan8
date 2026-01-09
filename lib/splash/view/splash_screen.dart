import 'package:flutter/material.dart';
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
    final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: AppColors.primaryColor,
        child: Center(
          child: Image.asset(
            ImagePath.splashLogo,
            height: sh * 0.15,
            width: sw * 0.48,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}