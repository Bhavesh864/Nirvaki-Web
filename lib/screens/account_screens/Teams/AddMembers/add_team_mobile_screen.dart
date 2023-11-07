import 'package:flutter/material.dart';
import 'package:yes_broker/constants/utils/image_constants.dart';
import 'package:yes_broker/screens/account_screens/Teams/AddMembers/add_member_screen.dart';

class AddMemberMobileScreen extends StatefulWidget {
  const AddMemberMobileScreen({super.key});

  @override
  State<AddMemberMobileScreen> createState() => _AddMemberMobileScreenState();
}

class _AddMemberMobileScreenState extends State<AddMemberMobileScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(authBgImage),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black38,
              BlendMode.darken,
            ),
          ),
        ),
        child: const AddMemberScreen(),
      )
    ]);
  }
}
