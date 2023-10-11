import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/customs/custom_fields.dart';
import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/customs/text_utility.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/screens/account_screens/Teams/AddMembers/add_member_screen.dart';
import 'package:yes_broker/widgets/accounts/Teams/bottom_card.dart';
import 'package:yes_broker/widgets/accounts/Teams/mobile_member_card.dart';
import 'package:yes_broker/widgets/accounts/Teams/title_cards.dart';

import '../../../constants/firebase/userModel/user_info.dart';
import '../../../riverpodstate/add_member_state.dart';
import '../../../riverpodstate/user_data.dart';

final addMemberScreenStateProvider = StateNotifierProvider<AddMemberScreenStateNotifier, bool>((ref) {
  return AddMemberScreenStateNotifier();
});

class TeamScreen extends ConsumerWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAddMemberScreen = ref.watch(addMemberScreenStateProvider);
    final User? currentUserdata = ref.read(userDataProvider);

    if (!Responsive.isMobile(context)) {
      if (isAddMemberScreen) {
        return const AddMemberScreen();
      } else {
        return Container(
          margin: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("users").where("brokerId", isEqualTo: currentUserdata?.brokerId).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  if (snapshot.hasData) {
                    final usersListSnapshot = snapshot.data!.docs;
                    List<User> listOfUser = usersListSnapshot.map((doc) => User.fromSnapshot(doc)).toList();
                    List<User> usersList = listOfUser.where((element) => !element.role.contains("Broker")).toList();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
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
                        const Row(
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
                        BottomCard(userList: usersList)
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                }),
          ),
        );
      }
    } else {
      return Container(
        margin: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("users").where("brokerId", isEqualTo: currentUserdata?.brokerId).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                if (snapshot.hasData) {
                  final usersListSnapshot = snapshot.data!.docs;
                  List<User> listOfUser = usersListSnapshot.map((doc) => User.fromSnapshot(doc)).toList();
                  List<User> usersList = listOfUser.where((element) => !element.role.contains("Broker")).toList();
                  return Column(
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
                      Row(
                        children: [
                          const AppText(text: "Team", fontWeight: FontWeight.w700, fontsize: 16),
                          const SizedBox(width: 5),
                          InkWell(
                            onTap: () {
                              showAddMemberAlertDailogBox(context);
                              ref.read(editAddMemberState.notifier).isEdit(false);
                              ref.read(userForEditScreen.notifier).setUserForEdit(null);
                            },
                            child: const Icon(
                              Icons.add_circle_outline,
                              size: 17,
                            ),
                          )
                        ],
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: usersList.length,
                          itemBuilder: (context, index) {
                            final user = usersList[index];
                            return MobileMemberCard(user: user);
                          }),
                      const SizedBox(height: 12),
                      CustomButton(
                          text: "Add Member",
                          onPressed: () => {
                                showAddMemberAlertDailogBox(context),
                                ref.read(editAddMemberState.notifier).isEdit(false),
                                ref.read(userForEditScreen.notifier).setUserForEdit(null),
                              })
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),
        ),
      );
    }
  }
}

showAddMemberAlertDailogBox(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const AddMemberScreen();
    },
  );
}
