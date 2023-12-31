// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

final CollectionReference calendarModelCollection = FirebaseFirestore.instance.collection('calenderDetails');

class CalendarModel {
  String? id;
  String? calenderTitle;
  String? calenderDescription;
  String? calenderType;
  String? userId;
  String? brokerId;
  String? managerId;
  String? dueDate;
  String? time;

  CalendarModel({
    this.id,
    this.calenderTitle,
    this.calenderDescription,
    this.calenderType,
    this.userId,
    this.brokerId,
    this.managerId,
    this.dueDate,
    this.time,
  });

  factory CalendarModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return CalendarModel(
      id: snapshot.id,
      calenderTitle: data['calenderTitle'],
      calenderDescription: data['calenderDescription'],
      calenderType: data['calenderType'],
      userId: data['userId'],
      brokerId: data['brokerId'],
      managerId: data['managerId'],
      dueDate: data['dueDate'],
      time: data['time'],
    );
  }

  factory CalendarModel.fromMap(Map<String, dynamic> map) {
    return CalendarModel(
      id: map['id'] as String,
      calenderTitle: map['calenderTitle'] as String,
      calenderDescription: map['calenderDescription'] as String,
      time: map['time'] as String,
      calenderType: map['calenderType'] as String,
      userId: map['userId'] as String,
      brokerId: map['brokerId'] as String,
      managerId: map['managerId'] as String,
      dueDate: map['dueDate'] as String,
    );
  }

  CalendarModel.fromJson(Map<String, dynamic> json) {
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["calenderTitle"] is String) {
      calenderTitle = json["calenderTitle"];
    }
    if (json["calenderDescription"] is String) {
      calenderDescription = json["calenderDescription"];
    }
    if (json["calenderType"] is String) {
      calenderType = json["calenderType"];
    }
    if (json["userId"] is String) {
      userId = json["userId"];
    }
    if (json["brokerId"] is String) {
      brokerId = json["brokerId"];
    }
    if (json["managerId"] is String) {
      managerId = json["managerId"];
    }
    if (json["dueDate"] is String) {
      dueDate = json["dueDate"];
    }
    if (json["time"] is String) {
      time = json["time"];
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'calenderTitle': calenderTitle,
      'calenderDescription': calenderDescription,
      'calenderType': calenderType,
      'brokerId': brokerId,
      'managerId': managerId,
      'dueDate': dueDate,
      "time": time,
    };
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["calenderTitle"] = calenderTitle;
    data["calenderDescription"] = calenderDescription;
    data["calenderType"] = calenderType;
    data["userId"] = userId;
    data["brokerId"] = brokerId;
    data["managerId"] = managerId;
    data["dueDate"] = dueDate;
    data["time"] = time;
    return data;
  }

  static Future<void> addCalendarModel(CalendarModel calendarModel) async {
    try {
      await calendarModelCollection.doc(calendarModel.id).set(calendarModel.toJson());
      if (kDebugMode) {
        print('calender item added successfully');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Failed to add calender item: $error');
      }
    }
  }

  static Future<void> updateCalendarModel(CalendarModel calendarModel) async {
    try {
      await calendarModelCollection.doc(calendarModel.id).update(calendarModel.toJson());
      if (kDebugMode) {
        print('calender item updated successfully');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Failed to add calender item: $error');
      }
    }
  }

  static Future<List<CalendarModel>> getCalendarModel() async {
    try {
      final QuerySnapshot querySnapshot = await calendarModelCollection.get();
      final List<CalendarModel> items = querySnapshot.docs.map((doc) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return CalendarModel.fromJson(data);
      }).toList();
      return items;
    } catch (error) {
      if (kDebugMode) {
        print('Failed to get Inventory items: $error');
      }
      return [];
    }
  }

  static Future<void> deleteCalendarModel(String id) async {
    try {
      await calendarModelCollection.doc(id).delete();
      if (kDebugMode) {
        print("deleted successfully");
      }
    } catch (error) {
      if (kDebugMode) {
        print('Failed to delete Inventory item: $error');
      }
    }
  }
}
