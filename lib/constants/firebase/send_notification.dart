import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';

import '../app_constant.dart';

const serverKey = "AAAAyk5ZDg8:APA91bF9gOEKgpPLOmPskYJ5kTuxuTOxX7eRPh0XSmzPJYINEE6DjhmHQAHlU4TntXJgo92oArPrIfhSsFAEyVQEDsL7YgY0YyXBFoYgX5_i1pxoOVkQwvtSdguxzDI1n9bskHdQ-30Q";

Future<void> sendNotificationTouser({required String token, required String title, required String content}) async {
  var data = {
    'to': token,
    'notification': {'title': title, 'body': content},
    'android': {
      'notification': {
        'notification_count': 23,
      },
    },
    'data': {'type': 'status', 'id': 'notify'}
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

void notifyToUser({required dynamic itemdetail, required String title, required String content}) async {
  List<String> userids = [];
  for (var data in itemdetail.assignedto!) {
    userids.add(data.userid!);
  }
  List<String> tokens = await User.getUserTokensByIds(userids);
  for (var token in tokens) {
    if (AppConst.getFcmToken() != token) {
      await sendNotificationTouser(token: token, title: title, content: content);
    }
  }
}
