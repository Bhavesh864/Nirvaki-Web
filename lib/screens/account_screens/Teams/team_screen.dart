import 'package:flutter/material.dart';
import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/widgets/Account_screens/Teams/bottom_card.dart';
import 'package:yes_broker/widgets/Account_screens/Teams/title_cards.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 10),
                AppText(
                  text: "Current Plan - Pro",
                  fontWeight: FontWeight.w500,
                  fontsize: 20,
                ),
                SizedBox(
                  width: 7,
                ),
                AppText(
                  text: "View All Plans",
                  textdecoration: TextDecoration.underline,
                  textColor: AppColor.blue,
                  fontWeight: FontWeight.w400,
                  fontsize: 12,
                ),
              ],
            ),
            Row(
              children: [
                TitleCards(
                  cardTitle: "TOTAL LICENSE ",
                  cardSubtitle: "5",
                ),
                TitleCards(
                  cardTitle: "USED LICENSE",
                  cardSubtitle: "2",
                ),
                TitleCards(
                  cardTitle: "REMAINING LICENSE ",
                  cardSubtitle: "3",
                ),
              ],
            ),
            BottomCard()
          ],
        ),
      ),
    );
  }
}
