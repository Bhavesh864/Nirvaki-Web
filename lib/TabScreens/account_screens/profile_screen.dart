import 'package:flutter/material.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/constants/colors.dart';
import 'package:yes_broker/constants/constants.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profileScreen';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String selectedItem = 'Profile';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: menuItems
                  .map(
                    (e) => Container(
                      margin: EdgeInsets.all(5),
                      width: 200,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: selectedItem == e
                            ? AppColor.secondary
                            : Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: CustomText(
                        title: e,
                        color:
                            selectedItem == e ? AppColor.primary : Colors.black,
                      ),
                    ),
                  )
                  .toList(),
              // CustomText(title: 'Team'),
              // CustomText(title: 'Subscription'),
              // CustomText(title: 'Settings'),
              // CustomText(title: 'Help'),
              // CustomText(title: 'Logout'),
            ),
          ),
          Expanded(
              flex: 3,
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                    child: const ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                      ),
                    ),
                  ),
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                  ),
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
