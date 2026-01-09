import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        /// Override system text scaling globally
        final fixedMediaQuery = MediaQuery.of(context).copyWith(
          textScaler: const TextScaler.linear(1.0),
        );
        return MediaQuery(
          data: fixedMediaQuery,
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            builder: EasyLoading.init(),
            // theme: ThemeData.light().copyWith(
            //   primaryColor: AppColors.primaryColor,
            //   scaffoldBackgroundColor: AppColors.primaryColor,
            //   appBarTheme: const AppBarTheme(
            //     backgroundColor: Colors.transparent,
            //     iconTheme: IconThemeData(color: AppColors.whiteColor),
            //   ),
            //   iconTheme: const IconThemeData(
            //     color: AppColors.whiteColor,
            //   ),
            //   checkboxTheme: CheckboxThemeData(
            //     shape: const CircleBorder(),
            //     side: BorderSide(width: 1.5, color: AppColors.boxTextColor),
            //   ),
            // ),
            //home: SplashScreen(),
          ),
        );
      },
    );

  }
}
