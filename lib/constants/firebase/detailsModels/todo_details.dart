import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference todoDetailsCollection = FirebaseFirestore.instance.collection('todoDetails');

class TodoDetails {
  String? todoType;
  String? todoId;
  String? brokerId;
  String? managerId;
  String? todoName;
  String? todoDescription;
  String? dueDate;
  Timestamp? createDate;
  String? createdBy;
  String? todoStatus;
  Customerinfo? customerinfo;
  List<Assignedto>? assignedto;
  List<LinkedWorkItem>? linkedWorkItem;
  List<Attachments>? attachments;

  TodoDetails(
      {this.todoType,
      this.todoId,
      this.brokerId,
      this.managerId,
      this.todoName,
      this.todoDescription,
      this.dueDate,
      this.createDate,
      this.createdBy,
      this.todoStatus,
      this.customerinfo,
      this.assignedto,
      this.linkedWorkItem,
      this.attachments});

  factory TodoDetails.fromSnapshot(DocumentSnapshot snapshot) {
    final json = snapshot.data() as Map<String, dynamic>;
    return TodoDetails(
      todoName: json["todoName"],
      todoDescription: json["todoDescription"],
      todoId: json["todoId"],
      todoStatus: json["todoStatus"],
      brokerId: json["brokerId"],
      assignedto: (json["assignedto"] as List<dynamic>?)?.map((e) => Assignedto.fromJson(e)).toList(),
      managerId: json["managerId"],
      createdBy: json["createdBy"],
      createDate: json["createdate"],
      todoType: json["todoType"],
      dueDate: json["dueDate"],
      linkedWorkItem: (json["linkedWorkItem"] as List<dynamic>?)?.map((e) => LinkedWorkItem.fromJson(e)).toList(),
      attachments: (json["attachments"] as List<dynamic>?)?.map((e) => Attachments.fromJson(e)).toList(),
      customerinfo: Customerinfo.fromJson(json["customerinfo"]),
    );
  }

