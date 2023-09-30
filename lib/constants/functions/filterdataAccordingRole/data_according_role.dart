import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_constant.dart';
import '../../firebase/userModel/user_info.dart';
import '../../user_role.dart';

Iterable<QueryDocumentSnapshot<Map<String, dynamic>>>? filterCardsAccordingToRole(
    {required AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot, required WidgetRef ref, required List<User> userList, required User currentUser}) {
  // final user = ref.watch(userDataProvider);
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
        final hasUserList = userList.isNotEmpty;
        if (hasUserList) {
          final hasAssignedToManager = assignedTo?.any((user) => user["userid"] == currentUserId || userList.any((userinfo) => user["userid"] == userinfo.userId)) ?? false;
          return hasAssignedToManager;
        } else {
          return assignedTo?.any((user) => user["userid"] == currentUserId) ?? false;
        }
      default:
        return false;
    }
  });

  return filterItem;
}
