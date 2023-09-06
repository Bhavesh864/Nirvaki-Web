import 'package:cloud_firestore/cloud_firestore.dart';

import '../../app_constant.dart';
import '../userModel/user_info.dart';

Future<List<User>> fetchUsers() async {
  final snapshot = await FirebaseFirestore.instance.collection("users").where("brokerId", isEqualTo: currentUser["brokerId"]).get();

  final usersListSnapshot = snapshot.docs;
  List<User> usersList = usersListSnapshot.map((doc) => User.fromSnapshot(doc)).toList();
  List<User> filterUser = usersList.where((element) => element.userId != AppConst.getAccessToken()).toList();

  return filterUser;
}
