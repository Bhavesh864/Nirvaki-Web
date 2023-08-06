import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/screens/account_screens/common_screen.dart';
import '../../constants/utils/colors.dart';
import '../../Customs/custom_text.dart';
import '../../constants/utils/image_constants.dart';

AppBar mobileAppBar(BuildContext context, void Function(String) onOptionSelect) {
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
          breakpoints: const ScreenBreakpoints(desktop: 1366, tablet: 768, watch: 360),
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
        onSelected: (value) {
          onOptionSelect(value);
        },
        color: Colors.white.withOpacity(1),
        offset: const Offset(200, 40),
        itemBuilder: (context) => profileMenuItems.map(
          (e) {
            return popupMenuItem(e.title, onOptionSelect);
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

PopupMenuItem popupMenuItem(String title, void Function(String) onOptionSelect) {
  return PopupMenuItem(
    onTap: () {
      onOptionSelect(title);
    },
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
