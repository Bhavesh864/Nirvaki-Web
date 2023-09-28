import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../riverpodstate/user_data.dart';
import '../../app_constant.dart';
import '../../firebase/userModel/user_info.dart';
import '../../user_role.dart';

Iterable<QueryDocumentSnapshot<Map<String, dynamic>>>? filterCardsAccordingToRole(
    {required AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot, required WidgetRef ref, setState}) {
  List<User> users = [];
  final user = ref.watch(userDataProvider);
  getDetails(User currentuser) async {
    final List<User> userList = await User.getUserAllRelatedToBrokerId(currentuser, currentuser.userId);
    if (users.isEmpty) {
      users = userList;
      setState(() {});
    }
  }

  final filterItem = snapshot.data?.docs.where((item) {
    if (user == null) return false;
    final userRole = user.role;
    final currentUserId = AppConst.getAccessToken();
    final assignedTo = item["assignedto"] as List<dynamic>?;
    switch (userRole) {
      case UserRole.broker:
        return item["brokerid"] == currentUserId;
      case UserRole.manager:
        getDetails(user);
        final hasAssignedToManager = assignedTo?.any((user) => users.any((userinfo) => user["userid"] == userinfo.userId)) ?? false;
        return hasAssignedToManager || assignedTo!.any((user) => user["userid"] == currentUserId);
      case UserRole.employee:
        return assignedTo?.any((user) => user["userid"] == currentUserId) ?? false;
      default:
        return false;
    }
  });

  return filterItem;
  // if (user?.role != null) {
  //   final filterItem = snapshot.data?.where((item) {
  //     final userRole = user?.role;
  //     final currentUserId = AppConst.getAccessToken();
  //     final assignedTo = item.assignedto;
  //     switch (userRole) {
  //       case UserRole.broker:
  //         return item.brokerid == currentUserId;
  //       case UserRole.manager:
  //         getDetails(user!);
  //         final hasAssignedToManager = assignedTo?.any((user) => users.any((userinfo) => user.userid == userinfo.userId)) ?? false;
  //         return hasAssignedToManager || assignedTo!.any((user) => user.userid == currentUserId);
  //       case UserRole.employee:
  //         return assignedTo?.any((user) => user.userid == currentUserId) ?? false;
  //       default:
  //         return false;
  //     }
  //   });
  //   return filterItem;
  // }
  // return snapshot.data;
}
