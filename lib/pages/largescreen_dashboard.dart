import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/Customs/text_utility.dart';

import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/routes/routes.dart';
import 'package:yes_broker/screens/account_screens/common_screen.dart';
import 'package:yes_broker/widgets/app/nav_bar.dart';
import '../constants/app_constant.dart';
import '../constants/functions/auth/auth_functions.dart';
import '../constants/functions/chat_group/group.dart';
import '../screens/account_screens/Teams/team_screen.dart';

class LargeScreen extends ConsumerStatefulWidget {
  const LargeScreen({Key? key}) : super(key: key);

  @override
  LargeScreenState createState() => LargeScreenState();
}

class LargeScreenState extends ConsumerState<LargeScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    int currentIndex = 0;
    final beamerKey = GlobalKey<BeamerState>();
    AppConst.setOuterContext(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          StatefulBuilder(builder: (context, setstate) {
            final path = (context.currentBeamLocation.state as BeamState).uri.path;

            if (path.contains('/ ')) {
              currentIndex = 0;
            } else if (path.contains('/todo')) {
              currentIndex = 1;
            } else if (path.contains('/inventory')) {
              currentIndex = 2;
            } else if (path.contains('/lead')) {
              currentIndex = 3;
            } else if (path.contains('/calendar')) {
              currentIndex = 4;
            } else if (path.contains('/profile')) {
              currentIndex = 5;
            } else {
              currentIndex = 0;
            }

            return SingleChildScrollView(
              child: Container(
                color: Colors.white,
                height: 600,
                padding: EdgeInsets.only(top: height! * 0.2),
                child: NavigationRail(
                  backgroundColor: Colors.white,
                  labelType: NavigationRailLabelType.all,
                  minWidth: 60,
                  useIndicator: false,
                  selectedIndex: currentIndex > 4 ? 0 : currentIndex,
                  onDestinationSelected: (index) {
                    setstate(
                      () {
                        selectedIndex = index;
                        beamerKey.currentState?.routerDelegate.beamToNamed(sideBarItems[index].nav);
                      },
                    );
                  },
                  destinations: sideBarItems
                      .sublist(0, 5)
                      .map(
                        (
                          e,
                        ) =>
                            NavigationRailDestination(
                                label: const AppText(text: '', fontsize: 0),
                                icon: Container(
                                    width: 40,
                                    padding: const EdgeInsets.symmetric(vertical: 2),
                                    // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: currentIndex == sideBarItems.indexOf(e) ? const Color.fromRGBO(68, 96, 239, 0.1) : Colors.transparent,
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(
                                          e.iconData,
                                        ),
                                        AppText(
                                          text: e.label,
                                          fontsize: 9,
                                          textColor: currentIndex == sideBarItems.indexOf(e) ? AppColor.primary : Colors.black,
                                        )
                                      ],
                                    ))
                                // icon: Icon(e.iconData),
                                // selectedIcon: Icon(e.iconData, color: AppColor.primary),
                                // label: Text(
                                //   e.label,
                                //   style: const TextStyle(
                                //     fontSize: 10,
                                //   ),
                                // ),
                                ),
                      )
                      .toList(),
                ),
              ),
            );
          }),
          Expanded(
            flex: 20,
            child: Column(
              children: [
                LargeScreenNavBar(
                  (selectedVal) {
                    if (selectedVal != 'Logout') {
                      final ProfileMenuItems profile = profileMenuItems.firstWhere((element) => element.title == selectedVal);
                      ref.read(selectedProfileItemProvider.notifier).setSelectedItem(profile);
                      if (profile.id == 2) {
                        ref.read(addMemberScreenStateProvider.notifier).setAddMemberScreenState(false);
                      }
                      setState(
                        () {
                          beamerKey.currentState?.routerDelegate.beamToNamed(sideBarItems[7].nav);
                        },
                      );
                      // context.beamToNamed('/profile');
                    } else if (selectedVal == "Logout") {
                      customConfirmationAlertDialog(context, () {
                        userLogout(ref, context);
                      }, 'Logout', 'Are you sure you want to logout?');
                    }
                  },
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.secondary,
                          spreadRadius: 12,
                          blurRadius: 4,
                          offset: Offset(5, 5),
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: BeamerScreenNavigation(beamerKey: beamerKey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // floatingActionButton: !AppConst.getPublicView()
      //     ? Column(
      //         mainAxisAlignment: MainAxisAlignment.end,
      //         children: [
      //           const CustomSpeedDialButton(),
      //           const SizedBox(
      //             height: 10,
      //           ),
      //           CircleAvatar(
      //             radius: 28,
      //             backgroundColor: AppColor.primary,
      //             child: IconButton(
      //               icon: const Icon(
      //                 Icons.chat_outlined,
      //                 color: Colors.white,
      //                 size: 24,
      //               ),
      //               onPressed: () {
      //                 showChatDialog();
      //               },
      //             ),
      //           ),
      //         ],
      //       )
      //     : null,
    );
  }
}
