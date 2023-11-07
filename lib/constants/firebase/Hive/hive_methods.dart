import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../userModel/user_info.dart';

class UserHiveMethods {
  static Box userInfoBox = Hive.box("users");

  static getdata(key) {
    return userInfoBox.get(key);
  }

  static addData({required key, required data}) {
    userInfoBox.put(key, data);
  }

  static deleteData(key) {
    userInfoBox.delete(key);
  }
}

class UserListPreferences {
  static const String _key = 'user_list';

  static Future<void> saveUserList(List<User> userList) async {
    final prefs = await SharedPreferences.getInstance();
    final userMapList = userList.map((user) => user.toMap()).toList();
    await prefs.setStringList(_key, userMapList.map((map) => jsonEncode(map)).toList());
  }

  static Future<List<User>> getUserList() async {
    final prefs = await SharedPreferences.getInstance();
    final userMapList = prefs.getStringList(_key);
    if (userMapList == null) return [];
    return userMapList.map((userMap) => User.fromMap(jsonDecode(userMap))).toList();
  }

  static Future<void> deleteUserList() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
