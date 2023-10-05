import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:yes_broker/constants/firebase/random_uid.dart';
import 'package:yes_broker/constants/firebase/userModel/notification_model.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';

import '../app_constant.dart';

const serverKey = "AAAAyk5ZDg8:APA91bF9gOEKgpPLOmPskYJ5kTuxuTOxX7eRPh0XSmzPJYINEE6DjhmHQAHlU4TntXJgo92oArPrIfhSsFAEyVQEDsL7YgY0YyXBFoYgX5_i1pxoOVkQwvtSdguxzDI1n9bskHdQ-30Q";

Future<void> sendNotificationTouser({
  required String token,
  required String title,
  required String content,
  required String itemid,
  required User currentuserdata,
  required List<String> usersIds,
}) async {
  var data = {
    'to': token,
    'notification': {'title': title, 'body': content},
    'android': {
      'notification': {
        'notification_count': 23,
      },
    },
    'data': {'id': itemid, "imageUrl": currentuserdata.image}
  };
  await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
      body: jsonEncode(data), headers: {'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'key=$serverKey'}).then((value) {
    if (value.statusCode == 200) {
      setNotificationTOfirestore(title, content, itemid, currentuserdata, usersIds);
    }
    if (kDebugMode) {
      print(value.body.toString());
    }
  }).onError((error, stackTrace) {
    if (kDebugMode) {
      print(error);
    }
  });
}

void notifyToUser({
  required dynamic assignedto,
  required String title,
  required String content,
  bool assigntofield = false,
  required String itemid,
  required User currentuserdata,
}) async {
  try {
    List<String> userids = [];
    if (assigntofield) {
      userids.add(assignedto);
    } else {
      for (var data in assignedto) {
        userids.add(data.userid);
      }
    }
    List<String> tokens = await User.getUserTokensByIds(userids);

    for (var token in tokens) {
      if (AppConst.getFcmToken() != token) {
        await sendNotificationTouser(token: token, title: title, content: content, itemid: itemid, currentuserdata: currentuserdata, usersIds: userids);
      }
    }
  } catch (e) {
    print(e.toString());
  }

  print('object');
}

Future<void> setNotificationTOfirestore(String title, String content, String itemid, User currentuserdata, List<String> usersIds) async {
  try {
    NotificationModel notificationModel = NotificationModel(
      title: title,
      notificationContent: content,
      receiveDate: Timestamp.now(),
      linkedItemId: itemid,
      imageUrl: currentuserdata.image,
      userId: usersIds.where((element) => element != AppConst.getAccessToken()).toList(),
      isRead: false,
      id: generateUid(),
    );
    await NotificationModel.addNotification(notificationModel);
  } catch (e) {
    print(e.toString());
  }
}

Future<String> getAllCategoryItems(String text) async {
  print(text);
  final uri = Uri.parse('https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${text}&key=AIzaSyBJXgFzyAEn02NMURljQ5xNdsPehFL9mXA');

  final response = await http.get(uri, headers: {"Accept": "application/json", "Access-Control_Allow_Origin": "*"});
  var responseData = json.decode(response.body.toString());
  if (response.statusCode == 200) {
    print("responseData=----> $responseData");
    return responseData["predictions"][0]["description"];
  } else {
    throw Exception('Failed to load data');
  }
}
