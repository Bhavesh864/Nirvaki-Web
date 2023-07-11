import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference inventoryDetails =
    FirebaseFirestore.instance.collection('inventoryQuestions');

class InventoryQuestions {
  final String question;
  final String type;
  final int id;
  final List<String> options;
  final List<dynamic> dropdownList;
  InventoryQuestions({
    required this.question,
    required this.dropdownList,
    required this.type,
    required this.id,
    required this.options,
    // this.dropdownList,
  });

  // Convert Inventory_questions object to a map
  Map<String, dynamic> toMap() {
    return {
      "question": question,
      "type": type,
      "options": options,
      'id': id,
      "dropdownList": dropdownList
    };
  }

  // Create Inventory_questions object from a map
  factory InventoryQuestions.fromMap(Map<String, dynamic> map) {
    return InventoryQuestions(
      question: map['question'],
      type: map['type'],
      id: map['id'],
      dropdownList: map['dropdownList'],
      options: List<String>.from(map['options']),
    );
  }

  static Future<void> addItem(InventoryQuestions inventory) async {
    try {
      await inventoryDetails.doc().set(inventory.toMap());
      print('Inventory item added successfully');
    } catch (error) {
      print('Failed to add Inventory item: $error');
    }
  }

  // Get Inventory items added by the broker or employees under the broker
  static Future<List<InventoryQuestions>> getQuestions() async {
    try {
      final QuerySnapshot querySnapshot =
          await inventoryDetails.orderBy("id").get();
      final List<InventoryQuestions> inventoryQuestionss =
          querySnapshot.docs.map((doc) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return InventoryQuestions.fromMap(data);
      }).toList();
      return inventoryQuestionss;
    } catch (error) {
      print('Failed to get Inventory items: $error');
      return [];
    }
  }
}

// use this type
// void initState() {
//   super.initState();
//   fetchInventory_questionss();
// }

// Future<void> fetchInventory_questionss() async {
//   // Fetch Inventory items from Firestore
//   final List<Inventory_questions> items = await Inventory_questions.getInventory_questionss();

//   setState(() {
//     Inventory_questionss = items;
//   });
// }

// Usage example:

// void mains() async {
//   // Add a Inventory item by a broker
//   final Inventory_questions newItemByBroker = Inventory_questions(
//     id: '1',
//     title: 'New Item by Broker',
//     description: 'This item is added by the broker',
//     imageUrl: 'https://example.com/image.jpg',
//     brokerId: 'broker1', // ID of the broker who added the item
//   );

//   await newItemByBroker.addItem();

//   // Add a Inventory item by an employee
//   final Inventory_questions newItemByEmployee = Inventory_questions(
//     id: '2',
//     title: 'New Item by Employee',
//     description: 'This item is added by an employee',
//     imageUrl: 'https://example.com/image.jpg',
//     brokerId: 'employee1', // ID of the employee who added the item
//   );

//   await newItemByEmployee.addItem();

// Get Inventory items for a specific broker
//   final List<Inventory_questions> Inventory_questionss =
//       await Inventory_questions.getInventory_questionssForBroker('broker1');
//   Inventory_questionss.forEach((item) {
//     print('Title: ${item.title}');
//     print('Description: ${item.description}');
//   });
// }

class Dropdown {
  String? roomconfig;
  List<String>? values;

  Dropdown({this.roomconfig, this.values});

  Dropdown.fromJson(Map<String, dynamic> json) {
    if (json["roomconfig"] is String) {
      roomconfig = json["roomconfig"];
    }
    if (json["values"] is List) {
      values =
          json["values"] == null ? null : List<String>.from(json["values"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["roomconfig"] = roomconfig;
    if (values != null) {
      data["values"] = values;
    }
    return data;
  }
}
