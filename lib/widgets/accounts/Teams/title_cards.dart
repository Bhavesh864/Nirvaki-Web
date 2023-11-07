import 'package:flutter/material.dart';
import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/utils/colors.dart';

class TitleCards extends StatelessWidget {
  final String cardTitle;
  final String cardSubtitle;
  const TitleCards({super.key, required this.cardTitle, required this.cardSubtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: cardTitle,
              fontsize: 15,
              fontWeight: FontWeight.w500,
            ),
            AppText(
              text: cardSubtitle,
              fontsize: 32,
              fontWeight: FontWeight.w500,
              textColor: AppColor.blue,
            )
          ],
        ),
      ),
    );
  }
}
