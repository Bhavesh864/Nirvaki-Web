import 'package:flutter/material.dart';

import '../../../Customs/custom_text.dart';
import '../../../constants/colors.dart';

class ChipButton extends StatelessWidget {
  final double width;
  final String text;
  final VoidCallback onSelect;

  const ChipButton({
    super.key,
    this.width = double.infinity,
    required this.text,
    required this.onSelect,
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
          width: width,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColor.secondary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: CustomText(
            title: text,
          ),
        ),
      ),
    );
  }
}
