// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:yes_broker/Customs/text_utility.dart';

import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/constants/utils/constants.dart';

import '../../Customs/custom_text.dart';
import '../../constants/app_constant.dart';
import '../../constants/utils/colors.dart';
import 'nav_bar.dart';

AppBar mobileAppBar(User? user, BuildContext context, void Function(String) onOptionSelect, WidgetRef ref) {
  final notificationCollection = FirebaseFirestore.instance.collection("notification");

  return AppBar(
    foregroundColor: Colors.black,
    scrolledUnderElevation: 0.0,
    backgroundColor: Colors.white,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ScreenTypeLayout.builder(
          breakpoints: const ScreenBreakpoints(desktop: 1366, tablet: 768, watch: 360),
          mobile: (p0) => const CustomText(
            title: 'YesBrokr',
            letterSpacing: 0.4,
            fontWeight: FontWeight.w700,
            size: 16,
          ),
        ),
      ],
    ),
    actions: [
      StreamBuilder(
        stream: notificationCollection.where("userId", arrayContains: AppConst.getAccessToken()).where('isRead', isEqualTo: false).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final notificationCount = snapshot.data!.docs.length;
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const NotificationDialogBox();
                        },
                      );
                    },
                    child: const Icon(
                      Icons.notifications_none,
                      size: 30,
                    ),
                  ),
                ),
                if (notificationCount > 0)
                  Positioned(
                    right: 0,
                    top: 5,
                    child: CircleAvatar(
                      radius: 9,
                      backgroundColor: Colors.red,
                      child: Text(
                        notificationCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
              ],
            );
          }
          return const SizedBox();
        },
      ),
      const SizedBox(width: 5),
      PopupMenuButton(
        onSelected: (value) {
          onOptionSelect(value);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.white.withOpacity(1),
        offset: const Offset(200, 40),
        itemBuilder: (context) {
          if (user != null) {
            addOrRemoveTeamAndOrganization(user);
          }
          return profileMenuItems.map(
            (e) {
              return appBarPopupMenuItem(e.title, onOptionSelect);
            },
          ).toList();
        },
        // child: Container(
        //   height: 25,
        //   width: 35,
        //   margin: const EdgeInsets.all(10),
        //   decoration: BoxDecoration(
        //     image: DecorationImage(
        //       fit: BoxFit.cover,
        //       image: NetworkImage(
        //         user?.image ?? noImg,
        //       ),
        //     ),
        //     borderRadius: BorderRadius.circular(12),
        //   ),
        // ),
        child: user?.image != '' && user?.image != null
            ? Container(
                height: 25,
                width: 35,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(user?.image ?? noImg),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              )
            : Container(
                height: 25,
                width: 35,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    (user?.userfirstname.isNotEmpty == true ? user!.userfirstname[0].toUpperCase() : '') +
                        (user?.userlastname.isNotEmpty == true ? user!.userlastname[0].toUpperCase() : ''),
                    style: const TextStyle(
                      letterSpacing: 1,
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
      ),
    ],
  );
}

PopupMenuItem appBarPopupMenuItem(String title, void Function(String) onOptionSelect, {IconData icon = Icons.abc, bool showicon = false}) {
  return PopupMenuItem(
    onTap: () {
      onOptionSelect(title);
    },
    height: 5,
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        width: 200,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColor.secondary,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            if (showicon)
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Icon(icon),
              ),
            CustomText(
              title: title,
              letterSpacing: 0.4,
              size: 13,
              color: const Color(0xFF454545),
            ),
          ],
        ),
      ),
    ),
  );
}
