import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/routes/routes.dart';
import 'package:yes_broker/screens/account_screens/common_screen.dart';
import 'package:yes_broker/widgets/app/nav_bar.dart';
import 'package:yes_broker/widgets/app/speed_dial_button.dart';

import '../constants/functions/auth/auth_functions.dart';
import '../widgets/chat_modal_view.dart';

class LargeScreen extends ConsumerStatefulWidget {
  const LargeScreen({Key? key}) : super(key: key);

  @override
  LargeScreenState createState() => LargeScreenState();
}

class LargeScreenState extends ConsumerState<LargeScreen> {
  showChatDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return const ChatDialogBox();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int currentIndex = 0;
    final beamerKey = GlobalKey<BeamerState>();

    final path = (context.currentBeamLocation.state as BeamState).uri.path;

    if (path.contains('/ ')) {
      currentIndex = 0;
    } else if (path.contains('/todo')) {
      currentIndex = 1;
    } else if (path.contains('/inventory')) {
      currentIndex = 2;
    } else if (path.contains('/lead')) {
      currentIndex = 3;
    } else if (path.contains('/chat')) {
      currentIndex = 4;
    } else if (path.contains('/calendar')) {
      currentIndex = 5;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SingleChildScrollView(
            child: Container(
              color: Colors.white,
              height: 600,
              padding: EdgeInsets.only(top: height! * 0.2),
              child: NavigationRail(
                backgroundColor: Colors.white,
                minWidth: 60,
                useIndicator: false,
                onDestinationSelected: (index) {
                  setState(() {
                    beamerKey.currentState?.routerDelegate.beamToNamed(sideBarItems[index].nav);
                  });
                },
                destinations: sideBarItems
                    .sublist(0, 6)
                    .map(
                      (e) => NavigationRailDestination(
                        icon: Icon(e.iconData),
                        selectedIcon: Icon(e.iconData, color: AppColor.primary),
                        label: const Text('Yes Broker'),
                      ),
                    )
                    .toList(),
                selectedIndex: currentIndex > 5 ? 0 : currentIndex,
              ),
            ),
          ),
          Expanded(
            flex: 20,
            child: Column(
              children: [
                LargeScreenNavBar(
                  (selectedVal) {
                    if (selectedVal != 'Logout') {
                      final ProfileMenuItems profile = profileMenuItems.firstWhere((element) => element.title == selectedVal);
                      ref.read(selectedProfileItemProvider.notifier).setSelectedItem(profile);
                      context.beamToNamed('/profile');
                    } else if (selectedVal == "Logout") {
                      userLogout(ref, context);
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
      floatingActionButton: !AppConst.getPublicView()
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CustomSpeedDialButton(),
                const SizedBox(
                  height: 10,
                ),
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColor.primary,
                  child: IconButton(
                    icon: const Icon(
                      Icons.chat_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () {
                      showChatDialog();
                    },
                  ),
                ),
              ],
            )
          : null,
    );
  }
}
