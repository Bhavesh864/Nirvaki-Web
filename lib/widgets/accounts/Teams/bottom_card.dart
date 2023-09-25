import 'package:flutter/material.dart';

import 'package:yes_broker/widgets/accounts/Teams/bottom_card_header.dart';
import 'package:yes_broker/widgets/accounts/Teams/bottom_card_main.dart';

import '../../../constants/firebase/userModel/user_info.dart';
import '../../../constants/utils/constants.dart';

class BottomCard extends StatelessWidget {
  final List<User> userList;
  const BottomCard({required this.userList, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Container(
        // width: w,
        padding: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BottomCardHeader(),
              SizedBox(height: height! * 0.07),
              BottomCardMain(userList: userList),
            ],
          ),
        ),
      ),
    );
  }
}
