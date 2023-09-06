import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:responsive_builder/responsive_builder.dart';

import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import '../../constants/utils/colors.dart';
import '../../Customs/custom_text.dart';

AppBar mobileAppBar(BuildContext context, void Function(String) onOptionSelect, WidgetRef ref) {
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
            title: 'YesBroker',
            fontWeight: FontWeight.bold,
            size: 16,
          ),
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
            return appBarPopupMenuItem(e.title, onOptionSelect);
          },
        ).toList(),
        child: FutureBuilder(
            future: User.getUser(AppConst.getAccessToken().toString(), ref: ref),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Future.delayed(const Duration(seconds: 1)).then((value) => {ref.read(userDataProvider.notifier).storeUserData(snapshot.data!)});
                return Container(
                  height: 25,
                  width: 35,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(snapshot.data!.image.isEmpty ? noImg : snapshot.data!.image.toString())),
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              }
              return const SizedBox();
            }),
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
            Text(title),
          ],
        ),
      ),
    ),
  );
}
