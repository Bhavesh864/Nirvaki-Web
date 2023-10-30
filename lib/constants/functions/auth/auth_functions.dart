import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/pages/smallscreen_dashboard.dart';
import 'package:yes_broker/riverpodstate/user_data.dart';
import '../../../chat/controller/chat_controller.dart';

import '../../../screens/account_screens/common_screen.dart';
import '../../app_constant.dart';
import '../../firebase/Hive/hive_methods.dart';
import '../../firebase/userModel/broker_info.dart';

void userLogout(WidgetRef ref, BuildContext context) {
  authentication.signOut().then(
        (value) => {
          ref.read(chatControllerProvider).setUserState(false),
          ref.read(mobileBottomIndexProvider.notifier).update((state) => 0),
          // context.beamToReplacementNamed('/login'),
          Beamer.of(context).beamToReplacementNamed('/'),
          Navigator.of(context).pop(),
          User.updateFcmToken(fcmtoken: null, userid: AppConst.getAccessToken()),
          UserHiveMethods.deleteData(AppConst.getAccessToken()),
          UserHiveMethods.deleteData("token"),
          UserHiveMethods.deleteData("brokerId"),
          ref.read(selectedProfileItemProvider.notifier).setSelectedItem(null),
          ref.read(userDataProvider.notifier).resetState(),
          AppConst.setAccessToken(null),
          AppConst.setRole(""),
        },
      );
}

// void logoutaction(WidgetRef ref, BuildContext context) {
//   authentication.signOut().then((value) {
//     // Navigator.of(context).pushReplacementNamed(AppRoutes.loginScreen);
//     context.beamToReplacementNamed('/');
//   });
//   UserHiveMethods.deleteData(AppConst.getAccessToken());
//   ref.read(selectedProfileItemProvider.notifier).setSelectedItem(null);
//   UserHiveMethods.deleteData("token");
// }

