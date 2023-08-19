import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference usersCollection = FirebaseFirestore.instance.collection('leadDetails');

class LeadDetails {
  String? leadStatus;
  String? leadTitle;
  String? leadDescription;
  String? brokerid;
  String? leadId;
  List<Assignedto>? assignedto;
  String? managerid;
  Createdby? createdby;
  Timestamp? createdate;
  Propertyarea? propertyarea;
  String? updatedby;
  String? updatedate;
  List<double>? propertylocation;
  Customerinfo? customerinfo;
  List<Attachments>? attachments;
  String? comments;
  String? leadcategory;
  String? leadType;
  String? leadsource;
  String? propertycategory;
  String? propertykind;
  String? transactiontype;
  String? availability;
  String? villatype;
  Roomconfig? roomconfig;
  String? possessiondate;
  List<String>? amenities;
  Reservedparking? reservedparking;
  Propertyarearange? propertyarearange;
  Propertypricerange? propertypricerange;
  Preferredlocality? preferredlocality;
  List<double>? preferredlocation;
  String? preferredpropertyfacing;
  String? commericialtype;
  String? typeofoffice;
  String? typeofretail;
  Plotdetails? plotdetails;
  String? typeofhospitality;
  String? typeofhealthcare;
  String? approvedbeds;
  String? typeofschool;
  String? hospitalrooms;
  String? preferredroadwidth;

  LeadDetails(
      {this.leadStatus,
      this.brokerid,
      this.plotdetails,
      this.leadTitle,
      this.leadDescription,
      this.leadId,
      this.assignedto,
      this.managerid,
      this.createdby,
      this.createdate,
      this.propertylocation,
      this.updatedby,
      this.updatedate,
      this.customerinfo,
      this.comments,
      this.leadcategory,
      this.leadType,
      this.leadsource,
      this.propertycategory,
      this.propertykind,
      this.transactiontype,
      this.attachments,
      this.availability,
      this.villatype,
      this.roomconfig,
      this.possessiondate,
      this.amenities,
      this.reservedparking,
      this.propertyarearange,
      this.propertypricerange,
      this.preferredlocality,
      this.preferredlocation,
      this.preferredpropertyfacing,
      this.commericialtype,
      this.typeofoffice,
      this.typeofretail,
      this.typeofhospitality,
      this.typeofhealthcare,
      this.approvedbeds,
      this.propertyarea,
      this.typeofschool,
      this.hospitalrooms,
      this.preferredroadwidth});

