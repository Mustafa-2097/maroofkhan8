import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:maroofkhan8/features/home/views/dashboard_screen.dart';
import 'package:maroofkhan8/splash/view/splash_screen.dart';
import 'language_selection/view/language_screen.dart';
import 'bottom_nav_bar.dart';
import 'core/theme/theme.dart';
import 'core/theme/theme_service.dart';
import 'onboarding/view/onboarding_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      builder: (context, child) {
        /// Override system text scaling globally
        final fixedMediaQuery = MediaQuery.of(
          context,
        ).copyWith(textScaler: const TextScaler.linear(1.0));
        return MediaQuery(
          data: fixedMediaQuery,
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            builder: (context, child) {
              final easyLoading = EasyLoading.init();
              child = easyLoading(context, child);
              return Directionality(
                textDirection: ui.TextDirection.ltr,
                child: child,
              );
            },
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeService().theme,
            home: SplashScreen(), // TODO: revert to SplashScreen() after testing
          ),
        );
      },
    );
  }
}
