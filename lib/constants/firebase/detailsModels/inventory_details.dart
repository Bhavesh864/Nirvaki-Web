// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference inventoryDetailsCollection = FirebaseFirestore.instance.collection('inventoryDetails');

class InventoryDetails {
  String? inventoryTitle;
  String? inventoryDescription;
  String? inventoryId;
  String? inventoryStatus;
  String? brokerid;
  List<Assignedto>? assignedto;
  String? managerid;
  Createdby? createdby;
  Timestamp? createdate;
  String? updatedby;
  String? updatedate;
  List<Attachments>? attachments;
  Customerinfo? customerinfo;
  String? comments;
  String? inventorycategory;
  String? inventoryType;
  String? inventorysource;
  String? propertycategory;
  String? propertykind;
  String? transactiontype;
  String? availability;
  String? villatype;
  Roomconfig? roomconfig;
  Plotdetails? plotdetails;
  String? possessiondate;
  List<String>? amenities;
  Reservedparking? reservedparking;
  Propertyarea? propertyarea;
  Plotarea? plotarea;
  Propertyprice? propertyprice;
  Propertyrent? propertyrent;
  Propertyaddress? propertyaddress;
  List<double>? propertylocation;
  String? propertyfacing;
  Propertyphotos? propertyphotos;
  List<String>? commercialphotos;
  String? propertyvideo;
  String? commericialtype;
  String? typeofoffice;
  String? typeofretail;
  String? typeofhospitality;
  String? typeofhealthcare;
  String? approvedbeds;
  String? typeofschool;
  String? hospitalityrooms;
  String? furnishedStatus;
  String? widthofRoad;
  String? widthOfRoadUnit;

  InventoryDetails(
      {required this.inventoryTitle,
      required this.inventoryDescription,
      required this.inventoryId,
      required this.inventoryStatus,
      required this.brokerid,
      this.assignedto,
      this.managerid,
      required this.createdby,
      this.createdate,
      this.updatedby,
      this.updatedate,
      this.attachments,
      this.customerinfo,
      this.comments,
      this.inventorycategory,
      this.inventoryType,
      this.inventorysource,
      this.widthOfRoadUnit,
      this.widthofRoad,
      this.propertycategory,
      this.propertykind,
      this.transactiontype,
      this.availability,
      this.villatype,
      this.roomconfig,
      this.plotdetails,
      this.possessiondate,
      this.amenities,
      this.reservedparking,
      this.propertyarea,
      this.plotarea,
      this.propertyprice,
      this.propertyrent,
      this.propertyaddress,
      this.propertylocation,
      this.propertyfacing,
      this.propertyphotos,
      this.commercialphotos,
      this.propertyvideo,
      this.commericialtype,
      this.typeofoffice,
      this.typeofretail,
      this.typeofhospitality,
      this.typeofhealthcare,
      this.approvedbeds,
      this.typeofschool,
      this.hospitalityrooms,
      this.furnishedStatus});

