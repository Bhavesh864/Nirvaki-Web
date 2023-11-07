import 'package:flutter/material.dart';

RangeValues convertStringRangeToRangeValues({required String startValue, required String endValue}) {
  double start = convertFormattedStringToNumber(startValue);
  double end = convertFormattedStringToNumber(endValue);
  return RangeValues(start, end);
}

double convertFormattedStringToNumber(String formattedString) {
  String cleanedString = formattedString.replaceAll('₹', '').replaceAll(',', '').replaceAll(' ', '');

  double multiplier = 1.0;
  if (cleanedString.contains('L')) {
    cleanedString = cleanedString.replaceAll('L', '');
    multiplier = 100000;
  } else if (cleanedString.contains('Cr')) {
    cleanedString = cleanedString.replaceAll('Cr', '');
    multiplier = 10000000;
  }
  double numericValue = double.tryParse(cleanedString) ?? 0.0;
  numericValue *= multiplier;

  return numericValue;
}
