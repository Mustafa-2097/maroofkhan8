import 'package:flutter/material.dart';
import 'package:maroofkhan8/core/theme/widgets/elevated_button_theme.dart';
import 'package:maroofkhan8/core/theme/widgets/text_theme.dart';

class AppTheme {
  /// Light theme configuration
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    textTheme: MyTextTheme.lightTextTheme,
    elevatedButtonTheme: MyElevatedButtonTheme.lightElevatedButtonTheme,
    colorScheme: ColorScheme.light(
      primary: const Color(0xFF8F3E19),
      onPrimary: Colors.white,
      surface: Colors.grey.shade300,
    ),
  );

  /// Dark theme configuration
  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    textTheme: MyTextTheme.darkTextTheme,
    elevatedButtonTheme: MyElevatedButtonTheme.darkElevatedButtonTheme,
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFFEE7600),
      onPrimary: Colors.black,
      surface: Color(0xFF494358),
    ),
  );
}

