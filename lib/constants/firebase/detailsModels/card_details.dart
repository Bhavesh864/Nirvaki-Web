import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:yes_broker/constants/app_constant.dart';

final CollectionReference cardDetailsCollection = FirebaseFirestore.instance.collection('cardDetails');

@HiveType(typeId: 1)
class CardDetails {
  @HiveField(0)
  String? cardType;
  @HiveField(1)
  String? workitemId;
  @HiveField(2)
  String? status;
  @HiveField(3)
  String? cardCategory;
  @HiveField(4)
  String? cardTitle;
  @HiveField(5)
  String? cardDescription;
  @HiveField(6)
  String? cardStatus;
  @HiveField(7)
  String? brokerid;
  @HiveField(8)
  String? managerid;
  @HiveField(9)
  List<Assignedto>? assignedto;
  @HiveField(10)
  Roomconfig? roomconfig;
  @HiveField(11)
  Propertyarearange? propertyarearange;
  @HiveField(12)
  Propertypricerange? propertypricerange;
  @HiveField(13)
  String? duedate;
  @HiveField(14)
  Createdby? createdby;
  @HiveField(15)
  String? linkedItemType;
  @HiveField(16)
  Customerinfo? customerinfo;
  @HiveField(17)
  Timestamp? createdate;
  @HiveField(18)
  String? linkedItemId;
  CardDetails(
      {this.cardType,
      required this.workitemId,
      required this.status,
      this.cardCategory,
      required this.createdate,
      this.cardTitle,
      this.cardDescription,
      this.cardStatus,
      this.linkedItemType,
      required this.brokerid,
      this.managerid,
      this.assignedto,
      this.roomconfig,
      this.propertyarearange,
      this.propertypricerange,
      this.duedate,
      this.linkedItemId,
      this.createdby,
      this.customerinfo});

  CardDetails.fromJson(Map<String, dynamic> json) {
    if (json["cardType"] is String) {
      cardType = json["cardType"];
    }
    if (json["linkedItemId"] is String) {
      linkedItemId = json["linkedItemId"];
    }
    if (json["linkedItemType"] is String) {
      linkedItemType = json["linkedItemType"];
    }
    if (json["workitemId"] is String) {
      workitemId = json["workitemId"];
    }
    if (json["Status"] is String) {
      status = json["Status"];
    }
    if (json["cardCategory"] is String) {
      cardCategory = json["cardCategory"];
    }
    if (json["createdate"] is Timestamp) {
      createdate = json["createdate"];
    }
    if (json["cardTitle"] is String) {
      cardTitle = json["cardTitle"];
    }
    if (json["cardDescription"] is String) {
      cardDescription = json["cardDescription"];
    }
    if (json["cardStatus"] is String) {
      cardStatus = json["cardStatus"];
    }
    if (json["brokerid"] is String) {
      brokerid = json["brokerid"];
    }
    if (json["managerid"] is String) {
      managerid = json["managerid"];
    }
    if (json["assignedto"] is List) {
      assignedto = json["assignedto"] == null ? null : (json["assignedto"] as List).map((e) => Assignedto.fromJson(e)).toList();
    }
    if (json["roomconfig"] is Map) {
      roomconfig = json["roomconfig"] == null ? null : Roomconfig.fromJson(json["roomconfig"]);
    }
    if (json["propertyarearange"] is Map) {
      propertyarearange = json["propertyarearange"] == null ? null : Propertyarearange.fromJson(json["propertyarearange"]);
    }
    if (json["propertypricerange"] is Map) {
      propertypricerange = json["propertypricerange"] == null ? null : Propertypricerange.fromJson(json["propertypricerange"]);
    }
    if (json["duedate"] is String) {
      duedate = json["duedate"];
    }
    if (json["createdby"] is Map) {
      createdby = json["createdby"] == null ? null : Createdby.fromJson(json["createdby"]);
    }
    if (json["customerinfo"] is Map) {
      customerinfo = json["customerinfo"] == null ? null : Customerinfo.fromJson(json["customerinfo"]);
    }
  }

