import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference notificationCollection = FirebaseFirestore.instance.collection('notification');

class NotificationModel {
  String? title;
  String? notificationContent;
  Timestamp? receiveDate;
  String? linkedItemId;
  String? imageUrl;
  String? userId;

  NotificationModel({this.notificationContent, this.receiveDate, this.linkedItemId, this.imageUrl, this.userId, this.title});
  factory NotificationModel.fromSnapshot(DocumentSnapshot snapshot) {
    final json = snapshot.data() as Map<String, dynamic>;

    return NotificationModel(
      title: json["title"],
      notificationContent: json["notificationContent"],
      receiveDate: json["receiveDate"],
      linkedItemId: json["linkedItemId"],
      imageUrl: json["imageUrl"],
      userId: json["userId"],
    );
  }

  NotificationModel.fromJson(Map<String, dynamic> json) {
    if (json["notificationContent"] is String) {
      notificationContent = json["notificationContent"];
    }
    if (json["receiveDate"] is Timestamp) {
      receiveDate = json["receiveDate"];
    }
    if (json["linkedItemId"] is String) {
      linkedItemId = json["linkedItemId"];
    }
    if (json["imageUrl"] is String) {
      imageUrl = json["imageUrl"];
    }
    if (json["userId"] is String) {
      imageUrl = json["userId"];
    }
    if (json["title"] is String) {
      imageUrl = json["title"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["notificationContent"] = notificationContent;
    data["receiveDate"] = receiveDate;
    data["linkedItemId"] = linkedItemId;
    data["imageUrl"] = imageUrl;
    data["userId"] = userId;
    data["title"] = title;
    return data;
  }

  static Future<void> addNotification(NotificationModel notification) async {
    try {
      await notificationCollection.doc().set(notification.toJson());
      // print('User added successfully');
    } catch (error) {
      // print('Failed to add user: $error');
    }
  }

  // static Future<List<NotificationModel>> getNotificationModel(String userid) async {
  //   try {
  //     final QuerySnapshot querySnapshot = await notificationCollection.where("userId", isEqualTo: userid).get();
  //     final List<NotificationModel> notifications = querySnapshot.docs.map((doc) {
  //       final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //       return NotificationModel.fromJson(data);
  //     }).toList();
  //     return notifications;
  //   } catch (error) {
  //     print('Failed to get notificaiton: $error');
  //     return [];
  //   }
  // }
}
