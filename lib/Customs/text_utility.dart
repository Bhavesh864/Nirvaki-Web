import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  final String text;
  final Color? textColor;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final double fontsize;
  final String? fontfamily;
  final double? wordspacing;
  final TextDecoration? textdecoration;
  final TextBaseline? textBaseline;
  final double? letterspacing;
  final FontWeight? fontWeight;
  final bool? softwrap;
  const AppText({
    Key? key,
    required this.text,
    this.fontfamily,
    this.textBaseline,
    this.softwrap,
    this.fontWeight = FontWeight.normal,
    this.wordspacing,
    this.letterspacing,
    this.textColor = Colors.black,
    this.fontsize = 16,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.textdecoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: fontsize,
        decoration: textdecoration,
        fontFamily: GoogleFonts.dmSans().fontFamily,
        wordSpacing: wordspacing,
        textBaseline: textBaseline,
        letterSpacing: letterspacing,
        fontWeight: fontWeight,
      ),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softwrap,
    );
  }
}
