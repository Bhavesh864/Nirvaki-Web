import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yes_broker/constants/utils/colors.dart';

class TAppTheme {
  static ThemeData lightTheme = ThemeData(
    fontFamily: GoogleFonts.dmSans().fontFamily,
    brightness: Brightness.light,
    primarySwatch: const MaterialColor(
      0xFF4460EF,
      <int, Color>{
        50: Color(0x1A4460EF),
        100: Color(0x334460EF),
        200: Color(0x4D4460EF),
        300: Color(0x664460EF),
        400: Color(0x804460EF),
        500: Color(0xFF4460EF),
        600: Color(0x994460EF),
        700: Color(0xB34460EF),
        800: Color(0xCC4460EF),
        900: Color(0xE64460EF),
      },
    ),
    chipTheme: ChipThemeData(
      side: BorderSide.none,
      backgroundColor: AppColor.chipGreyColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
    textTheme: const TextTheme(
      // titleLarge: TextStyle(),
      titleMedium: TextStyle(
        color: Color(0xFF000000),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        color: Color(0xFF797979),
        fontSize: 10,
        fontWeight: FontWeight.w400,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(brightness: Brightness.dark);
}
