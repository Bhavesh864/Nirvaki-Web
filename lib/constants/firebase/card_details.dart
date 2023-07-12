import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference cardDetailsCollection =
    FirebaseFirestore.instance.collection('cardDetails');

class CardDetails {
  String? cardType;
  String? workitemId;
  String? status;
  String? cardCategory;
  String? cardTitle;
  String? cardDescription;
  String? cardStatus;
  String? brokerid;
  String? managerid;
  List<Assignedto>? assignedto;
  Roomconfig? roomconfig;
  Propertyarearange? propertyarearange;
  Propertypricerange? propertypricerange;
  String? duedate;
  Createdby? createdby;
  Customerinfo? customerinfo;

  CardDetails(
      {this.cardType,
      this.workitemId,
      this.status,
      this.cardCategory,
      this.cardTitle,
      this.cardDescription,
      this.cardStatus,
      this.brokerid,
      this.managerid,
      this.assignedto,
      this.roomconfig,
      this.propertyarearange,
      this.propertypricerange,
      this.duedate,
      this.createdby,
      this.customerinfo});

  CardDetails.fromJson(Map<String, dynamic> json) {
    if (json["cardType"] is String) {
      cardType = json["cardType"];
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
      assignedto = json["assignedto"] == null
          ? null
          : (json["assignedto"] as List)
              .map((e) => Assignedto.fromJson(e))
              .toList();
    }
    if (json["roomconfig"] is Map) {
      roomconfig = json["roomconfig"] == null
          ? null
          : Roomconfig.fromJson(json["roomconfig"]);
    }
    if (json["propertyarearange"] is Map) {
      propertyarearange = json["propertyarearange"] == null
          ? null
          : Propertyarearange.fromJson(json["propertyarearange"]);
    }
    if (json["propertypricerange"] is Map) {
      propertypricerange = json["propertypricerange"] == null
          ? null
          : Propertypricerange.fromJson(json["propertypricerange"]);
    }
    if (json["duedate"] is String) {
      duedate = json["duedate"];
    }
    if (json["createdby"] is Map) {
      createdby = json["createdby"] == null
          ? null
          : Createdby.fromJson(json["createdby"]);
    }
    if (json["customerinfo"] is Map) {
      customerinfo = json["customerinfo"] == null
          ? null
          : Customerinfo.fromJson(json["customerinfo"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["cardType"] = cardType;
    _data["workitemId"] = workitemId;
    _data["Status"] = status;
    _data["cardCategory"] = cardCategory;
    _data["cardTitle"] = cardTitle;
    _data["cardDescription"] = cardDescription;
    _data["cardStatus"] = cardStatus;
    _data["brokerid"] = brokerid;
    _data["managerid"] = managerid;
    if (assignedto != null) {
      _data["assignedto"] = assignedto?.map((e) => e.toJson()).toList();
    }
    if (roomconfig != null) {
      _data["roomconfig"] = roomconfig?.toJson();
    }
    if (propertyarearange != null) {
      _data["propertyarearange"] = propertyarearange?.toJson();
    }
    if (propertypricerange != null) {
      _data["propertypricerange"] = propertypricerange?.toJson();
    }
    _data["duedate"] = duedate;
    if (createdby != null) {
      _data["createdby"] = createdby?.toJson();
    }
    if (customerinfo != null) {
      _data["customerinfo"] = customerinfo?.toJson();
    }
    return _data;
  }

  // -----------------------------Methods------------------------------------------------------------------->

  static Future<void> addCardDetails(CardDetails inventory) async {
    try {
      await cardDetailsCollection
          .doc(inventory.workitemId)
          .set(inventory.toJson());
      print('Inventory item added successfully');
    } catch (error) {
      print('Failed to add Inventory item: $error');
    }
  }

  // Get Inventory items added by the broker or employees under the broker
  static Future<List<CardDetails>> getCardDetails(String brokerId) async {
    try {
      final QuerySnapshot querySnapshot = await cardDetailsCollection.get();
      final List<CardDetails> inventoryItems = querySnapshot.docs.map((doc) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return CardDetails.fromJson(data);
      }).toList();

      return inventoryItems;
    } catch (error) {
      print('Failed to get Inventory items: $error');
      return [];
    }
  }

  static Future<void> updateCardDetails(CardDetails item) async {
    try {
      await cardDetailsCollection.doc(item.workitemId).update(item.toJson());
      print('Inventory item updated successfully');
    } catch (error) {
      print('Failed to update Inventory item: $error');
    }
  }

  // Delete a Inventory item
  static Future<void> deleteCardDetails(String id) async {
    try {
      await cardDetailsCollection.doc(id).delete();
      print('Inventory item deleted successfully');
    } catch (error) {
      print('Failed to delete Inventory item: $error');
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

  Customerinfo(
      {this.firstname,
      this.lastname,
      this.title,
      this.mobile,
      this.whatsapp,
      this.email});

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
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["firstname"] = firstname;
    _data["lastname"] = lastname;
    _data["title"] = title;
    _data["mobile"] = mobile;
    _data["whatsapp"] = whatsapp;
    _data["email"] = email;
    return _data;
  }
}

class Createdby {
  String? userid;
  String? userfirstname;
  String? userlastname;
  String? userimage;

  Createdby(
      {this.userid, this.userfirstname, this.userlastname, this.userimage});

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
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["userid"] = userid;
    _data["userfirstname"] = userfirstname;
    _data["userlastname"] = userlastname;
    _data["userimage"] = userimage;
    return _data;
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
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["unit"] = unit;
    _data["arearangestart"] = arearangestart;
    _data["arearangeend"] = arearangeend;
    return _data;
  }
}

class Propertyarearange {
  String? unit;
  String? arearangestart;
  String? arearangeend;

  Propertyarearange({this.unit, this.arearangestart, this.arearangeend});

  Propertyarearange.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["unit"] = unit;
    _data["arearangestart"] = arearangestart;
    _data["arearangeend"] = arearangeend;
    return _data;
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
      additionalroom = json["additionalroom"] == null
          ? null
          : List<String>.from(json["additionalroom"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["bedroom"] = bedroom;
    if (additionalroom != null) {
      _data["additionalroom"] = additionalroom;
    }
    return _data;
  }
}

class Assignedto {
  String? userid;
  String? firstname;
  String? lastname;
  String? image;
  String? assignedon;
  String? assignedby;

  Assignedto(
      {this.userid,
      this.firstname,
      this.lastname,
      this.image,
      this.assignedon,
      this.assignedby});

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
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["userid"] = userid;
    _data["firstname"] = firstname;
    _data["lastname"] = lastname;
    _data["image"] = image;
    _data["assignedon"] = assignedon;
    _data["assignedby"] = assignedby;
    return _data;
  }
}
