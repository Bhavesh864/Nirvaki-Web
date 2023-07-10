// import 'package:cloud_firestore/cloud_firestore.dart';

// final CollectionReference inventoryDetails =
//     FirebaseFirestore.instance.collection('inventoryQuestions');

// class InventoryQuestion {
//   String? question;
//   List<String>? options;
//   String? type;
//   int? id;
//   List<Dropdown>? dropdown;

//   InventoryQuestion(
//       {this.question, this.options, this.type, this.id, this.dropdown});

//   InventoryQuestion.fromJson(Map<String, dynamic> json) {
//     if (json["question"] is String) {
//       question = json["question"];
//     }
//     if (json["options"] is List) {
//       options = json["options"] ?? [];
//     }
//     if (json["type"] is String) {
//       type = json["type"];
//     }
//     if (json["id"] is int) {
//       id = json["id"];
//     }
//     if (json["dropdown"] is List) {
//       dropdown = json["dropdown"] == null
//           ? null
//           : (json["dropdown"] as List)
//               .map((e) => Dropdown.fromJson(e))
//               .toList();
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> _data = <String, dynamic>{};
//     _data["question"] = question;
//     if (options != null) {
//       _data["options"] = options;
//     }
//     _data["type"] = type;
//     _data["id"] = id;
//     if (dropdown != null) {
//       _data["dropdown"] = dropdown?.map((e) => e.toJson()).toList();
//     }
//     return _data;
//   }

//   static Future<void> addItem(InventoryQuestion inventory) async {
//     try {
//       await inventoryDetails.doc().set(inventory.toJson());
//       print('Inventory item added successfully');
//     } catch (error) {
//       print('Failed to add Inventory item: $error');
//     }
//   }

//   // Get Inventory items added by the broker or employees under the broker
//   static Future<List<InventoryQuestion>> getQuestion() async {
//     try {
//       final QuerySnapshot querySnapshot =
//           await inventoryDetails.orderBy("id").get();
//       final List<InventoryQuestion> inventoryItems =
//           querySnapshot.docs.map((doc) {
//         final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//         return InventoryQuestion.fromJson(data);
//       }).toList();
//       return inventoryItems;
//     } catch (error) {
//       print('Failed to get Inventory items: $error');
//       return [];
//     }
//   }
// }

// class Dropdown {
//   String? roomconfig;
//   List<String>? values;

//   Dropdown({this.roomconfig, this.values});

//   Dropdown.fromJson(Map<String, dynamic> json) {
//     if (json["roomconfig"] is String) {
//       roomconfig = json["roomconfig"];
//     }
//     if (json["values"] is List) {
//       values =
//           json["values"] == null ? null : List<String>.from(json["values"]);
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> _data = <String, dynamic>{};
//     _data["roomconfig"] = roomconfig;
//     if (values != null) {
//       _data["values"] = values;
//     }
//     return _data;
//   }
// }
