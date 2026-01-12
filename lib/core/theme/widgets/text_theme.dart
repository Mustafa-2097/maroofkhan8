import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextTheme {
  MyTextTheme._();

  static final TextTheme lightTextTheme =
  GoogleFonts.amiriTextTheme(
    const TextTheme(
      headlineLarge: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600, color: Color(0xFF8F3E19)),
      headlineSmall: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),

      titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400),
      titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
      titleSmall: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),

      bodyLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
      bodySmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),

      labelLarge: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),
      labelMedium: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),
    ),
  ).apply(
    bodyColor: Colors.black,
    displayColor: Colors.black,
  );

  static final TextTheme darkTextTheme =
  GoogleFonts.amiriTextTheme(
    const TextTheme(
      headlineLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600, color: Color(0xFFEE7600)),
      headlineSmall: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),

      titleLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),

      bodyLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
      bodySmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),

      labelLarge: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),
      labelMedium: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),
    ),
  ).apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  );
}
