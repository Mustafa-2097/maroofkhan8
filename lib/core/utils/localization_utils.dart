import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

String localizeDigits(String input, BuildContext context) {
  final languageCode = context.locale.languageCode;
  if (languageCode == 'en') return input;

  const Map<String, List<String>> digitMap = {
    'hi': ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'],
    'ar': ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'],
    'ur': ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'],
  };

  final digits = digitMap[languageCode];
  if (digits == null) return input;

  return input
      .split('')
      .map((char) {
        final index = int.tryParse(char);
        return index != null ? digits[index] : char;
      })
      .join('');
}