  factory InventoryDetails.fromSnapshot(DocumentSnapshot snapshot) {
    final json = snapshot.data() as Map<String, dynamic>;
    return InventoryDetails(
      inventoryTitle: json["inventoryTitle"],
      inventoryDescription: json["inventoryDescription"],
      widthOfRoadUnit: json["widthOfRoadUnit"],
      widthofRoad: json["widthofRoad"],
      inventoryId: json["InventoryId"],
      inventoryStatus: json["InventoryStatus"],
      brokerid: json["brokerid"],
      assignedto: (json["assignedto"] as List<dynamic>?)?.map((e) => Assignedto.fromJson(e)).toList(),
      managerid: json["managerid"],
      createdby: Createdby.fromJson(json["createdby"]),
      createdate: json["createdate"],
      updatedby: json["updatedby"],
      updatedate: json["updatedate"],
      furnishedStatus: json["furnishedStatus"],
      attachments: (json["attachments"] as List<dynamic>?)?.map((e) => Attachments.fromJson(e)).toList(),
      customerinfo: Customerinfo.fromJson(json["customerinfo"]),
      comments: json["comments"],
      inventorycategory: json["inventorycategory"],
      inventoryType: json["inventoryType"],
      inventorysource: json["inventorysource"],
      propertycategory: json["propertycategory"],
      propertykind: json["propertykind"],
      transactiontype: json["transactiontype"],
      availability: json["availability"],
      villatype: json["villatype"],
      roomconfig: json["roomconfig"] == null ? null : Roomconfig.fromJson(json["roomconfig"]),
      plotdetails: json["plotdetails"] == null ? null : Plotdetails.fromJson(json["plotdetails"]),
      possessiondate: json["possessiondate"],
      amenities: json["amenities"] == null ? null : List<String>.from(json["amenities"]),
      reservedparking: json["reservedparking"] == null ? null : Reservedparking.fromJson(json["reservedparking"]),
      propertyarea: json["propertyarea"] == null ? null : Propertyarea.fromJson(json["propertyarea"]),
      plotarea: json["plotarea"] == null ? null : Plotarea.fromJson(json["plotarea"]),
      propertyprice: json["propertyprice"] == null ? null : Propertyprice.fromJson(json["propertyprice"]),
      propertyrent: json["propertyrent"] == null ? null : Propertyrent.fromJson(json["propertyrent"]),
      propertyaddress: json["propertyaddress"] == null ? null : Propertyaddress.fromJson(json["propertyaddress"]),
      propertylocation: json["propertylocation"] == null ? null : List<double>.from(json["propertylocation"]),
      propertyfacing: json["propertyfacing"],
      propertyphotos: json["propertyphotos"] == null ? null : Propertyphotos.fromJson(json["propertyphotos"]),
      commercialphotos: json["commercialphotos"] == null ? null : List<String>.from(json["commercialphotos"]),
      propertyvideo: json["propertyvideo"],
      commericialtype: json["commericialtype"],
      typeofoffice: json["typeofoffice"],
      typeofretail: json["typeofretail"],
      typeofhospitality: json["typeofhospitality"],
      typeofhealthcare: json["typeofhealthcare"],
      approvedbeds: json["approvedbeds"],
      typeofschool: json["typeofschool"],
      hospitalityrooms: json["hospitalityrooms"],
    );
  }

