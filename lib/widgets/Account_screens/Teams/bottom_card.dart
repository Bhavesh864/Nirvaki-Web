import 'package:flutter/material.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/widgets/Account_screens/Teams/bottom_card_header.dart';
import 'package:yes_broker/widgets/Account_screens/Teams/bottom_card_main.dart';

import '../../../Customs/text_utility.dart';
import '../../../constants/utils/constants.dart';

class BottomCard extends StatelessWidget {
  const BottomCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Container(
        width: width,
        padding: const EdgeInsets.all(16),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BottomCardHeader(),
              SizedBox(height: height! * 0.07),
              BottomCardMain(),
            ],
          ),
        ),
      ),
    );
  }
}
