import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/screens/account_screens/Teams/AddMembers/add_member_screen.dart';
import 'package:yes_broker/widgets/accounts/Teams/bottom_card.dart';
import 'package:yes_broker/widgets/accounts/Teams/mobile_member_card.dart';
import 'package:yes_broker/widgets/accounts/Teams/title_cards.dart';

import '../../../riverpodstate/add_member_state.dart';

final addMemberScreenStateProvider = StateNotifierProvider<AddMemberScreenStateNotifier, bool>((ref) {
  return AddMemberScreenStateNotifier();
});

class TeamScreen extends ConsumerWidget {
  const TeamScreen({super.key});
  showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddMemberScreen();
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAddMemberScreen = ref.watch(addMemberScreenStateProvider);
    if (!Responsive.isMobile(context)) {
      if (isAddMemberScreen) {
        return const AddMemberScreen();
      } else {
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
    } else {
      return Container(
        margin: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
              const SizedBox(height: 20),
              const AppText(text: "Team", fontWeight: FontWeight.w700, fontsize: 16),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return const MobileMemberCard();
                  }),
              const SizedBox(height: 12),
              CustomButton(text: "Add Member", onPressed: () => showAlertDialog(context))
            ],
          ),
        ),
      );
    }
  }
}
