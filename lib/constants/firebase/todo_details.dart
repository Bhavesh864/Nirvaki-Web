import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference todoDetailsCollection =
    FirebaseFirestore.instance.collection('todoDetails');

class TodoDetails {
  String? todoType;
  String? todoId;
  String? brokerId;
  String? managerId;
  String? todoName;
  String? todoDescription;
  String? dueDate;
  String? createDate;
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
    if (json["createDate"] is String) {
      createDate = json["createDate"];
    }
    if (json["createdBy"] is String) {
      createdBy = json["createdBy"];
    }
    if (json["todoStatus"] is String) {
      todoStatus = json["todoStatus"];
    }
    if (json["customerinfo"] is Map) {
      customerinfo = json["customerinfo"] == null
          ? null
          : Customerinfo.fromJson(json["customerinfo"]);
    }
    if (json["assignedto"] is List) {
      assignedto = json["assignedto"] == null
          ? null
          : (json["assignedto"] as List)
              .map((e) => Assignedto.fromJson(e))
              .toList();
    }
    if (json["linkedWorkItem"] is List) {
      linkedWorkItem = json["linkedWorkItem"] == null
          ? null
          : (json["linkedWorkItem"] as List)
              .map((e) => LinkedWorkItem.fromJson(e))
              .toList();
    }
    if (json["attachments"] is List) {
      attachments = json["attachments"] == null
          ? null
          : (json["attachments"] as List)
              .map((e) => Attachments.fromJson(e))
              .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["todoType"] = todoType;
    _data["todoId"] = todoId;
    _data["brokerId"] = brokerId;
    _data["managerId"] = managerId;
    _data["todoName"] = todoName;
    _data["todoDescription"] = todoDescription;
    _data["dueDate"] = dueDate;
    _data["createDate"] = createDate;
    _data["createdBy"] = createdBy;
    _data["todoStatus"] = todoStatus;
    if (customerinfo != null) {
      _data["customerinfo"] = customerinfo?.toJson();
    }
    if (assignedto != null) {
      _data["assignedto"] = assignedto?.map((e) => e.toJson()).toList();
    }
    if (linkedWorkItem != null) {
      _data["linkedWorkItem"] = linkedWorkItem?.map((e) => e.toJson()).toList();
    }
    if (attachments != null) {
      _data["attachments"] = attachments?.map((e) => e.toJson()).toList();
    }
    return _data;
  }

  //  -----------------------------Methods------------------------------------------------------------------->

  static Future<TodoDetails?> getTodoDetails(String id) async {
    try {
      final DocumentSnapshot documentSnapshot =
          await todoDetailsCollection.doc(id).get();
      final Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      return TodoDetails.fromJson(data);
    } catch (error) {
      print('Failed to get Inventory items: $error');
      return null;
    }
  }

  static Future<void> addTodoDetails(TodoDetails inventory) async {
    try {
      await todoDetailsCollection.doc(inventory.todoId).set(inventory.toJson());
      print('Inventory item added successfully');
    } catch (error) {
      print('Failed to add Inventory item: $error');
    }
  }

  static Future<void> updateTodoDetails(TodoDetails item) async {
    try {
      await todoDetailsCollection.doc(item.todoId).update(item.toJson());
      print('Inventory item updated successfully');
    } catch (error) {
      print('Failed to update Inventory item: $error');
    }
  }
}

class Attachments {
  String? title;
  String? type;
  String? path;
  String? createdby;
  String? createdate;

  Attachments(
      {this.title, this.type, this.path, this.createdby, this.createdate});

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
    if (json["createdate"] is String) {
      createdate = json["createdate"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["title"] = title;
    _data["type"] = type;
    _data["path"] = path;
    _data["createdby"] = createdby;
    _data["createdate"] = createdate;
    return _data;
  }
}

class LinkedWorkItem {
  String? workItemId;
  String? workItemType;
  String? workItemTitle;
  String? workItemDescription;

  LinkedWorkItem(
      {this.workItemId,
      this.workItemType,
      this.workItemTitle,
      this.workItemDescription});

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
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["workItemId"] = workItemId;
    _data["workItemType"] = workItemType;
    _data["workItemTitle"] = workItemTitle;
    _data["workItemDescription"] = workItemDescription;
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
