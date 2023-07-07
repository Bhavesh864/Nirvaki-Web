import 'package:flutter/material.dart';
import 'package:yes_broker/TabScreens/main_screens/chat_screen.dart';
import 'package:yes_broker/TabScreens/main_screens/inventroy_screen.dart';
import 'package:yes_broker/TabScreens/main_screens/lead_screen.dart';
import 'package:yes_broker/constants/colors.dart';
import 'package:yes_broker/constants/constants.dart';
import 'package:yes_broker/widgets/app/app_bar.dart';
import 'package:yes_broker/widgets/calendar_view.dart';
import 'package:yes_broker/widgets/todo_list_view.dart';

class SmallScreen extends StatefulWidget {
  const SmallScreen({super.key});

  @override
  State<SmallScreen> createState() => _SmallScreenState();
}

class _SmallScreenState extends State<SmallScreen> {
  final List<Widget> _pages = [
    const SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        children: [
          CustomCalendarView(),
          TodoListView(),
        ],
      ),
    ),
    const InventoryScreen(),
    const LeadScreen(),
    const ChatScreen(),
  ];

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MobileAppBar(context, GlobalKey()),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: const Color.fromARGB(255, 158, 153, 153),
        selectedItemColor: primaryColor,
        showUnselectedLabels: false,
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        backgroundColor: Colors.white,
        items: List.generate(
          bottomBarItems.length,
          (index) => BottomNavigationBarItem(
            icon: Icon(
              bottomBarItems[index]["icon"],
              color: index == _selectedPageIndex ? primaryColor : Colors.black,
            ),
            label: bottomBarItems[index]['title'],
          ),
        ),
      ),
      body: _pages[_selectedPageIndex],
      // floatingActionButton: _buildBottomBar(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // Widget _buildBottomBar() {
  //   return Container(
  //     height: 55,
  //     width: double.infinity,
  //     // margin: EdgeInsets.symmetric(horizontal: 15),
  //     decoration: BoxDecoration(
  //       color: AppColor.bottomBarColor,
  //       // borderRadius: BorderRadius.circular(20),
  //       boxShadow: [
  //         BoxShadow(
  //           color: AppColor.shadowColor.withOpacity(0.1),
  //           blurRadius: 1,
  //           spreadRadius: 1,
  //           offset: const Offset(0, 1),
  //         )
  //       ],
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       crossAxisAlignment: CrossAxisAlignment.end,
  //       children: List.generate(
  //         barItems.length,
  //         (index) => BottomBarItem(
  //           activeTab == index
  //               ? barItems[index]["active_icon"]
  //               : barItems[index]["icon"],
  //           isActive: activeTab == index,
  //           activeColor: AppColor.primary,
  //           onTap: () {
  //             setState(() {
  //               activeTab = index;
  //             });
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
