import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

String localizeDigits(String input, BuildContext context) {
  final languageCode = context.locale.languageCode;

  // Localize AM/PM
  String result = input;
  if (languageCode == 'ar') {
    result = result
        .replaceAll('am', 'ص')
        .replaceAll('pm', 'م')
        .replaceAll('AM', 'ص')
        .replaceAll('PM', 'م')
        .replaceAll('AH', 'هـ')
        .replaceAll('AD', 'م');
  } else if (languageCode == 'ur') {
    result = result
        .replaceAll('am', 'صبح')
        .replaceAll('pm', 'شام')
        .replaceAll('AM', 'صبح')
        .replaceAll('PM', 'شام')
        .replaceAll('AH', 'ہجری')
        .replaceAll('AD', 'عیسوی');
  } else if (languageCode == 'hi') {
    result = result
        .replaceAll('am', 'पूर्वान्ह')
        .replaceAll('pm', 'अपराह्न')
        .replaceAll('AM', 'पूर्वान्ह')
        .replaceAll('PM', 'अपराह्न')
        .replaceAll('AH', 'हिजरी')
        .replaceAll('AD', 'ईस्वी');
  }

  if (languageCode == 'en') return result;

  const Map<String, List<String>> digitMap = {
    'hi': ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'],
    'ar': ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'],
    'ur': ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'],
  };

  final digits = digitMap[languageCode];
  if (digits == null) return result;

  return result
      .split('')
      .map((char) {
        final index = int.tryParse(char);
        return index != null ? digits[index] : char;
      })
      .join('');
}
