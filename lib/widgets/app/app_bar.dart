import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:yes_broker/constants/constants.dart';
import '../../constants/colors.dart';
import '../../Customs/custom_text.dart';

AppBar MobileAppBar(BuildContext context, GlobalKey<ScaffoldState> key) {
  // final width = MediaQuery.of(context).size.width;

  return AppBar(
    foregroundColor: Colors.black,
    scrolledUnderElevation: 0.0,
    // toolbarHeight: 50,
    backgroundColor: Colors.white,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ScreenTypeLayout.builder(
          breakpoints:
              const ScreenBreakpoints(desktop: 1366, tablet: 768, watch: 360),
          mobile: (p0) => const CustomText(
            title: 'YesBroker',
            fontWeight: FontWeight.bold,
            size: 16,
          ),
          // tablet: (p0) => largeScreenView(),
          // desktop: (p0) => largeScreenView(),
        ),
      ],
    ),
    actions: [
      PopupMenuButton(
        color: Colors.white.withOpacity(1),
        offset: const Offset(200, 40),
        itemBuilder: (context) => menuItems.map(
          (e) {
            return popupMenuItem(e);
          },
        ).toList(),
        child: Container(
          height: 30,
          width: 30,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            image: const DecorationImage(image: AssetImage(profileImage)),
            borderRadius: BorderRadius.circular(10),
          ),
          // child: Text(width.toString()),
        ),
      ),
    ],
  );
}

PopupMenuItem popupMenuItem(String title) {
  return PopupMenuItem(
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
