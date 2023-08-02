import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:yes_broker/constants/firebase/Hive/hive_methods.dart';

import 'package:yes_broker/constants/firebase/userModel/broker_info.dart';

import 'package:yes_broker/constants/firebase/userModel/broker_info.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/constants.dart';

import 'package:yes_broker/routes/routes.dart';

import 'package:yes_broker/widgets/app/nav_bar.dart';
import 'package:yes_broker/widgets/app/speed_dial_button.dart';

final currentIndexProvider = StateProvider<int>((ref) {
  return 0;
});

class LargeScreen extends ConsumerWidget {
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {},
    );
    Widget continueButton = TextButton(
      child: const Text("Continue"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("AlertDialog"),
      content: const Text("Would you like to continue learning how to use Flutter alerts?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  const LargeScreen({Key? key}) : super(key: key);

  void _showChatDialog(BuildContext context) {
    showDialog(
      context: context,
      // position: RelativeRect.fromLTRB(offset.dx, offset.dy, offset.dx + button.size.width, offset.dy + button.size.height),
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Chat Dialog Box'), // Replace with your dialog title
          content: const Text('This is the content of the chat dialog box.'), // Replace with your dialog content
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog box
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // void _showChatDialog(BuildContext context) {
  //   final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
  //   final chatButton = overlay.localToGlobal(Offset.zero);

  //   showMenu(
  //     context: context,
  //     position: RelativeRect.fromLTRB(
  //       chatButton.dx,
  //       chatButton.dy,
  //       chatButton.dx + 1000, // Adjust this value to position the dialog horizontally
  //       chatButton.dy + 300, // Adjust this value to position the dialog vertically
  //     ),
  //     items: [
  //       PopupMenuItem(
  //         child: Container(
  //           width: 200,
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               ListTile(
  //                 leading: Icon(Icons.chat_outlined),
  //                 title: Text('Chat Dialog Box'), // Replace with your dialog title
  //                 subtitle: Text('This is the content of the chat dialog box.'), // Replace with your dialog content
  //               ),
  //               Align(
  //                 alignment: Alignment.centerRight,
  //                 child: IconButton(
  //                   onPressed: () {
  //                     Navigator.of(context).pop(); // Close the dialog box
  //                   },
  //                   icon: Icon(Icons.close),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         enabled: false,
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);

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
                  ref.read(currentIndexProvider.notifier).update((state) => index);
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
                LargeScreenNavBar((selectedVal) {
                  if (selectedVal == 'Profile') {
                    ref.read(currentIndexProvider.notifier).update((state) => 6);
                  } else if (selectedVal == "Logout") {
                    authentication.signOut().then((value) => {Navigator.of(context).pushReplacementNamed(AppRoutes.loginScreen)});
                    UserHiveMethods.deleteData(authentication.currentUser?.uid);
                  }
                }),
                Expanded(
                  child: sideBarItems[currentIndex].screen,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
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
                popupMenuItem('title');
              },
            ),
          ),
        ],
      ),
    );
  }
}
