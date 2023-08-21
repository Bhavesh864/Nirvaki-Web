import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/Customs/text_utility.dart';

import 'package:yes_broker/constants/utils/colors.dart';

import '../../../constants/firebase/userModel/user_info.dart';

class BottomCardMain extends StatefulWidget {
  const BottomCardMain({super.key});

  @override
  State<BottomCardMain> createState() => _BottomCardMainState();
}

class _BottomCardMainState extends State<BottomCardMain> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppText(text: "NAME", textColor: AppColor.cardtitleColor),
              AppText(text: "ROLE", textColor: AppColor.cardtitleColor),
              AppText(text: "MANAGER", textColor: AppColor.cardtitleColor),
              AppText(text: ""),
            ],
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance.collection("users").where("brokerId", isEqualTo: currentUser["brokerId"]).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                if (snapshot.hasData) {
                  final usersListSnapshot = snapshot.data!.docs;
                  List<User> usersList = usersListSnapshot.map((doc) => User.fromSnapshot(doc)).toList();
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: usersList.length,
                      itemBuilder: (context, index) {
                        final user = usersList[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColor.baseline))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AppText(text: '${user.userfirstname} ${user.userlastname}', fontsize: 12, fontWeight: FontWeight.bold),
                              AppText(text: user.role, fontsize: 12, fontWeight: FontWeight.w400),
                              Row(
                                children: [
                                  IconButton(onPressed: () {}, icon: const Icon(Icons.abc)),
                                  AppText(text: user.managerName!, fontsize: 12, fontWeight: FontWeight.w400),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(color: AppColor.secondary, borderRadius: BorderRadius.circular(7)),
                                child: IconButton(
                                  tooltip: "Edit",
                                  iconSize: 12,
                                  onPressed: () {},
                                  icon: const Icon(Icons.edit),
                                ),
                              )
                            ],
                          ),
                        );
                      });
                }
                return const Center(child: CustomText(title: "No user Found"));
              }),
        ],
      ),
    );
  }
}