  InventoryDetails.fromJson(Map<String, dynamic> json) {
    if (json["inventoryTitle"] is String) {
      inventoryTitle = json["inventoryTitle"];
    }
    if (json["widthofRoad"] is String) {
      widthofRoad = json["widthofRoad"];
    }
    if (json["widthOfRoadUnit"] is String) {
      widthOfRoadUnit = json["widthOfRoadUnit"];
    }
    if (json["inventoryDescription"] is String) {
      inventoryDescription = json["inventoryDescription"];
    }
    if (json["InventoryId"] is String) {
      inventoryId = json["InventoryId"];
    }
    if (json["furnishedStatus"] is String) {
      inventoryId = json["furnishedStatus"];
    }
    if (json["InventoryStatus"] is String) {
      inventoryStatus = json["InventoryStatus"];
    }
    if (json["brokerid"] is String) {
      brokerid = json["brokerid"];
    }
    if (json["assignedto"] is List) {
      assignedto = json["assignedto"] == null ? null : (json["assignedto"] as List).map((e) => Assignedto.fromJson(e)).toList();
    }
    if (json["managerid"] is String) {
      managerid = json["managerid"];
    }
    if (json["createdby"] is Map) {
      createdby = json["createdby"] == null ? null : Createdby.fromJson(json["createdby"]);
    }
    if (json["createdate"] is Timestamp) {
      createdate = json["createdate"];
    }
    if (json["updatedby"] is String) {
      updatedby = json["updatedby"];
    }
    if (json["updatedate"] is String) {
      updatedate = json["updatedate"];
    }
    if (json["attachments"] is List) {
      attachments = json["attachments"] == null ? null : (json["attachments"] as List).map((e) => Attachments.fromJson(e)).toList();
    }
    if (json["customerinfo"] is Map) {
      customerinfo = json["customerinfo"] == null ? null : Customerinfo.fromJson(json["customerinfo"]);
    }
    if (json["comments"] is String) {
      comments = json["comments"];
    }
    if (json["inventorycategory"] is String) {
      inventorycategory = json["inventorycategory"];
    }
    if (json["inventoryType"] is String) {
      inventoryType = json["inventoryType"];
    }
    if (json["inventorysource"] is String) {
      inventorysource = json["inventorysource"];
    }
    if (json["propertycategory"] is String) {
      propertycategory = json["propertycategory"];
    }
    if (json["propertykind"] is String) {
      propertykind = json["propertykind"];
    }
    if (json["transactiontype"] is String) {
      transactiontype = json["transactiontype"];
    }
    if (json["availability"] is String) {
      availability = json["availability"];
    }
    if (json["villatype"] is String) {
      villatype = json["villatype"];
    }
    if (json["roomconfig"] is Map) {
      roomconfig = json["roomconfig"] == null ? null : Roomconfig.fromJson(json["roomconfig"]);
    }
    if (json["plotdetails"] is Map) {
      plotdetails = json["plotdetails"] == null ? null : Plotdetails.fromJson(json["plotdetails"]);
    }
    if (json["possessiondate"] is String) {
      possessiondate = json["possessiondate"];
    }
    if (json["amenities"] is List) {
      amenities = json["amenities"] == null ? null : List<String>.from(json["amenities"]);
    }
    if (json["reservedparking"] is Map) {
      reservedparking = json["reservedparking"] == null ? null : Reservedparking.fromJson(json["reservedparking"]);
    }
    if (json["propertyarea"] is Map) {
      propertyarea = json["propertyarea"] == null ? null : Propertyarea.fromJson(json["propertyarea"]);
    }
    if (json["plotarea"] is Map) {
      plotarea = json["plotarea"] == null ? null : Plotarea.fromJson(json["plotarea"]);
    }
    if (json["propertyprice"] is Map) {
      propertyprice = json["propertyprice"] == null ? null : Propertyprice.fromJson(json["propertyprice"]);
    }
    if (json["propertyrent"] is Map) {
      propertyrent = json["propertyrent"] == null ? null : Propertyrent.fromJson(json["propertyrent"]);
    }
    if (json["propertyaddress"] is Map) {
      propertyaddress = json["propertyaddress"] == null ? null : Propertyaddress.fromJson(json["propertyaddress"]);
    }
    if (json["propertylocation"] is List) {
      propertylocation = json["propertylocation"] == null ? null : List<double>.from(json["propertylocation"]);
    }
    if (json["propertyfacing"] is String) {
      propertyfacing = json["propertyfacing"];
    }
    if (json["propertyphotos"] is Map) {
      propertyphotos = json["propertyphotos"] == null ? null : Propertyphotos.fromJson(json["propertyphotos"]);
    }
    if (json["commercialphotos"] is List) {
      commercialphotos = json["commercialphotos"] == null ? null : List<String>.from(json["commercialphotos"]);
    }
    if (json["propertyvideo"] is String) {
      propertyvideo = json["propertyvideo"];
    }
    if (json["commericialtype"] is String) {
      commericialtype = json["commericialtype"];
    }
    if (json["typeofoffice"] is String) {
      typeofoffice = json["typeofoffice"];
    }
    if (json["typeofretail"] is String) {
      typeofretail = json["typeofretail"];
    }
    if (json["typeofhospitality"] is String) {
      typeofhospitality = json["typeofhospitality"];
    }
    if (json["typeofhealthcare"] is String) {
      typeofhealthcare = json["typeofhealthcare"];
    }
    if (json["approvedbeds"] is String) {
      approvedbeds = json["approvedbeds"];
    }
    if (json["typeofschool"] is String) {
      typeofschool = json["typeofschool"];
    }
    if (json["hospitalityrooms"] is String) {
      hospitalityrooms = json["hospitalityrooms"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["inventoryTitle"] = inventoryTitle;
    data["inventoryDescription"] = inventoryDescription;
    data["InventoryId"] = inventoryId;
    data["widthOfRoadUnit"] = widthOfRoadUnit;
    data["widthofRoad"] = widthofRoad;
    data["InventoryStatus"] = inventoryStatus;
    data["furnishedStatus"] = furnishedStatus;
    data["brokerid"] = brokerid;
    if (assignedto != null) {
      data["assignedto"] = assignedto?.map((e) => e.toJson()).toList();
    }
    data["managerid"] = managerid;
    if (createdby != null) {
      data["createdby"] = createdby?.toJson();
    }
    data["createdate"] = createdate;
    data["updatedby"] = updatedby;
    data["updatedate"] = updatedate;
    if (attachments != null) {
      data["attachments"] = attachments?.map((e) => e.toJson()).toList();
    }
    if (customerinfo != null) {
      data["customerinfo"] = customerinfo?.toJson();
    }
    data["comments"] = comments;
    data["inventorycategory"] = inventorycategory;
    data["inventoryType"] = inventoryType;
    data["inventorysource"] = inventorysource;
    data["propertycategory"] = propertycategory;
    data["propertykind"] = propertykind;
    data["transactiontype"] = transactiontype;
    data["availability"] = availability;
    data["villatype"] = villatype;
    if (roomconfig != null) {
      data["roomconfig"] = roomconfig?.toJson();
    }
    if (plotdetails != null) {
      data["plotdetails"] = plotdetails?.toJson();
    }
    data["possessiondate"] = possessiondate;
    if (amenities != null) {
      data["amenities"] = amenities;
    }
    if (reservedparking != null) {
      data["reservedparking"] = reservedparking?.toJson();
    }
    if (propertyarea != null) {
      data["propertyarea"] = propertyarea?.toJson();
    }
    if (plotarea != null) {
      data["plotarea"] = plotarea?.toJson();
    }
    if (propertyprice != null) {
      data["propertyprice"] = propertyprice?.toJson();
    }
    if (propertyrent != null) {
      data["propertyrent"] = propertyrent?.toJson();
    }
    if (propertyaddress != null) {
      data["propertyaddress"] = propertyaddress?.toJson();
    }
    if (propertylocation != null) {
      data["propertylocation"] = propertylocation;
    }
    data["propertyfacing"] = propertyfacing;
    if (propertyphotos != null) {
      data["propertyphotos"] = propertyphotos?.toJson();
    }
    if (commercialphotos != null) {
      data["commercialphotos"] = commercialphotos;
    }
    data["propertyvideo"] = propertyvideo;
    data["commericialtype"] = commericialtype;
    data["typeofoffice"] = typeofoffice;
    data["typeofretail"] = typeofretail;
    data["typeofhospitality"] = typeofhospitality;
    data["typeofhealthcare"] = typeofhealthcare;
    data["approvedbeds"] = approvedbeds;
    data["typeofschool"] = typeofschool;
    data["hospitalityrooms"] = hospitalityrooms;
    return data;
  }

//  -----------------------------Methods------------------------------------------------------------------->

  // static Future<InventoryDetails?> getInventoryDetails(String id) async {
  //   try {
  //     final DocumentSnapshot documentSnapshot = await inventoryDetailsCollection.doc(id).get();
  //     final Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
  //     return InventoryDetails.fromJson(data);
  //   } catch (error) {
  //     // print('Failed to get Inventory items: $error');
  //     return null;
  //   }
  // }

  static Future<InventoryDetails?> getInventoryDetails(itemid) async {
    try {
      final QuerySnapshot querySnapshot = await inventoryDetailsCollection.where("InventoryId", isEqualTo: itemid).get();
      for (final DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        if (documentSnapshot.exists) {
          final Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
          return InventoryDetails.fromJson(data);
        }
      }
      return null;
    } catch (error) {
      print('Failed to get users: $error');
      return null;
    }
  }

  static Future<void> addInventoryDetails(InventoryDetails inventory) async {
    try {
      await inventoryDetailsCollection.doc().set(inventory.toJson());
      // print('Inventory item added successfully');
    } catch (error) {
      // print('Failed to add Inventory item: $error');
    }
  }

  static Future<void> updateInventoryDetails({required String id, required InventoryDetails inventoryDetails}) async {
    try {
      QuerySnapshot querySnapshot = await inventoryDetailsCollection.where("InventoryId", isEqualTo: id).get();
      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        await docSnapshot.reference.update(inventoryDetails.toJson());
      }
      print('Inventory item updated successfully');
    } catch (error) {
      print('Failed to update Inventory item: $error');
    }
  }

  static Future<void> updatecardStatus({required String id, required String newStatus}) async {
    try {
      QuerySnapshot querySnapshot = await inventoryDetailsCollection.where("InventoryId", isEqualTo: id).get();
      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        await docSnapshot.reference.update({'InventoryStatus': newStatus});
      }
      print('inventory status update');
    } catch (error) {
      print('Failed to update card status: $error');
    }
  }

