import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('cardDetails');

class CardDetails {
  String? cardType;
  String? cardCategory;
  String? cardTodoType;
  String? cardTitle;
  String? cardDescription;
  String? propertyarea;
  String? plotarea;
  String? cardId;
  String? cardStatus;
  String? brokerid;
  List<Assignedto>? assignedto;
  String? createdate;
  String? updatedby;
  String? updatedate;
  Createdby? createdby;
  Customerinfo? customerinfo;
  Propertyprice? propertyprice;
  Roomconfig? roomconfig;

  CardDetails(
      {this.cardType,
      this.cardCategory,
      this.cardTodoType,
      this.cardTitle,
      this.cardDescription,
      this.propertyarea,
      this.plotarea,
      this.cardId,
      this.cardStatus,
      this.brokerid,
      this.assignedto,
      this.createdate,
      this.updatedby,
      this.updatedate,
      this.createdby,
      this.customerinfo,
      this.propertyprice,
      this.roomconfig});

  CardDetails.fromJson(Map<String, dynamic> json) {
    if (json["cardType"] is String) {
      cardType = json["cardType"];
    }
    if (json["cardCategory"] is String) {
      cardCategory = json["cardCategory"];
    }
    if (json["cardTodoType"] is String) {
      cardTodoType = json["cardTodoType"];
    }
    if (json["cardTitle"] is String) {
      cardTitle = json["cardTitle"];
    }
    if (json["cardDescription"] is String) {
      cardDescription = json["cardDescription"];
    }
    if (json["propertyarea"] is String) {
      propertyarea = json["propertyarea"];
    }
    if (json["plotarea"] is String) {
      plotarea = json["plotarea"];
    }
    if (json["cardId"] is String) {
      cardId = json["cardId"];
    }
    if (json["cardStatus"] is String) {
      cardStatus = json["cardStatus"];
    }
    if (json["brokerid"] is String) {
      brokerid = json["brokerid"];
    }
    if (json["assignedto"] is List) {
      assignedto = json["assignedto"] == null
          ? null
          : (json["assignedto"] as List)
              .map((e) => Assignedto.fromJson(e))
              .toList();
    }
    if (json["createdate"] is String) {
      createdate = json["createdate"];
    }
    if (json["updatedby"] is String) {
      updatedby = json["updatedby"];
    }
    if (json["updatedate"] is String) {
      updatedate = json["updatedate"];
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
    if (json["propertyprice"] is Map) {
      propertyprice = json["propertyprice"] == null
          ? null
          : Propertyprice.fromJson(json["propertyprice"]);
    }
    if (json["roomconfig"] is Map) {
      roomconfig = json["roomconfig"] == null
          ? null
          : Roomconfig.fromJson(json["roomconfig"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["cardType"] = cardType;
    data["cardCategory"] = cardCategory;
    data["cardTodoType"] = cardTodoType;
    data["cardTitle"] = cardTitle;
    data["cardDescription"] = cardDescription;
    data["propertyarea"] = propertyarea;
    data["plotarea"] = plotarea;
    data["cardId"] = cardId;
    data["cardStatus"] = cardStatus;
    data["brokerid"] = brokerid;
    if (assignedto != null) {
      data["assignedto"] = assignedto?.map((e) => e.toJson()).toList();
    }
    data["createdate"] = createdate;
    data["updatedby"] = updatedby;
    data["updatedate"] = updatedate;
    if (createdby != null) {
      data["createdby"] = createdby?.toJson();
    }
    if (customerinfo != null) {
      data["customerinfo"] = customerinfo?.toJson();
    }
    if (propertyprice != null) {
      data["propertyprice"] = propertyprice?.toJson();
    }
    if (roomconfig != null) {
      data["roomconfig"] = roomconfig?.toJson();
    }
    return data;
  }

  static Future<void> addItem(CardDetails inventory) async {
    try {
      await usersCollection.doc(inventory.cardId).set(inventory.toJson());
      print('Inventory item added successfully');
    } catch (error) {
      print('Failed to add Inventory item: $error');
    }
  }

  // Get Inventory items added by the broker or employees under the broker
  static Future<List<CardDetails>> getCardDetails(String brokerId) async {
    try {
      final QuerySnapshot querySnapshot = await usersCollection.get();
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

  static Future<void> updateItem(CardDetails item) async {
    try {
      await usersCollection.doc(item.cardId).update(item.toJson());
      print('Inventory item updated successfully');
    } catch (error) {
      print('Failed to update Inventory item: $error');
    }
  }

  // Delete a Inventory item
  static Future<void> deleteItem(String id) async {
    try {
      await usersCollection.doc(id).delete();
      print('Inventory item deleted successfully');
    } catch (error) {
      print('Failed to delete Inventory item: $error');
    }
  }
}

class Roomconfig {
  String? bedroom;
  List<String>? additionalroom;
  String? bathroom;
  String? balconies;

  Roomconfig(
      {this.bedroom, this.additionalroom, this.bathroom, this.balconies});

  Roomconfig.fromJson(Map<String, dynamic> json) {
    if (json["bedroom"] is String) {
      bedroom = json["bedroom"];
    }
    if (json["additionalroom"] is List) {
      additionalroom = json["additionalroom"] == null
          ? null
          : List<String>.from(json["additionalroom"]);
    }
    if (json["bathroom"] is String) {
      bathroom = json["bathroom"];
    }
    if (json["balconies"] is String) {
      balconies = json["balconies"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["bedroom"] = bedroom;
    if (additionalroom != null) {
      data["additionalroom"] = additionalroom;
    }
    data["bathroom"] = bathroom;
    data["balconies"] = balconies;
    return data;
  }
}

class Propertyprice {
  String? unit;
  String? price;

  Propertyprice({this.unit, this.price});

  Propertyprice.fromJson(Map<String, dynamic> json) {
    if (json["unit"] is String) {
      unit = json["unit"];
    }
    if (json["price"] is String) {
      price = json["price"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["unit"] = unit;
    data["price"] = price;
    return data;
  }
}

class Customerinfo {
  String? firstname;
  String? lastname;
  String? title;
  String? mobile;
  String? whatsapp;
  String? email;
  String? companyname;

  Customerinfo(
      {this.firstname,
      this.lastname,
      this.title,
      this.mobile,
      this.whatsapp,
      this.email,
      this.companyname});

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
    if (json["companyname"] is String) {
      companyname = json["companyname"];
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
    data["companyname"] = companyname;
    return data;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data["userid"] = userid;
    data["userfirstname"] = userfirstname;
    data["userlastname"] = userlastname;
    data["userimage"] = userimage;
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
