import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference calenderModelCollection = FirebaseFirestore.instance.collection('calenderDetails');

class CalenderModel {
  String? id;
  String? calenderTitle;
  String? calenderDescription;
  String? calenderType;
  String? userId;
  String? brokerId;
  String? managerId;
  String? dueDate;
  String? time;

  CalenderModel({
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

  factory CalenderModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return CalenderModel(
      id: snapshot.id,
      calenderTitle: data['calenderTitle'],
      calenderDescription: data['calenderDescription'],
      calenderType: data['calenderType'],
      userId: data['userId'],
      brokerId: data['brokerId'],
      managerId: data['managerId'],
      dueDate: data['DueDate'],
      time: data['time'],
    );
  }

  CalenderModel.fromJson(Map<String, dynamic> json) {
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
    if (json["DueDate"] is String) {
      dueDate = json["DueDate"];
    }
    if (json["time"] is String) {
      time = json["time"];
    }
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
    data["DueDate"] = dueDate;
    data["time"] = time;
    return data;
  }

  static Future<void> addCalenderModel(CalenderModel calenderModel) async {
    try {
      await calenderModelCollection.doc(calenderModel.id).set(calenderModel.toJson());
      print('calender item added successfully');
    } catch (error) {
      print('Failed to add calender item: $error');
    }
  }

  static Future<List<CalenderModel>> getCalenderModel() async {
    try {
      final QuerySnapshot querySnapshot = await calenderModelCollection.get();
      final List<CalenderModel> items = querySnapshot.docs.map((doc) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return CalenderModel.fromJson(data);
      }).toList();
      return items;
    } catch (error) {
      print('Failed to get Inventory items: $error');
      return [];
    }
  }

  static Future<void> deleteCalenderModel(String id) async {
    try {
      await calenderModelCollection.doc(id).delete();
      print("deleted successfully");
    } catch (error) {
      print('Failed to delete Inventory item: $error');
    }
  }
}
