import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/controllers/menu_controller.dart';
import '../../constants/utils/colors.dart';
import '../../Customs/custom_text.dart';
import '../../constants/firebase/user_info.dart';

class LargeScreenNavBar extends StatefulWidget {
  const LargeScreenNavBar({super.key});

  @override
  State<LargeScreenNavBar> createState() => _LargeScreenNavBarState();
}

class _LargeScreenNavBarState extends State<LargeScreenNavBar> {
  @override
  void initState() {
    super.initState();
    getstate();
  }

  getstate() async {}

  final SideMenuController menuController = Get.put(SideMenuController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.only(bottom: 5, right: 5),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColor.secondary,
            spreadRadius: 12,
            blurRadius: 4,
            offset: Offset(5, -15),
          ),
        ],
        color: Colors.white,
      ),
      child: FutureBuilder(
        future: User.getUser(auth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                largeScreenView(snapshot.data?.userfirstname),
                PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'Profile') {
                      menuController.selectPage(6);
                    }
                  },
                  color: Colors.white.withOpacity(1),
                  offset: const Offset(200, 40),
                  itemBuilder: (contex) => menuItems.map(
                    (e) {
                      return popupMenuItem(e);
                    },
                  ).toList(),
                  child: Container(
                    height: 30,
                    width: 30,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(snapshot.data!.image.toString())),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

PopupMenuItem popupMenuItem(String title) {
  return PopupMenuItem(
    onTap: null,
    value: title,
    height: 5,
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Center(
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColor.secondary,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(title),
      ),
    ),
  );
}

Widget largeScreenView(name) {
  final SideMenuController menuController = Get.put(SideMenuController());
  return Container(
    padding: const EdgeInsets.only(left: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          title: 'Good morning, $name',
          fontWeight: FontWeight.bold,
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const InkWell(
                child: Icon(
                  Icons.home_outlined,
                  size: 18,
                ),
              ),
              Obx(
                () => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: [
                      CustomText(
                        title: 'Home',
                        fontWeight: FontWeight.w600,
                        color: menuController.titleForEachTab(
                                    menuController.selectedPageIndex.value) ==
                                ''
                            ? AppColor.primary
                            : Colors.grey,
                        size: 13,
                      ),
                      CustomText(
                        title: menuController.titleForEachTab(
                            menuController.selectedPageIndex.value),
                        fontWeight: FontWeight.w600,
                        color: AppColor.primary,
                        size: 13,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