  static Future<void> addAttachmentToItems({required String itemid, required Attachments newAttachment}) async {
    try {
      QuerySnapshot querySnapshot = await inventoryDetailsCollection.where("InventoryId", isEqualTo: itemid).get();
      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

        List<dynamic> existingAttachments = data['attachments'] ?? [];
        existingAttachments.add(newAttachment.toJson());

        await docSnapshot.reference.update({'attachments': existingAttachments});

        print('Attachment added successfully to item ${docSnapshot.id}');
      }
    } catch (error) {
      print('Failed to add attachment to items: $error');
    }
  }

  static Future<void> deleteAttachment({required String itemId, required String attachmentIdToDelete}) async {
    try {
      QuerySnapshot querySnapshot = await inventoryDetailsCollection.where("InventoryId", isEqualTo: itemId).get();

      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot docSnapshot = querySnapshot.docs.first;
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        List<dynamic> existingAttachments = data['attachments'] ?? [];
        List<dynamic> updatedAttachments = [];
        for (var attachment in existingAttachments) {
          if (attachment['id'] != attachmentIdToDelete) {
            updatedAttachments.add(attachment);
          }
        }
        await docSnapshot.reference.update({'attachments': updatedAttachments});
        print('Attachment deleted successfully from item $itemId');
      } else {
        print('Item not found with InventoryId: $itemId');
      }
    } catch (error) {
      print('Failed to delete attachment: $error');
    }
  }

  static Future<void> updateAssignUser({required String itemid, required List<Assignedto> assignedtoList}) async {
    try {
      QuerySnapshot querySnapshot = await inventoryDetailsCollection.where("InventoryId", isEqualTo: itemid).get();
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

  static Future<void> deleteInventoryAssignUser({required String itemId, required String userid}) async {
    try {
      QuerySnapshot querySnapshot = await inventoryDetailsCollection.where("InventoryId", isEqualTo: itemId).get();
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

// class Propertyphotos {
//   List<String>? bedroom;
//   List<String>? bathroom;
//   List<String>? kitchen;
//   List<String>? pujaroom;
//   List<String>? servantroom;
//   List<String>? studyroom;
//   List<String>? officeroom;
//   List<String>? frontelevation;

//   Propertyphotos({this.bedroom, this.bathroom, this.kitchen, this.pujaroom, this.servantroom, this.studyroom, this.officeroom, this.frontelevation});

//   Propertyphotos.fromJson(Map<String, dynamic> json) {
//     if (json["bedroom"] is List) {
//       bedroom = json["bedroom"] == null ? null : List<String>.from(json["bedroom"]);
//     }
//     if (json["bathroom"] is List) {
//       bathroom = json["bathroom"] == null ? null : List<String>.from(json["bathroom"]);
//     }
//     if (json["kitchen"] is List) {
//       kitchen = json["kitchen"] == null ? null : List<String>.from(json["kitchen"]);
//     }
//     if (json["pujaroom"] is List) {
//       pujaroom = json["pujaroom"] == null ? null : List<String>.from(json["pujaroom"]);
//     }
//     if (json["servantroom"] is List) {
//       servantroom = json["servantroom"] == null ? null : List<String>.from(json["servantroom"]);
//     }
//     if (json["studyroom"] is List) {
//       studyroom = json["studyroom"] == null ? null : List<String>.from(json["studyroom"]);
//     }
//     if (json["officeroom"] is List) {
//       officeroom = json["officeroom"] == null ? null : List<String>.from(json["officeroom"]);
//     }
//     if (json["frontelevation"] is List) {
//       frontelevation = json["frontelevation"] == null ? null : List<String>.from(json["frontelevation"]);
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (bedroom != null) {
//       data["bedroom"] = bedroom;
//     }
//     if (bathroom != null) {
//       data["bathroom"] = bathroom;
//     }
//     if (kitchen != null) {
//       data["kitchen"] = kitchen;
//     }
//     if (pujaroom != null) {
//       data["pujaroom"] = pujaroom;
//     }
//     if (servantroom != null) {
//       data["servantroom"] = servantroom;
//     }
//     if (studyroom != null) {
//       data["studyroom"] = studyroom;
//     }
//     if (officeroom != null) {
//       data["officeroom"] = officeroom;
//     }
//     if (frontelevation != null) {
//       data["frontelevation"] = frontelevation;
//     }
//     return data;
//   }
// }
class Propertyphotos {
  List<String>? imageUrl;
  List<String>? imageTitle;

  Propertyphotos({this.imageUrl, this.imageTitle});

  Propertyphotos.fromJson(Map<String, dynamic> json) {
    if (json["imageUrl"] is List) {
      imageUrl = json["imageUrl"] == null ? null : List<String>.from(json["imageUrl"]);
    }
    if (json["imageTitle"] is List) {
      imageTitle = json["imageTitle"] == null ? null : List<String>.from(json["imageTitle"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (imageUrl != null) {
      data["imageUrl"] = imageUrl;
    }
    if (imageTitle != null) {
      data["imageTitle"] = imageTitle;
    }
    return data;
  }
}

class Propertyaddress {
  String? addressline1;
  String? addressline2;
  String? floornumber;
  String? city;
  String? state;
  String? locality;
  String? fullAddress;

  Propertyaddress({this.addressline1, this.addressline2, this.floornumber, this.city, this.state, this.locality, this.fullAddress});

  Propertyaddress.fromJson(Map<String, dynamic> json) {
    if (json["Addressline1"] is String) {
      addressline1 = json["Addressline1"];
    }
    if (json["fullAddress"] is String) {
      fullAddress = json["fullAddress"];
    }
    if (json["addressline2"] is String) {
      addressline2 = json["addressline2"];
    }
    if (json["floornumber"] is String) {
      floornumber = json["floornumber"];
    }
    if (json["city"] is String) {
      city = json["city"];
    }
    if (json["state"] is String) {
      state = json["state"];
    }
    if (json["locality"] is String) {
      locality = json["locality"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["Addressline1"] = addressline1;
    data["addressline2"] = addressline2;
    data["floornumber"] = floornumber;
    data["city"] = city;
    data["state"] = state;
    data["locality"] = locality;
    data["fullAddress"] = fullAddress;
    return data;
  }
}

class Propertyrent {
  String? rentunit;
  String? rentamount;
  String? securityunit;
  String? securityamount;
  String? lockinperiod;

  Propertyrent({this.rentunit, this.rentamount, this.securityunit, this.securityamount, this.lockinperiod});

  Propertyrent.fromJson(Map<String, dynamic> json) {
    if (json["rentunit"] is String) {
      rentunit = json["rentunit"];
    }
    if (json["rentamount"] is String) {
      rentamount = json["rentamount"];
    }
    if (json["securityunit"] is String) {
      securityunit = json["securityunit"];
    }
    if (json["securityamount"] is String) {
      securityamount = json["securityamount"];
    }
    if (json["lockinperiod"] is String) {
      lockinperiod = json["lockinperiod"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["rentunit"] = rentunit;
    data["rentamount"] = rentamount;
    data["securityunit"] = securityunit;
    data["securityamount"] = securityamount;
    data["lockinperiod"] = lockinperiod;
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

class Plotarea {
  String? unit;
  String? area;

  Plotarea({this.unit, this.area});

  Plotarea.fromJson(Map<String, dynamic> json) {
    if (json["unit"] is String) {
      unit = json["unit"];
    }
    if (json["area"] is String) {
      area = json["area"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["unit"] = unit;
    data["area"] = area;
    return data;
  }
}

class Propertyarea {
  String? unit;
  dynamic superarea;
  dynamic carpetarea;

  Propertyarea({this.unit, this.superarea, this.carpetarea});

  Propertyarea.fromJson(Map<String, dynamic> json) {
    if (json["unit"] is String) {
      unit = json["unit"];
    }
    superarea = json["superarea"];
    carpetarea = json["carpetarea"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["unit"] = unit;
    data["superarea"] = superarea;
    data["carpetarea"] = carpetarea;
    return data;
  }
}

class Reservedparking {
  String? covered;
  String? open;

  Reservedparking({this.covered, this.open});

  Reservedparking.fromJson(Map<String, dynamic> json) {
    if (json["covered"] is String) {
      covered = json["covered"];
    }
    if (json["open"] is String) {
      open = json["open"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["covered"] = covered;
    data["open"] = open;
    return data;
  }
}

class Plotdetails {
  String? boundarywall;
  String? opensides;

  Plotdetails({this.boundarywall, this.opensides});

  Plotdetails.fromJson(Map<String, dynamic> json) {
    if (json["boundarywall"] is String) {
      boundarywall = json["boundarywall"];
    }
    if (json["opensides"] is String) {
      opensides = json["opensides"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["boundarywall"] = boundarywall;
    data["opensides"] = opensides;
    return data;
  }
}

class Roomconfig {
  String? bedroom;
  List<String>? additionalroom;
  String? bathroom;
  String? balconies;

  Roomconfig({this.bedroom, this.additionalroom, this.bathroom, this.balconies});

  Roomconfig.fromJson(Map<String, dynamic> json) {
    if (json["bedroom"] is String) {
      bedroom = json["bedroom"];
    }
    if (json["additionalroom"] is List) {
      additionalroom = json["additionalroom"] == null ? null : List<String>.from(json["additionalroom"]);
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

class Customerinfo {
  String? firstname;
  String? lastname;
  String? title;
  String? mobile;
  String? whatsapp;
  String? email;
  String? companyname;

  Customerinfo({this.firstname, this.lastname, this.title, this.mobile, this.whatsapp, this.email, this.companyname});

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

class Attachments {
  String? id;
  String? title;
  String? type;
  String? path;
  String? createdby;
  Timestamp? createddate;

  Attachments({
    this.id,
    this.title,
    this.type,
    this.path,
    this.createdby,
    this.createddate,
  });

  Attachments.fromJson(Map<String, dynamic> json) {
    if (json["title"] is String) {
      title = json["title"];
    }
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["type"] is String) {
      type = json["type"];
    }
    if (json["path"] is String) {
      path = json["path"];
    }
    if (json["createdby"] is String) {
      createdby = json["createdby"];
    }
    if (json["createddate"] is Timestamp) {
      createddate = json["createddate"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["title"] = title;
    data["type"] = type;
    data["path"] = path;
    data["createdby"] = createdby;
    data["createddate"] = createddate;
    data["id"] = id;
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
