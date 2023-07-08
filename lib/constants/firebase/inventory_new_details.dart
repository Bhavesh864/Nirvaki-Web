import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('inventoryDetails');

class InventoryNewDetails {
  String? notes;
  String? inventoryId;
  String? inventoryStatus;
  String? brokerid;
  List<Assignedto>? assignedto;
  String? managerid;
  Createdby? createdby;
  String? createdate;
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
  List<String>? propertylocation;
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
  String? hospitalrooms;

  InventoryNewDetails(
      {this.notes,
      this.inventoryId,
      this.inventoryStatus,
      this.brokerid,
      this.assignedto,
      this.managerid,
      this.createdby,
      this.createdate,
      this.updatedby,
      this.updatedate,
      this.attachments,
      this.customerinfo,
      this.comments,
      this.inventorycategory,
      this.inventoryType,
      this.inventorysource,
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
      this.hospitalrooms});

  InventoryNewDetails.fromJson(Map<String, dynamic> json) {
    if (json["Notes"] is String) {
      notes = json["Notes"];
    }
    if (json["InventoryId"] is String) {
      inventoryId = json["InventoryId"];
    }
    if (json["InventoryStatus"] is String) {
      inventoryStatus = json["InventoryStatus"];
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
    if (json["managerid"] is String) {
      managerid = json["managerid"];
    }
    if (json["createdby"] is Map) {
      createdby = json["createdby"] == null
          ? null
          : Createdby.fromJson(json["createdby"]);
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
    if (json["attachments"] is List) {
      attachments = json["attachments"] == null
          ? null
          : (json["attachments"] as List)
              .map((e) => Attachments.fromJson(e))
              .toList();
    }
    if (json["customerinfo"] is Map) {
      customerinfo = json["customerinfo"] == null
          ? null
          : Customerinfo.fromJson(json["customerinfo"]);
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
      roomconfig = json["roomconfig"] == null
          ? null
          : Roomconfig.fromJson(json["roomconfig"]);
    }
    if (json["plotdetails"] is Map) {
      plotdetails = json["plotdetails"] == null
          ? null
          : Plotdetails.fromJson(json["plotdetails"]);
    }
    if (json["possessiondate"] is String) {
      possessiondate = json["possessiondate"];
    }
    if (json["amenities"] is List) {
      amenities = json["amenities"] == null
          ? null
          : List<String>.from(json["amenities"]);
    }
    if (json["reservedparking"] is Map) {
      reservedparking = json["reservedparking"] == null
          ? null
          : Reservedparking.fromJson(json["reservedparking"]);
    }
    if (json["propertyarea"] is Map) {
      propertyarea = json["propertyarea"] == null
          ? null
          : Propertyarea.fromJson(json["propertyarea"]);
    }
    if (json["plotarea"] is Map) {
      plotarea =
          json["plotarea"] == null ? null : Plotarea.fromJson(json["plotarea"]);
    }
    if (json["propertyprice"] is Map) {
      propertyprice = json["propertyprice"] == null
          ? null
          : Propertyprice.fromJson(json["propertyprice"]);
    }
    if (json["propertyrent"] is Map) {
      propertyrent = json["propertyrent"] == null
          ? null
          : Propertyrent.fromJson(json["propertyrent"]);
    }
    if (json["propertyaddress"] is Map) {
      propertyaddress = json["propertyaddress"] == null
          ? null
          : Propertyaddress.fromJson(json["propertyaddress"]);
    }
    if (json["propertylocation"] is List) {
      propertylocation = json["propertylocation"] == null
          ? null
          : List<String>.from(json["propertylocation"]);
    }
    if (json["propertyfacing"] is String) {
      propertyfacing = json["propertyfacing"];
    }
    if (json["propertyphotos"] is Map) {
      propertyphotos = json["propertyphotos"] == null
          ? null
          : Propertyphotos.fromJson(json["propertyphotos"]);
    }
    if (json["commercialphotos"] is List) {
      commercialphotos = json["commercialphotos"] == null
          ? null
          : List<String>.from(json["commercialphotos"]);
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
    if (json["hospitalrooms"] is String) {
      hospitalrooms = json["hospitalrooms"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["Notes"] = notes;
    _data["InventoryId"] = inventoryId;
    _data["InventoryStatus"] = inventoryStatus;
    _data["brokerid"] = brokerid;
    if (assignedto != null) {
      _data["assignedto"] = assignedto?.map((e) => e.toJson()).toList();
    }
    _data["managerid"] = managerid;
    if (createdby != null) {
      _data["createdby"] = createdby?.toJson();
    }
    _data["createdate"] = createdate;
    _data["updatedby"] = updatedby;
    _data["updatedate"] = updatedate;
    if (attachments != null) {
      _data["attachments"] = attachments?.map((e) => e.toJson()).toList();
    }
    if (customerinfo != null) {
      _data["customerinfo"] = customerinfo?.toJson();
    }
    _data["comments"] = comments;
    _data["inventorycategory"] = inventorycategory;
    _data["inventoryType"] = inventoryType;
    _data["inventorysource"] = inventorysource;
    _data["propertycategory"] = propertycategory;
    _data["propertykind"] = propertykind;
    _data["transactiontype"] = transactiontype;
    _data["availability"] = availability;
    _data["villatype"] = villatype;
    if (roomconfig != null) {
      _data["roomconfig"] = roomconfig?.toJson();
    }
    if (plotdetails != null) {
      _data["plotdetails"] = plotdetails?.toJson();
    }
    _data["possessiondate"] = possessiondate;
    if (amenities != null) {
      _data["amenities"] = amenities;
    }
    if (reservedparking != null) {
      _data["reservedparking"] = reservedparking?.toJson();
    }
    if (propertyarea != null) {
      _data["propertyarea"] = propertyarea?.toJson();
    }
    if (plotarea != null) {
      _data["plotarea"] = plotarea?.toJson();
    }
    if (propertyprice != null) {
      _data["propertyprice"] = propertyprice?.toJson();
    }
    if (propertyrent != null) {
      _data["propertyrent"] = propertyrent?.toJson();
    }
    if (propertyaddress != null) {
      _data["propertyaddress"] = propertyaddress?.toJson();
    }
    if (propertylocation != null) {
      _data["propertylocation"] = propertylocation;
    }
    _data["propertyfacing"] = propertyfacing;
    if (propertyphotos != null) {
      _data["propertyphotos"] = propertyphotos?.toJson();
    }
    if (commercialphotos != null) {
      _data["commercialphotos"] = commercialphotos;
    }
    _data["propertyvideo"] = propertyvideo;
    _data["commericialtype"] = commericialtype;
    _data["typeofoffice"] = typeofoffice;
    _data["typeofretail"] = typeofretail;
    _data["typeofhospitality"] = typeofhospitality;
    _data["typeofhealthcare"] = typeofhealthcare;
    _data["approvedbeds"] = approvedbeds;
    _data["typeofschool"] = typeofschool;
    _data["hospitalrooms"] = hospitalrooms;
    return _data;
  }

  static Future<InventoryNewDetails?> getInventoryDetails(String id) async {
    try {
      final DocumentSnapshot documentSnapshot =
          await usersCollection.doc(id).get();
      final Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      return InventoryNewDetails.fromJson(data);
    } catch (error) {
      print('Failed to get Inventory items: $error');
      return null;
    }
  }

  static Future<void> addItem(InventoryNewDetails inventory) async {
    try {
      await usersCollection.doc(inventory.inventoryId).set(inventory.toJson());
      print('Inventory item added successfully');
    } catch (error) {
      print('Failed to add Inventory item: $error');
    }
  }
}

class Propertyphotos {
  List<String>? bedroom;
  List<String>? bathroom;
  List<String>? kitchen;
  List<String>? pujaroom;
  List<String>? servantroom;
  List<String>? studyroom;
  List<String>? officeroom;
  List<String>? frontelevation;

  Propertyphotos(
      {this.bedroom,
      this.bathroom,
      this.kitchen,
      this.pujaroom,
      this.servantroom,
      this.studyroom,
      this.officeroom,
      this.frontelevation});

  Propertyphotos.fromJson(Map<String, dynamic> json) {
    if (json["bedroom"] is List) {
      bedroom =
          json["bedroom"] == null ? null : List<String>.from(json["bedroom"]);
    }
    if (json["bathroom"] is List) {
      bathroom =
          json["bathroom"] == null ? null : List<String>.from(json["bathroom"]);
    }
    if (json["kitchen"] is List) {
      kitchen =
          json["kitchen"] == null ? null : List<String>.from(json["kitchen"]);
    }
    if (json["pujaroom"] is List) {
      pujaroom =
          json["pujaroom"] == null ? null : List<String>.from(json["pujaroom"]);
    }
    if (json["servantroom"] is List) {
      servantroom = json["servantroom"] == null
          ? null
          : List<String>.from(json["servantroom"]);
    }
    if (json["studyroom"] is List) {
      studyroom = json["studyroom"] == null
          ? null
          : List<String>.from(json["studyroom"]);
    }
    if (json["officeroom"] is List) {
      officeroom = json["officeroom"] == null
          ? null
          : List<String>.from(json["officeroom"]);
    }
    if (json["frontelevation"] is List) {
      frontelevation = json["frontelevation"] == null
          ? null
          : List<String>.from(json["frontelevation"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (bedroom != null) {
      _data["bedroom"] = bedroom;
    }
    if (bathroom != null) {
      _data["bathroom"] = bathroom;
    }
    if (kitchen != null) {
      _data["kitchen"] = kitchen;
    }
    if (pujaroom != null) {
      _data["pujaroom"] = pujaroom;
    }
    if (servantroom != null) {
      _data["servantroom"] = servantroom;
    }
    if (studyroom != null) {
      _data["studyroom"] = studyroom;
    }
    if (officeroom != null) {
      _data["officeroom"] = officeroom;
    }
    if (frontelevation != null) {
      _data["frontelevation"] = frontelevation;
    }
    return _data;
  }
}

class Propertyaddress {
  String? addressline1;
  String? addressline2;
  String? floornumber;
  String? city;
  String? state;

  Propertyaddress(
      {this.addressline1,
      this.addressline2,
      this.floornumber,
      this.city,
      this.state});

  Propertyaddress.fromJson(Map<String, dynamic> json) {
    if (json["Addressline1"] is String) {
      addressline1 = json["Addressline1"];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["Addressline1"] = addressline1;
    _data["addressline2"] = addressline2;
    _data["floornumber"] = floornumber;
    _data["city"] = city;
    _data["state"] = state;
    return _data;
  }
}

class Propertyrent {
  String? rentunit;
  String? rentamount;
  String? securityunit;
  String? securityamount;
  String? lockinperiod;

  Propertyrent(
      {this.rentunit,
      this.rentamount,
      this.securityunit,
      this.securityamount,
      this.lockinperiod});

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
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["rentunit"] = rentunit;
    _data["rentamount"] = rentamount;
    _data["securityunit"] = securityunit;
    _data["securityamount"] = securityamount;
    _data["lockinperiod"] = lockinperiod;
    return _data;
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
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["unit"] = unit;
    _data["price"] = price;
    return _data;
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
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["unit"] = unit;
    _data["area"] = area;
    return _data;
  }
}

class Propertyarea {
  String? unit;
  String? superarea;
  String? carpetarea;

  Propertyarea({this.unit, this.superarea, this.carpetarea});

  Propertyarea.fromJson(Map<String, dynamic> json) {
    if (json["unit"] is String) {
      unit = json["unit"];
    }
    if (json["superarea"] is String) {
      superarea = json["superarea"];
    }
    if (json["carpetarea"] is String) {
      carpetarea = json["carpetarea"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["unit"] = unit;
    _data["superarea"] = superarea;
    _data["carpetarea"] = carpetarea;
    return _data;
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
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["covered"] = covered;
    _data["open"] = open;
    return _data;
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
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["boundarywall"] = boundarywall;
    _data["opensides"] = opensides;
    return _data;
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
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["bedroom"] = bedroom;
    if (additionalroom != null) {
      _data["additionalroom"] = additionalroom;
    }
    _data["bathroom"] = bathroom;
    _data["balconies"] = balconies;
    return _data;
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
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["firstname"] = firstname;
    _data["lastname"] = lastname;
    _data["title"] = title;
    _data["mobile"] = mobile;
    _data["whatsapp"] = whatsapp;
    _data["email"] = email;
    _data["companyname"] = companyname;
    return _data;
  }
}

class Attachments {
  String? title;
  String? type;
  String? path;
  String? createdby;
  String? createddate;

  Attachments(
      {this.title, this.type, this.path, this.createdby, this.createddate});

  Attachments.fromJson(Map<String, dynamic> json) {
    if (json["title"] is String) {
      title = json["title"];
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
    if (json["createddate"] is String) {
      createddate = json["createddate"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["title"] = title;
    _data["type"] = type;
    _data["path"] = path;
    _data["createdby"] = createdby;
    _data["createddate"] = createddate;
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
