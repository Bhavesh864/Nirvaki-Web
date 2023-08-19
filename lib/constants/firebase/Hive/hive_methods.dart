import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class CardDetailsHiveMethods {
  static Box carddetailsHiveBox = Hive.box("carddetails");

  static getdata(key) {
    return carddetailsHiveBox.get(key);
  }

  static addData({required key, required data}) {
    carddetailsHiveBox.put(key, data);
  }

  static deleteData(key) {
    carddetailsHiveBox.delete(key);
  }
}

class SharedPreferece {
  static Future<void> saveDataLocally(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<String?> retrieveDataLocally(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> deleteDataLocally(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
