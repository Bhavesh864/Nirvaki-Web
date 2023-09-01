import 'package:flutter/material.dart';

import '../../../Customs/custom_text.dart';
import '../../../constants/utils/colors.dart';

class ChipButton extends StatelessWidget {
  final bool isSmall;
  final String text;
  final double width;
  final VoidCallback onSelect;
  final TextAlign? textAlign;
  final Color bgColor;

  const ChipButton({
    super.key,
    this.isSmall = false,
    this.textAlign,
    required this.text,
    required this.onSelect,
    this.width = double.infinity,
    this.bgColor = AppColor.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: () => {
          onSelect(),
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          constraints: BoxConstraints(
            minWidth: isSmall ? 140 : double.infinity,
          ),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: bgColor == AppColor.primary.withOpacity(0.05) ? AppColor.secondary : AppColor.primary.withOpacity(0.2)),
          ),
          child: CustomText(
            textAlign: textAlign,
            title: text,
          ),
        ),
      ),
    );
  }
}
