import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:yes_broker/Customs/custom_page_transition.dart';
import 'package:yes_broker/constants/utils/colors.dart';

class TAppTheme {
  static ThemeData lightTheme = ThemeData(
      fontFamily: GoogleFonts.dmSans().fontFamily,
      pageTransitionsTheme: PageTransitionsTheme(builders: {
        TargetPlatform.iOS: CustomPageTransitionBuilder(),
        TargetPlatform.macOS: CustomPageTransitionBuilder(),
        TargetPlatform.windows: CustomPageTransitionBuilder(),
      }),
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
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      chipTheme: ChipThemeData(
        side: BorderSide.none,
        backgroundColor: AppColor.chipGreyColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      iconTheme: const IconThemeData(
        color: Colors.black,
        size: 14,
      ),
      textTheme: const TextTheme(
        titleMedium: TextStyle(
          color: Color(0xFF000000),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: Color(0xFF797979),
          fontSize: 10,
          fontWeight: FontWeight.w400,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 5,
        color: AppColor.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: const TextStyle(
          color: Colors.grey,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColor.primary,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll(AppColor.primary),
          padding: const MaterialStatePropertyAll(
            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Adjust the radius as needed
            ),
          ),
        ),
      ));

  static ThemeData darkTheme = ThemeData(brightness: Brightness.dark);
}
