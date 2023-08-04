import 'package:flutter/material.dart';

import '../../../Customs/text_utility.dart';
import '../../../constants/utils/colors.dart';

class BottomCardHeader extends StatefulWidget {
  const BottomCardHeader({super.key});

  @override
  State<BottomCardHeader> createState() => _BottomCardHeaderState();
}

class _BottomCardHeaderState extends State<BottomCardHeader> {
  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppText(
          text: "My Team",
          fontsize: 18,
          fontWeight: FontWeight.bold,
        ),
        AppText(
          text: "Add Members",
          fontsize: 18,
          fontWeight: FontWeight.w500,
          textdecoration: TextDecoration.underline,
          textColor: AppColor.blue,
        )
      ],
    );
  }
}
