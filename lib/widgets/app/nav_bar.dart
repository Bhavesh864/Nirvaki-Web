import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:yes_broker/constants/constants.dart';
import 'package:yes_broker/constants/firebase/user_firebase.dart';
import '../../constants/colors.dart';
import '../../Customs/custom_text.dart';

Widget LargeScreenNavBar(GlobalKey<ScaffoldState> key) {
  // final width = MediaQuery.of(context).size.width;

  return Container(
    height: 70,
    margin: const EdgeInsets.only(bottom: 5, right: 5),
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: primaryColor.withOpacity(0.1),
          spreadRadius: 12,
          blurRadius: 4,
          offset: const Offset(5, -15),
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
                ScreenTypeLayout.builder(
                  breakpoints: const ScreenBreakpoints(
                      desktop: 1366, tablet: 768, watch: 360),
                  mobile: (p0) => const CustomText(
                    title: 'YesBroker',
                    fontWeight: FontWeight.bold,
                    size: 16,
                    color: darkTheme,
                  ),
                  tablet: (p0) => largeScreenView(snapshot.data!.name),
                  desktop: (p0) => largeScreenView(snapshot.data!.name),
                ),
                PopupMenuButton(
                  color: Colors.white.withOpacity(1),
                  offset: const Offset(200, 40),
                  itemBuilder: (context) => [
                    popupMenuItem('Profile'),
                    popupMenuItem('Team'),
                    popupMenuItem('Settings'),
                    popupMenuItem('Help'),
                    popupMenuItem('Logout'),
                  ],
                  child: Container(
                    height: 40,
                    width: 40,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(snapshot.data!.image.toString()),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // child: Text(width.toString()),
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        }),
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
          color: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(title),
      ),
    ),
  );
}

Widget largeScreenView(name) {
  return Container(
    padding: EdgeInsets.only(left: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FutureBuilder(
          future: User.getUser(auth.currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CustomText(
                title: 'Good morning, ${name}',
                fontWeight: FontWeight.bold,
                color: darkTheme,
              );
            }
            return const SizedBox();
          },
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const InkWell(
                child: Icon(Icons.home_outlined),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: const CustomText(
                  title: 'Home',
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                  size: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
