import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const serverKey = "AAAAyk5ZDg8:APA91bF9gOEKgpPLOmPskYJ5kTuxuTOxX7eRPh0XSmzPJYINEE6DjhmHQAHlU4TntXJgo92oArPrIfhSsFAEyVQEDsL7YgY0YyXBFoYgX5_i1pxoOVkQwvtSdguxzDI1n9bskHdQ-30Q";

Future<void> sendNotificationTouser() async {
  var data = {
    'to': "dThYqIbBTUKzOwJlGuQGZd:APA91bE07p2ChhP3Ovt0G26lBcVkgKF8WtW5g7FE4IK6wp2-ZHsxluuCHT2QgQOGwi1w-3ZW9IVXyPs8hHzOgy-ptpG0wt0yqHAru_TaBzCaLTWYto7ufv_i9BZ6TClCYfZEFjMjCJoU",
    'notification': {'title': 'madhav', 'body': 'hello madhav'},
    'android': {
      'notification': {
        'notification_count': 23,
      },
    },
    'data': {'type': 'msj', 'id': 'Asif Taj'}
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