  factory CardDetails.fromSnapshot(DocumentSnapshot snapshot) {
    final json = snapshot.data() as Map<String, dynamic>;

    // final createdby = json["createdby"] as Map<String, dynamic>;
    // final propertyarearange = json["propertyarearange"] as Map<String, dynamic>;
    // final propertypricerange = json["propertypricerange"] as Map<String, dynamic>;
    // final customerinfo = json["customerinfo"] as Map<String, dynamic>;

    // final List<dynamic>? assignedtoList = json["assignedto"] as List<dynamic>?;
    // List<Assignedto>? assignedtoList;

    // if (assignedtoList != null) {
    //   assignedtoList = assignedtoList.map((e) => Assignedto.fromJson(e)).toList();
    // }

    return CardDetails(
      cardType: json["cardType"] as String?,
      workitemId: json["workitemId"] as String,
      status: json["Status"] as String,
      cardCategory: json["cardCategory"] as String?,
      brokerid: json["brokerid"] as String,
      assignedto: (json["assignedto"] as List<dynamic>?)?.map((e) => Assignedto.fromJson(e)).toList(),
      managerid: json["managerid"] as String?,
      createdby: Createdby.fromJson(json["createdby"]),
      createdate: json["createdate"] as Timestamp,
      linkedItemId: json["linkedItemId"] as String?,
      linkedItemType: json["linkedItemType"] as String?,
      cardDescription: json["cardDescription"] as String?,
      cardStatus: json["cardStatus"] as String?,
      cardTitle: json["cardTitle"] as String?,
      roomconfig: json["roomconfig"] == null ? null : Roomconfig.fromJson(json["roomconfig"]),
      propertyarearange: json["propertyarearange"] == null ? null : Propertyarearange.fromJson(json['propertyarearange']),
      propertypricerange: json["propertypricerange"] == null ? null : Propertypricerange.fromJson(json["propertypricerange"]),
      duedate: json["duedate"] as String?,
      customerinfo: json["customerinfo"] == null ? null : Customerinfo.fromJson(json["customerinfo"]),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["cardType"] = cardType;
    data["workitemId"] = workitemId;
    data["Status"] = status;
    data["cardCategory"] = cardCategory;
    data["cardTitle"] = cardTitle;
    data["cardDescription"] = cardDescription;
    data["cardStatus"] = cardStatus;
    data["brokerid"] = brokerid;
    data["managerid"] = managerid;
    data["createdate"] = createdate;
    data["linkedItemType"] = linkedItemType;
    data["linkedItemId"] = linkedItemId;

    if (assignedto != null) {
      data["assignedto"] = assignedto?.map((e) => e.toJson()).toList();
    }
    if (roomconfig != null) {
      data["roomconfig"] = roomconfig?.toJson();
    }
    if (propertyarearange != null) {
      data["propertyarearange"] = propertyarearange?.toJson();
    }
    if (propertypricerange != null) {
      data["propertypricerange"] = propertypricerange?.toJson();
    }
    data["duedate"] = duedate;
    if (createdby != null) {
      data["createdby"] = createdby?.toJson();
    }
    if (customerinfo != null) {
      data["customerinfo"] = customerinfo?.toJson();
    }
    return data;
  }

  // factory CardDetails.fromSnapshot(DocumentSnapshot snapshot) {
  //   final json = snapshot.data() as Map<String, dynamic>;
  //   return CardDetails(
  //     cardType: json["cardType"],
  //     workitemId: json["workitemId"],
  //     status: json["status"],
  //     cardCategory: json["cardCategory"],
  //     brokerid: json["brokerid"],
  //     assignedto: (json["assignedto"] as List<dynamic>?)?.map((e) => Assignedto.fromJson(e)).toList(),
  //     managerid: json["managerid"],
  //     createdby: Createdby.fromJson(json["createdby"]),
  //     createdate: json["createdate"],
  //     linkedItemId: json["linkedItemId"],
  //     linkedItemType: json["linkedItemType"],
  //     cardDescription: json["cardDescription"],
  //     cardStatus: json["cardStatus"],
  //     cardTitle: json["cardTitle"],
  //   );
  // }

  // -----------------------------Methods------------------------------------------------------------------->

  static Future<void> addCardDetails(CardDetails inventory) async {
    try {
      await cardDetailsCollection.doc().set(inventory.toJson());
      // print('Inventory item added successfully');
    } catch (error) {
      // print('Failed to add Inventory item: $error');
    }
  }

  static Future<void> updateCardDetails({required String id, required CardDetails cardDetails}) async {
    try {
      QuerySnapshot querySnapshot = await cardDetailsCollection.where("workitemId", isEqualTo: id).get();
      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        await docSnapshot.reference.update(cardDetails.toJson());
      }
      if (kDebugMode) {
        print('card item updated successfully');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Failed to update card item: $error');
      }
    }
  }