  TodoDetails.fromJson(Map<String, dynamic> json) {
    if (json["todoType"] is String) {
      todoType = json["todoType"];
    }
    if (json["todoId"] is String) {
      todoId = json["todoId"];
    }
    if (json["brokerId"] is String) {
      brokerId = json["brokerId"];
    }
    if (json["managerId"] is String) {
      managerId = json["managerId"];
    }
    if (json["todoName"] is String) {
      todoName = json["todoName"];
    }
    if (json["todoDescription"] is String) {
      todoDescription = json["todoDescription"];
    }
    if (json["dueDate"] is String) {
      dueDate = json["dueDate"];
    }
    if (json["createDate"] is Timestamp) {
      createDate = json["createDate"];
    }
    if (json["createdBy"] is String) {
      createdBy = json["createdBy"];
    }
    if (json["todoStatus"] is String) {
      todoStatus = json["todoStatus"];
    }
    if (json["customerinfo"] is Map) {
      customerinfo = json["customerinfo"] == null ? null : Customerinfo.fromJson(json["customerinfo"]);
    }
    if (json["assignedto"] is List) {
      assignedto = json["assignedto"] == null ? null : (json["assignedto"] as List).map((e) => Assignedto.fromJson(e)).toList();
    }
    if (json["linkedWorkItem"] is List) {
      linkedWorkItem = json["linkedWorkItem"] == null ? null : (json["linkedWorkItem"] as List).map((e) => LinkedWorkItem.fromJson(e)).toList();
    }
    if (json["attachments"] is List) {
      attachments = json["attachments"] == null ? null : (json["attachments"] as List).map((e) => Attachments.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["todoType"] = todoType;
    data["todoId"] = todoId;
    data["brokerId"] = brokerId;
    data["managerId"] = managerId;
    data["todoName"] = todoName;
    data["todoDescription"] = todoDescription;
    data["dueDate"] = dueDate;
    data["createDate"] = createDate;
    data["createdBy"] = createdBy;
    data["todoStatus"] = todoStatus;
    if (customerinfo != null) {
      data["customerinfo"] = customerinfo?.toJson();
    }
    if (assignedto != null) {
      data["assignedto"] = assignedto?.map((e) => e.toJson()).toList();
    }
    if (linkedWorkItem != null) {
      data["linkedWorkItem"] = linkedWorkItem?.map((e) => e.toJson()).toList();
    }
    if (attachments != null) {
      data["attachments"] = attachments?.map((e) => e.toJson()).toList();
    }
    return data;
  }

  //  -----------------------------Methods------------------------------------------------------------------->

  static Future<TodoDetails?> getTodoDetails(String id) async {
    try {
      final QuerySnapshot querySnapshot = await todoDetailsCollection.where("todoId", isEqualTo: id).get();
      for (final DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        if (documentSnapshot.exists) {
          final Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
          return TodoDetails.fromJson(data);
        }
      }
      return null;
    } catch (error) {
      // print('Failed to get Inventory items: $error');
      return null;
    }
  }

  static Future<void> addTodoDetails(TodoDetails inventory) async {
    try {
      await todoDetailsCollection.doc().set(inventory.toJson());
      // print('Inventory item added successfully');
    } catch (error) {
      // print('Failed to add Inventory item: $error');
    }
  }

  static Future<void> updateTodoDetails(TodoDetails item) async {
    try {
      await todoDetailsCollection.doc(item.todoId).update(item.toJson());
      // print('Inventory item updated successfully');
    } catch (error) {
      // print('Failed to update Inventory item: $error');
    }
  }

  static Future<void> addAttachmentToItems({required String itemid, required Attachments newAttachment}) async {
    try {
      QuerySnapshot querySnapshot = await todoDetailsCollection.where("todoId", isEqualTo: itemid).get();
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
      QuerySnapshot querySnapshot = await todoDetailsCollection.where("todoId", isEqualTo: itemId).get();
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
      QuerySnapshot querySnapshot = await todoDetailsCollection.where("todoId", isEqualTo: id).get();
      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        await docSnapshot.reference.update({'todoStatus': newStatus});
      }
      print('lead status update');
    } catch (error) {
      print('Failed to update card status: $error');
    }
  }

  static Future<void> updatetodoName({required String id, required String todoName}) async {
    try {
      QuerySnapshot querySnapshot = await todoDetailsCollection.where("todoId", isEqualTo: id).get();
      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        await docSnapshot.reference.update({'todoName': todoName});
      }
      print('todoname update');
    } catch (error) {
      print('Failed to update card status: $error');
    }
  }

  static Future<void> updateCardDate({required String id, required String duedate}) async {
    try {
      QuerySnapshot querySnapshot = await todoDetailsCollection.where("todoId", isEqualTo: id).get();
      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        await docSnapshot.reference.update({'dueDate': duedate});
      }
      print('cardTitle update');
    } catch (error) {
      print('Failed to update card status: $error');
    }
  }

  static Future<void> updateTodoDescription({required String id, required String todoDescription}) async {
    try {
      QuerySnapshot querySnapshot = await todoDetailsCollection.where("todoId", isEqualTo: id).get();
      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        await docSnapshot.reference.update({'todoDescription': todoDescription});
      }
      print('description update');
    } catch (error) {
      print('Failed to update card status: $error');
    }
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

class LinkedWorkItem {
  String? workItemId;
  String? workItemType;
  String? workItemTitle;
  String? workItemDescription;

  LinkedWorkItem({this.workItemId, this.workItemType, this.workItemTitle, this.workItemDescription});

  LinkedWorkItem.fromJson(Map<String, dynamic> json) {
    if (json["workItemId"] is String) {
      workItemId = json["workItemId"];
    }
    if (json["workItemType"] is String) {
      workItemType = json["workItemType"];
    }
    if (json["workItemTitle"] is String) {
      workItemTitle = json["workItemTitle"];
    }
    if (json["workItemDescription"] is String) {
      workItemDescription = json["workItemDescription"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["workItemId"] = workItemId;
    data["workItemType"] = workItemType;
    data["workItemTitle"] = workItemTitle;
    data["workItemDescription"] = workItemDescription;
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
