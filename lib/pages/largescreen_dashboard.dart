import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:yes_broker/TabScreens/main_screens/caledar_screen.dart';
import 'package:yes_broker/TabScreens/main_screens/chat_screen.dart';
import 'package:yes_broker/TabScreens/main_screens/inventroy_screen.dart';
import 'package:yes_broker/TabScreens/main_screens/lead_screen.dart';
import 'package:yes_broker/TabScreens/main_screens/todo_screen.dart';
import 'package:yes_broker/constants/colors.dart';
import 'package:yes_broker/constants/constants.dart';
import 'package:yes_broker/constants/firebase/user_firebase.dart' as user;

import 'package:yes_broker/widgets/app/side_menu.dart';
import 'package:yes_broker/widgets/app/nav_bar.dart';
import 'package:yes_broker/TabScreens/main_screens/home_screen.dart';

class LargeScreen extends StatefulWidget {
  const LargeScreen({super.key});

  @override
  State<LargeScreen> createState() => _LargeScreenState();
}

class _LargeScreenState extends State<LargeScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? userData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void getUserData() async {
    final user.User? retrievedUser =
        await user.User.getUser(auth.currentUser!.uid);
    if (retrievedUser != null) {
      userData = retrievedUser as User?;
    }
  }

  void select(int n) {
    for (int i = 0; i < 5; i++) {
      if (i == n) {
        selected[i] = true;
      } else {
        selected[i] = false;
      }
    }
  }

  final List<Widget> _pages = [
    const HomeScreen(),
    const TodoTabScreen(),
    const InventoryScreen(),
    const LeadScreen(),
    const ChatScreen(),
    const CalendarScreen(),
  ];

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  // final Map<String, dynamic> users = {
  //   'name': 'jack',
  //   'brokerId': 2,
  //   'mobile': 12345678,
  //   'role': 'broker',
  //   'uid': FirebaseAuth.instance.currentUser?.uid,
  // };

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .add(users)
  //       .then((value) => {print(value)});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // const Expanded(
          //   flex: 1,
          //   child: SideMenu(),
          // ),
          Padding(
            padding: EdgeInsets.only(top: height! * 0.2),
            child: NavigationRail(
              minWidth: 60,
              useIndicator: false,
              onDestinationSelected: (index) {
                _selectPage(index);
              },
              destinations: sideBarIcons
                  .map(
                    (e) => NavigationRailDestination(
                      padding: const EdgeInsets.only(top: 20),
                      icon: Icon(e),
                      selectedIcon: Icon(e, color: primaryColor),
                      label: const Text('Home'),
                    ),
                  )
                  .toList(),
              selectedIndex: _selectedPageIndex,
            ),
          ),
          Expanded(
            flex: 20,
            child: Column(
              children: [
                LargeScreenNavBar(GlobalKey()),
                Expanded(
                  child: _pages[_selectedPageIndex],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: const Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: primaryColor,
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          CircleAvatar(
            radius: 25,
            backgroundColor: primaryColor,
            child: Icon(
              Icons.chat_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