  static Future<List<CardDetails>> getCardDetails() async {
    try {
      final QuerySnapshot querySnapshot = await cardDetailsCollection.orderBy("createdate", descending: true).get();
      final List<CardDetails> inventoryItems = querySnapshot.docs.map((doc) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return CardDetails.fromJson(data);
      }).toList();
      // final item = inventoryItems.where((item) {
      //   return item.assignedto!.any((user) => user.userid == AppConst.getAccessToken());
      // }).toList();
      return inventoryItems;
    } catch (error) {
      if (kDebugMode) {
        print('Failed to get Inventory items: $error');
      }
      return [];
    }
  }

  static Future<CardDetails?> getSingleCardByWorkItemId(String workItemId) async {
    try {
      final QuerySnapshot querySnapshot = await cardDetailsCollection.where('workitemId', isEqualTo: workItemId).get();

      if (querySnapshot.docs.isNotEmpty) {
        final Map<String, dynamic> data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        return CardDetails.fromJson(data);
      } else {
        return null;
      }
    } catch (error) {
      if (kDebugMode) {
        print('Failed to get CardDetails by workItemId: $error');
      }
      return null;
    }
  }

  static Future<List<CardDetails>> getcardByInventoryId(id) async {
    try {
      final QuerySnapshot querySnapshot = await cardDetailsCollection.where("linkedItemId", isEqualTo: id).get();
      final List<CardDetails> inventoryItems = querySnapshot.docs.map((doc) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return CardDetails.fromJson(data);
      }).toList();
      return inventoryItems;
    } catch (error) {
      if (kDebugMode) {
        print('Failed to get Inventory items: $error');
      }
      return [];
    }
  }

  static Future<void> updateCardStatus({required String id, required String newStatus}) async {
    try {
      QuerySnapshot querySnapshot = await cardDetailsCollection.where("workitemId", isEqualTo: id).get();

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        await docSnapshot.reference.update({'Status': newStatus});
      }

      if (kDebugMode) {
        print('Card status updated successfully for documents matching criteria.');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Failed to update card status: $error');
      }
    }
  }

  // Delete a Inventory item
  static Future<void> deleteCardDetails(String id) async {
    try {
      await cardDetailsCollection.doc(id).delete();
      if (kDebugMode) {
        print("deleted successfully");
      }
    } catch (error) {
      if (kDebugMode) {
        print('Failed to delete Inventory item: $error');
      }
    }
  }

  static Future<void> updatecardTitle({required String id, required String cardTitle}) async {
    try {
      QuerySnapshot querySnapshot = await cardDetailsCollection.where("workitemId", isEqualTo: id).get();
      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        await docSnapshot.reference.update({'cardTitle': cardTitle});
      }
      if (kDebugMode) {
        print('cardTitle update');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Failed to update card status: $error');
      }
    }
  }

  static Future<void> updateCardDate({required String id, required String duedate}) async {
    try {
      QuerySnapshot querySnapshot = await cardDetailsCollection.where("workitemId", isEqualTo: id).get();
      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        await docSnapshot.reference.update({'duedate': duedate});
      }
      print('carddate update');
    } catch (error) {
      print('Failed to update card status: $error');
    }
  }

  static Future<void> updateCardDescription({required String id, required String cardDescription}) async {
    try {
      QuerySnapshot querySnapshot = await cardDetailsCollection.where("workitemId", isEqualTo: id).get();
      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        await docSnapshot.reference.update({'cardDescription': cardDescription});
      }
      print('description update');
    } catch (error) {
      print('Failed to update card status: $error');
    }
  }

  static Future<void> updateAssignUser({required String itemid, required List<Assignedto> assignedtoList}) async {
    try {
      QuerySnapshot querySnapshot = await cardDetailsCollection.where("workitemId", isEqualTo: itemid).get();
      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

        List<Map<String, dynamic>> existingAssignToData = List<Map<String, dynamic>>.from(data['assignedto'] ?? []);

        List<Map<String, dynamic>> newAssignToData = assignedtoList.map((assignedto) => assignedto.toJson()).toList();

        existingAssignToData.addAll(newAssignToData);
        await docSnapshot.reference.update({'assignedto': existingAssignToData});
        print('Updated the list of assigned users for ${docSnapshot.id}');
      }
    } catch (error) {
      print('Failed to update assigned users: $error');
    }
  }

  static Future<List<Map<String, dynamic>>> getAssignUsersInCards({required String itemid}) async {
    try {
      QuerySnapshot querySnapshot = await cardDetailsCollection.where("workitemId", isEqualTo: itemid).get();
      List<Map<String, dynamic>> assignedUsersList = [];
      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        List<Map<String, dynamic>> existingAssignToData = List<Map<String, dynamic>>.from(data['assignedto'] ?? []);
        assignedUsersList.addAll(existingAssignToData);
      }
      return assignedUsersList;
    } catch (error) {
      print('Failed : $error');
      return []; // Return an empty list in case of an error.
    }
  }

  static Future<void> deleteCardAssignUser({required String itemId, required String userid}) async {
    try {
      QuerySnapshot querySnapshot = await cardDetailsCollection.where("workitemId", isEqualTo: itemId).get();
      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot docSnapshot = querySnapshot.docs.first;
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        List<dynamic> existinguser = data['assignedto'] ?? [];
        List<dynamic> updateduser = [];
        for (var user in existinguser) {
          if (user['userid'] != userid) {
            updateduser.add(user);
          }
        }
        await docSnapshot.reference.update({'assignedto': updateduser});
        print('updated user from this inventory$itemId');
      } else {
        print('Item not found with InventoryId: $itemId');
      }
    } catch (error) {
      print('Failed to delete user: $error');
    }
  }
}

