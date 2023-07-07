// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:yes_broker/constants/colors.dart';
import 'package:yes_broker/constants/constants.dart';
import 'package:yes_broker/widgets/card/card_footer.dart';
import 'package:yes_broker/widgets/card/card_header.dart';

class CustomCard extends StatelessWidget {
  final int index;
  final bool isTodoItem;
  const CustomCard({super.key, required this.index, required this.isTodoItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColor.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: EdgeInsets.only(
        left: width! < 1280 && width! > 1200 ? 0 : 10,
        right: width! < 1280 && width! > 1200 ? 0 : 10,
        bottom: 15,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: AppColor.cardColor,
        ),
        height: 170,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CardHeader(index: index),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              userData[index].task!,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              userData[index].subtitle!,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CardFooter(index: index),
          ],
        ),
      ),
    );
  }
}
