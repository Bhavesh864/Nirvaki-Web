import 'package:hive/hive.dart';

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