class Customerinfo {
  String? firstname;
  String? lastname;
  String? title;
  String? mobile;
  String? whatsapp;
  String? email;

  Customerinfo({this.firstname, this.lastname, this.title, this.mobile, this.whatsapp, this.email});

  Customerinfo.fromJson(Map<String, dynamic> json) {
    if (json["firstname"] is String) {
      firstname = json["firstname"];
    }
    if (json["lastname"] is String) {
      lastname = json["lastname"];
    }
    if (json["title"] is String) {
      title = json["title"];
    }
    if (json["mobile"] is String) {
      mobile = json["mobile"];
    }
    if (json["whatsapp"] is String) {
      whatsapp = json["whatsapp"];
    }
    if (json["email"] is String) {
      email = json["email"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["firstname"] = firstname;
    data["lastname"] = lastname;
    data["title"] = title;
    data["mobile"] = mobile;
    data["whatsapp"] = whatsapp;
    data["email"] = email;
    return data;
  }
}

class Createdby {
  String? userid;
  String? userfirstname;
  String? userlastname;
  String? userimage;

  Createdby({this.userid, this.userfirstname, this.userlastname, this.userimage});

  Createdby.fromJson(Map<String, dynamic> json) {
    if (json["userid"] is String) {
      userid = json["userid"];
    }
    if (json["userfirstname"] is String) {
      userfirstname = json["userfirstname"];
    }
    if (json["userlastname"] is String) {
      userlastname = json["userlastname"];
    }
    if (json["userimage"] is String) {
      userimage = json["userimage"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["userid"] = userid;
    data["userfirstname"] = userfirstname;
    data["userlastname"] = userlastname;
    data["userimage"] = userimage;
    return data;
  }
}

class Propertypricerange {
  String? unit;
  String? arearangestart;
  String? arearangeend;

  Propertypricerange({this.unit, this.arearangestart, this.arearangeend});

  Propertypricerange.fromJson(Map<String, dynamic> json) {
    if (json["unit"] is String) {
      unit = json["unit"];
    }
    if (json["arearangestart"] is String) {
      arearangestart = json["arearangestart"];
    }
    if (json["arearangeend"] is String) {
      arearangeend = json["arearangeend"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["unit"] = unit;
    data["arearangestart"] = arearangestart;
    data["arearangeend"] = arearangeend;
    return data;
  }
}

class Propertyarearange {
  String? unit;
  dynamic arearangestart;
  dynamic arearangeend;

  Propertyarearange({this.unit, this.arearangestart, this.arearangeend});

  Propertyarearange.fromJson(Map<String, dynamic> json) {
    if (json["unit"] is String) {
      unit = json["unit"];
    }
    arearangestart = json["arearangestart"];
    arearangeend = json["arearangeend"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["unit"] = unit;
    data["arearangestart"] = arearangestart;
    data["arearangeend"] = arearangeend;
    return data;
  }
}

class Roomconfig {
  String? bedroom;
  List<String>? additionalroom;

  Roomconfig({this.bedroom, this.additionalroom});

  Roomconfig.fromJson(Map<String, dynamic> json) {
    if (json["bedroom"] is String) {
      bedroom = json["bedroom"];
    }
    if (json["additionalroom"] is List) {
      additionalroom = json["additionalroom"] == null ? null : List<String>.from(json["additionalroom"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["bedroom"] = bedroom;
    if (additionalroom != null) {
      data["additionalroom"] = additionalroom;
    }
    return data;
  }
}

class Assignedto {
  String? userid;
  String? firstname;
  String? lastname;
  String? image;
  String? assignedon;
  String? assignedby;

  Assignedto({this.userid, this.firstname, this.lastname, this.image, this.assignedon, this.assignedby});

  Assignedto.fromJson(Map<String, dynamic> json) {
    if (json["userid"] is String) {
      userid = json["userid"];
    }
    if (json["firstname"] is String) {
      firstname = json["firstname"];
    }
    if (json["lastname"] is String) {
      lastname = json["lastname"];
    }
    if (json["image"] is String) {
      image = json["image"];
    }
    if (json["assignedon"] is String) {
      assignedon = json["assignedon"];
    }
    if (json["assignedby"] is String) {
      assignedby = json["assignedby"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["userid"] = userid;
    data["firstname"] = firstname;
    data["lastname"] = lastname;
    data["image"] = image;
    data["assignedon"] = assignedon;
    data["assignedby"] = assignedby;
    return data;
  }
}
