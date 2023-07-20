// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String title;
  final Color? color;
  final double? size;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final bool? softWrap;

  const CustomText({
    Key? key,
    required this.title,
    this.color,
    this.size,
    this.fontWeight,
    this.textAlign,
    this.softWrap = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign ?? TextAlign.start,
      softWrap: softWrap,
      style: TextStyle(
        color: color ?? Colors.black,
        fontSize: size ?? 16,
        height: 0,
        fontWeight: fontWeight ?? FontWeight.normal,
        fontFamily: GoogleFonts.dmSans().fontFamily,
      ),
    );
  }
}
