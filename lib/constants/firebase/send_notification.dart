import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';

import '../app_constant.dart';

const serverKey = "AAAAyk5ZDg8:APA91bF9gOEKgpPLOmPskYJ5kTuxuTOxX7eRPh0XSmzPJYINEE6DjhmHQAHlU4TntXJgo92oArPrIfhSsFAEyVQEDsL7YgY0YyXBFoYgX5_i1pxoOVkQwvtSdguxzDI1n9bskHdQ-30Q";

Future<void> sendNotificationTouser({required String token, required String title, required String content, required String itemid}) async {
  var data = {
    'to': token,
    'notification': {'title': title, 'body': content},
    'android': {
      'notification': {
        'notification_count': 23,
      },
    },
    'data': {'id': itemid, "imageUrl": currentUser["image"] ?? ""}
  };
  await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
      body: jsonEncode(data), headers: {'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'key=$serverKey'}).then((value) {
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
    print("tokens$tokens");
    for (var token in tokens) {
      if (AppConst.getFcmToken() != token) {
        await sendNotificationTouser(
          token: token,
          title: title,
          content: content,
          itemid: itemid,
        );
      }
    }
  } catch (e) {
    print(e.toString());
  }

  print('object');
}
