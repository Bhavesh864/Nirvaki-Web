import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

final CollectionReference activityDetailsCollection = FirebaseFirestore.instance.collection('activityDetails');

class ActivityDetails {
  String? activityId;
  String? activityStatus;
  String? itemtype;
  String? itemid;
  String? brokerid;
  String? managerid;
  String? userid;
  Createdby? createdby;
  Timestamp? createdate;
  String? userImageUrl;
  Activitybody? activitybody;

  ActivityDetails(
      {this.activityId,
      this.userImageUrl,
      this.activityStatus,
      this.itemtype,
      this.itemid,
      this.brokerid,
      this.managerid,
      this.userid,
      this.createdby,
      this.createdate,
      this.activitybody});

  factory ActivityDetails.fromSnapshot(DocumentSnapshot snapshot) {
    final json = snapshot.data() as Map<String, dynamic>;

    return ActivityDetails(
      activityId: json["activityId"],
      userImageUrl: json["userImageUrl"],
      activityStatus: json["activityStatus"],
      itemid: json["itemid"],
      itemtype: json["itemtype"],
      userid: json["userid"],
      activitybody: Activitybody.fromJson(json["activitybody"]),
      brokerid: json["brokerid"],
      managerid: json["managerid"],
      createdby: Createdby.fromJson(json["createdby"]),
      createdate: json["createdate"],
    );
  }

  ActivityDetails.fromJson(Map<String, dynamic> json) {
    if (json["ActivityID"] is String) {
      activityId = json["ActivityID"];
    }
    if (json["userImageUrl"] is String) {
      userImageUrl = json["userImageUrl"];
    }
    if (json["ActivityStatus"] is String) {
      activityStatus = json["ActivityStatus"];
    }
    if (json["itemtype"] is String) {
      itemtype = json["itemtype"];
    }
    if (json["itemid"] is String) {
      itemid = json["itemid"];
    }
    if (json["brokerid"] is String) {
      brokerid = json["brokerid"];
    }
    if (json["managerid"] is String) {
      managerid = json["managerid"];
    }
    if (json["userid"] is String) {
      userid = json["userid"];
    }
    if (json["createdby"] is Map) {
      createdby = json["createdby"] == null ? null : Createdby.fromJson(json["createdby"]);
    }
    if (json["createdate"] is Timestamp) {
      createdate = json["createdate"];
    }
    if (json["activitybody"] is Map) {
      activitybody = json["activitybody"] == null ? null : Activitybody.fromJson(json["activitybody"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["ActivityID"] = activityId;
    data["ActivityStatus"] = activityStatus;
    data["itemtype"] = itemtype;
    data["itemid"] = itemid;
    data["brokerid"] = brokerid;
    data["managerid"] = managerid;
    data["userid"] = userid;
    data["userImageUrl"] = userImageUrl;
    if (createdby != null) {
      data["createdby"] = createdby?.toJson();
    }
    data["createdate"] = createdate;
    if (activitybody != null) {
      data["activitybody"] = activitybody?.toJson();
    }
    return data;
  }

  //  -----------------------------Methods------------------------------------------------------------------->
  static Future<List<ActivityDetails>> getactivity(String id) async {
    try {
      final QuerySnapshot querySnapshot = await activityDetailsCollection.where("itemid", isEqualTo: id).get();
      final List<ActivityDetails> activitydetails = querySnapshot.docs.map((doc) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ActivityDetails.fromJson(data);
      }).toList();
      return activitydetails;
    } catch (error) {
      // print('Failed to get Inventory items: $error');
      return [];
    }
  }

  static Future<void> addactivity(ActivityDetails activityDetails) async {
    try {
      await activityDetailsCollection.doc().set(activityDetails.toJson());
      if (kDebugMode) {
        print('Inventory item added successfully');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Failed to add Inventory item: $error');
      }
    }
  }

  static Future<void> updateTodoDetails(ActivityDetails item) async {
    try {
      await activityDetailsCollection.doc(item.activityId).update(item.toJson());
      // print('Inventory item updated successfully');
    } catch (error) {
      // print('Failed to update Inventory item: $error');
    }
  }
}

class Activitybody {
  String? activitytitle;
  String? layouttype;
  String? paragraphtext;
  List<String>? chipoptions;
  Cardoptions? cardoptions;

  Activitybody({this.activitytitle, this.layouttype, this.paragraphtext, this.chipoptions, this.cardoptions});

  Activitybody.fromJson(Map<String, dynamic> json) {
    if (json["activitytitle"] is String) {
      activitytitle = json["activitytitle"];
    }
    if (json["layouttype"] is String) {
      layouttype = json["layouttype"];
    }
    if (json["paragraphtext"] is String) {
      paragraphtext = json["paragraphtext"];
    }
    if (json["chipoptions"] is List) {
      chipoptions = json["chipoptions"] == null ? null : List<String>.from(json["chipoptions"]);
    }
    if (json["cardoptions"] is Map) {
      cardoptions = json["cardoptions"] == null ? null : Cardoptions.fromJson(json["cardoptions"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["activitytitle"] = activitytitle;
    data["layouttype"] = layouttype;
    data["paragraphtext"] = paragraphtext;
    if (chipoptions != null) {
      data["chipoptions"] = chipoptions;
    }
    if (cardoptions != null) {
      data["cardoptions"] = cardoptions?.toJson();
    }
    return data;
  }
}

class Cardoptions {
  String? cardtitle;
  String? carddetail;

  Cardoptions({this.cardtitle, this.carddetail});

  Cardoptions.fromJson(Map<String, dynamic> json) {
    if (json["cardtitle"] is String) {
      cardtitle = json["cardtitle"];
    }
    if (json["carddetail"] is String) {
      carddetail = json["carddetail"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["cardtitle"] = cardtitle;
    data["carddetail"] = carddetail;
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
