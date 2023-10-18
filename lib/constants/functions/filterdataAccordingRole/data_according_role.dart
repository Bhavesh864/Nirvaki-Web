import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_constant.dart';
import '../../firebase/detailsModels/card_details.dart';
import '../../firebase/userModel/user_info.dart';
import '../../user_role.dart';

// this function use filter User According to role and show data according to role in stream builder
// <----------------------------Stream builder--------------------------->
Iterable<QueryDocumentSnapshot<Map<String, dynamic>>>? filterCardsAccordingToRole(
    {required AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot, required WidgetRef ref, required List<User> userList, required User currentUser}) {
  final userRole = currentUser.role;
  final currentUserId = AppConst.getAccessToken();
  final filterItem = snapshot.data?.docs.where((item) {
    final assignedTo = item["assignedto"] as List<dynamic>?;
    switch (userRole) {
      case UserRole.broker:
        return item["brokerid"] == currentUserId;
      case UserRole.manager:
        final hasAssignedToManager = assignedTo?.any((user) => user["userid"] == currentUserId || userList.any((userinfo) => user["userid"] == userinfo.userId)) ?? false;
        return hasAssignedToManager;
      case UserRole.employee:
        return assignedTo?.any((user) => user["userid"] == currentUserId) ?? false;
      default:
        return false;
    }
  });
  return filterItem;
}

// this function use filter User According to role and show data according to role in future builder
// ---------------------------------FUTURE BUILDER----------------------------->
Iterable<CardDetails>? filterCardsAccordingToRoleInFutureBuilder(
    {required AsyncSnapshot<List<CardDetails>> snapshot, required WidgetRef ref, required List<User> userList, required User currentUser}) {
  final userRole = currentUser.role;
  final currentUserId = AppConst.getAccessToken();
  final filterItem = snapshot.data?.where((item) {
    final assignedTo = item.assignedto;
    switch (userRole) {
      case UserRole.broker:
        return item.brokerid == currentUserId;
      case UserRole.manager:
        final hasAssignedToManager = assignedTo?.any((user) => user.userid == currentUserId || userList.any((userinfo) => user.userid == userinfo.userId)) ?? false;
        return hasAssignedToManager;
      case UserRole.employee:
        return assignedTo?.any((user) => user.userid == currentUserId) ?? false;

      default:
        return false;
    }
  });

  return filterItem;
}
