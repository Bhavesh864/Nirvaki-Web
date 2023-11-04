// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference notificationCollection = FirebaseFirestore.instance.collection('notification');

class NotificationModel {
  String? id;
  String? title;
  String? notificationContent;
  Timestamp? receiveDate;
  String? linkedItemId;
  String? createdUserId;
  List<String>? userId;
  bool? isRead;

  NotificationModel({
    this.id,
    this.title,
    this.notificationContent,
    this.receiveDate,
    this.linkedItemId,
    this.createdUserId,
    this.userId,
    this.isRead,
  });

  factory NotificationModel.fromSnapshot(DocumentSnapshot snapshot) {
    final json = snapshot.data() as Map<String, dynamic>;

    return NotificationModel(
      title: json["title"],
      notificationContent: json["notificationContent"],
      receiveDate: json["receiveDate"],
      linkedItemId: json["linkedItemId"],
      createdUserId: json["createdUserId"],
      userId: json["userId"] == null ? null : List<String>.from(json["userId"]),
      isRead: json['isRead'],
      id: json['id'],
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
    if (json["createdUserId"] is String) {
      createdUserId = json["createdUserId"];
    }
    if (json["userId"] is List) {
      userId = json["userId"] == null ? null : List<String>.from(json["userId"]);
    }
    if (json["title"] is String) {
      title = json["title"];
    }
    if (json["isRead"] is bool) {
      isRead = json["isRead"];
    }
    if (json["id"] is bool) {
      isRead = json["id"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["notificationContent"] = notificationContent;
    data["receiveDate"] = receiveDate;
    data["linkedItemId"] = linkedItemId;
    data["createdUserId"] = createdUserId;
    data["userId"] = userId;
    data["title"] = title;
    data["isRead"] = isRead;
    data["id"] = id;
    if (userId != null) {
      data["userId"] = userId;
    }
    return data;
  }

  static Future<void> addNotification(NotificationModel notification) async {
    try {
      await notificationCollection.doc(notification.id).set(notification.toJson());
      print('User added successfully');
    } catch (error) {
      print('Failed to add user: $error');
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
