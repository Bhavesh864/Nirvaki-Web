import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/riverpodstate/user_data.dart';

import '../../app_constant.dart';
import '../userModel/user_info.dart';

Future<List<User>> fetchUsers(WidgetRef ref) async {
  final User user = ref.read(userDataProvider);
  final snapshot = await FirebaseFirestore.instance.collection("users").where("brokerId", isEqualTo: user.brokerId).get();

  final usersListSnapshot = snapshot.docs;
  List<User> usersList = usersListSnapshot.map((doc) => User.fromSnapshot(doc)).toList();
  List<User> filterUser = usersList.where((element) => element.userId != AppConst.getAccessToken()).toList();

  return filterUser;
}