  LeadDetails.fromJson(Map<String, dynamic> json) {
    if (json["leadStatus"] is String) {
      leadStatus = json["leadStatus"];
    }
    if (json["brokerid"] is String) {
      brokerid = json["brokerid"];
    }
    if (json["leadId"] is String) {
      leadId = json["leadId"];
    }
    if (json["leadTitle"] is String) {
      leadTitle = json["leadTitle"];
    }
    if (json["propertyarea"] is Map) {
      propertyarea = json["propertyarea"] == null ? null : Propertyarea.fromJson(json["propertyarea"]);
    }
    if (json["leadDescription"] is String) {
      leadDescription = json["leadDescription"];
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
    if (json["attachments"] is List) {
      attachments = json["attachments"] == null ? null : (json["attachments"] as List).map((e) => Attachments.fromJson(e)).toList();
    }
    if (json["updatedby"] is String) {
      updatedby = json["updatedby"];
    }
    if (json["updatedate"] is String) {
      updatedate = json["updatedate"];
    }
    if (json["propertylocation"] is List) {
      propertylocation = json["propertylocation"] == null ? null : List<double>.from(json["propertylocation"]);
    }
    if (json["customerinfo"] is Map) {
      customerinfo = json["customerinfo"] == null ? null : Customerinfo.fromJson(json["customerinfo"]);
    }
    if (json["comments"] is String) {
      comments = json["comments"];
    }
    if (json["leadcategory"] is String) {
      leadcategory = json["leadcategory"];
    }
    if (json["leadType"] is String) {
      leadType = json["leadType"];
    }
    if (json["plotdetails"] is Map) {
      plotdetails = json["plotdetails"] == null ? null : Plotdetails.fromJson(json["plotdetails"]);
    }
    if (json["leadsource"] is String) {
      leadsource = json["leadsource"];
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
    if (json["possessiondate"] is String) {
      possessiondate = json["possessiondate"];
    }
    if (json["amenities"] is List) {
      amenities = json["amenities"] == null ? null : List<String>.from(json["amenities"]);
    }
    if (json["reservedparking"] is Map) {
      reservedparking = json["reservedparking"] == null ? null : Reservedparking.fromJson(json["reservedparking"]);
    }
    if (json["propertyarearange"] is Map) {
      propertyarearange = json["propertyarearange"] == null ? null : Propertyarearange.fromJson(json["propertyarearange"]);
    }
    if (json["propertypricerange"] is Map) {
      propertypricerange = json["propertypricerange"] == null ? null : Propertypricerange.fromJson(json["propertypricerange"]);
    }
    if (json["preferredlocality"] is Map) {
      preferredlocality = json["preferredlocality"] == null ? null : Preferredlocality.fromJson(json["preferredlocality"]);
    }
    if (json["preferredlocation"] is double) {
      preferredlocation = json["preferredlocation"] == null ? null : List<double>.from(json["preferredlocation"]);
    }
    if (json["preferredpropertyfacing"] is String) {
      preferredpropertyfacing = json["preferredpropertyfacing"];
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
    if (json["hospitalrooms"] is String) {
      hospitalrooms = json["hospitalrooms"];
    }
    if (json["preferredroadwidth"] is String) {
      preferredroadwidth = json["preferredroadwidth"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["leadStatus"] = leadStatus;
    data["brokerid"] = brokerid;
    data["leadId"] = leadId;
    data["leadDescription"] = leadDescription;
    data["leadTitle"] = leadTitle;
    if (propertyarea != null) {
      data["propertyarea"] = propertyarea?.toJson();
    }
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
    if (customerinfo != null) {
      data["customerinfo"] = customerinfo?.toJson();
    }
    if (attachments != null) {
      data["attachments"] = attachments?.map((e) => e.toJson()).toList();
    }
    data["comments"] = comments;
    data["leadcategory"] = leadcategory;
    data["leadType"] = leadType;
    data["leadsource"] = leadsource;
    data["propertycategory"] = propertycategory;
    data["propertykind"] = propertykind;
    data["transactiontype"] = transactiontype;
    data["availability"] = availability;
    data["villatype"] = villatype;
    if (roomconfig != null) {
      data["roomconfig"] = roomconfig?.toJson();
    }
    data["possessiondate"] = possessiondate;
    if (amenities != null) {
      data["amenities"] = amenities;
    }
    if (plotdetails != null) {
      data["plotdetails"] = plotdetails?.toJson();
    }
    if (reservedparking != null) {
      data["reservedparking"] = reservedparking?.toJson();
    }
    if (propertyarearange != null) {
      data["propertyarearange"] = propertyarearange?.toJson();
    }
    if (propertypricerange != null) {
      data["propertypricerange"] = propertypricerange?.toJson();
    }
    if (preferredlocality != null) {
      data["preferredlocality"] = preferredlocality?.toJson();
    }
    if (preferredlocation != null) {
      data["preferredlocation"] = preferredlocation;
    }
    data["preferredpropertyfacing"] = preferredpropertyfacing;
    data["commericialtype"] = commericialtype;
    data["typeofoffice"] = typeofoffice;
    data["typeofretail"] = typeofretail;
    data["typeofhospitality"] = typeofhospitality;
    data["typeofhealthcare"] = typeofhealthcare;
    data["approvedbeds"] = approvedbeds;
    data["typeofschool"] = typeofschool;
    data["hospitalrooms"] = hospitalrooms;
    data["preferredroadwidth"] = preferredroadwidth;
    return data;
  }

//  -----------------------------Methods------------------------------------------------------------------->

  static Future<LeadDetails?> getLeadDetails(itemid) async {
    try {
      final QuerySnapshot querySnapshot = await usersCollection.where("leadId", isEqualTo: itemid).get();
      for (final DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        if (documentSnapshot.exists) {
          final Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
          return LeadDetails.fromJson(data);
        }
      }
      return null;
    } catch (error) {
      print('Failed to get users: $error');
      return null;
    }
  }

  static Future<LeadDetails?> getLeadQuestion(itemid) async {
    try {
      final QuerySnapshot querySnapshot = await usersCollection.where("InventoryId", isEqualTo: itemid).get();
      for (final DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        if (documentSnapshot.exists) {
          final Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
          return LeadDetails.fromJson(data);
        }
      }
      return null;
    } catch (error) {
      print('Failed to get users: $error');
      return null;
    }
  }

  static Future<void> addLeadDetails(LeadDetails inventory) async {
    try {
      await usersCollection.doc().set(inventory.toJson());
      // print('Inventory item added successfully');
    } catch (error) {
      // print('Failed to add Inventory item: $error');
    }
  }

  static Future<void> addAttachmentToItems({required String itemid, required Attachments newAttachment}) async {
    try {
      QuerySnapshot querySnapshot = await usersCollection.where("leadId", isEqualTo: itemid).get();
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
      QuerySnapshot querySnapshot = await usersCollection.where("leadId", isEqualTo: itemId).get();
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

  static Future<void> updatecardStatus({required String id, required String newStatus}) async {
    try {
      QuerySnapshot querySnapshot = await usersCollection.where("leadId", isEqualTo: id).get();
      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        await docSnapshot.reference.update({'leadStatus': newStatus});
      }
      print('lead status update');
    } catch (error) {
      print('Failed to update card status: $error');
    }
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

class Preferredlocality {
  String? addressline1;
  String? addressline2;
  String? prefferedfloornumber;
  String? city;
  String? state;

  Preferredlocality({this.addressline1, this.addressline2, this.prefferedfloornumber, this.city, this.state});
  Preferredlocality.fromJson(Map<String, dynamic> json) {
    if (json["Addressline1"] is String) {
      addressline1 = json["Addressline1"];
    }
    if (json["addressline2"] is String) {
      addressline2 = json["addressline2"];
    }
    if (json["prefferedfloornumber"] is String) {
      prefferedfloornumber = json["prefferedfloornumber"];
    }
    if (json["city"] is String) {
      city = json["city"];
    }
    if (json["state"] is String) {
      state = json["state"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["Addressline1"] = addressline1;
    data["addressline2"] = addressline2;
    data["prefferedfloornumber"] = prefferedfloornumber;
    data["city"] = city;
    data["state"] = state;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data["unit"] = unit;
    data["arearangestart"] = arearangestart;
    data["arearangeend"] = arearangeend;
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

class Attachments {
  String? id;
  String? title;
  String? type;
  String? path;
  String? createdby;
  Timestamp? createddate;

  Attachments({this.title, this.type, this.path, this.createdby, this.createddate, this.id});

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
