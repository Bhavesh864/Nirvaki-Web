import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../routes/routes.dart';
import '../../../screens/account_screens/common_screen.dart';
import '../../app_constant.dart';
import '../../firebase/Hive/hive_methods.dart';
import '../../firebase/userModel/broker_info.dart';

void userLogout(WidgetRef ref, BuildContext context) {
  authentication.signOut().then(
        (value) => {
          context.beamToReplacementNamed(AppRoutes.loginScreen),
        },
      );
  UserHiveMethods.deleteData(AppConst.getAccessToken());
  UserHiveMethods.deleteData("token");
  ref.read(selectedProfileItemProvider.notifier).setSelectedItem(null);
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
