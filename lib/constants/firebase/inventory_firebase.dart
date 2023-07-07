import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('inventory');

class InventoryItem {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> userId;
  final String specs;
  final String size;
  final String price;
  final String type;
  final String status;
  final String customerName;
  final int customerPhone;
  final int customerWhatsApp;
  final String brokerId;

  InventoryItem({
    required this.userId,
    required this.specs,
    required this.size,
    required this.price,
    required this.type,
    required this.customerPhone,
    required this.status,
    required this.customerName,
    required this.customerWhatsApp,
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.brokerId,
  });

  // Convert InventoryItem object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'brokerId': brokerId,
      "userId": userId,
      "specs": specs,
      "size": size,
      "price": price,
      "type": type,
      "customerPhone": customerPhone,
      "status": status,
      "customerName": customerName,
      "customerWhatsApp": customerWhatsApp
    };
  }

  // Create InventoryItem object from a map
  factory InventoryItem.fromMap(Map<String, dynamic> map) {
    return InventoryItem(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        imageUrl: map['imageUrl'],
        brokerId: map['brokerId'],
        userId: List<String>.from(map['userId']),
        customerName: map['customerName'],
        customerPhone: map['customerPhone'],
        customerWhatsApp: map['customerWhatsApp'],
        price: map['price'],
        size: map['size'],
        specs: map['specs'],
        status: map['status'],
        type: map['type']);
  }

  // Create a new Inventory item
  static Future<void> addItem(InventoryItem inventory) async {
    try {
      await usersCollection.doc(inventory.id).set(inventory.toMap());
      print('Inventory item added successfully');
    } catch (error) {
      print('Failed to add Inventory item: $error');
    }
  }

  // Get Inventory items added by the broker or employees under the broker
  static Future<List<InventoryItem>> getInventoryItemsForBroker(
      String brokerId) async {
    try {
      final QuerySnapshot querySnapshot =
          await usersCollection.where('brokerId', isEqualTo: brokerId).get();

      final List<InventoryItem> inventoryItems = querySnapshot.docs.map((doc) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return InventoryItem.fromMap(data);
      }).toList();

      return inventoryItems;
    } catch (error) {
      print('Failed to get Inventory items: $error');
      return [];
    }
  }

  static Future<void> updateItem(InventoryItem item) async {
    try {
      await usersCollection.doc(item.id).update(item.toMap());
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


// use this type
  // void initState() {
  //   super.initState();
  //   fetchInventoryItems();
  // }

  // Future<void> fetchInventoryItems() async {
  //   // Fetch Inventory items from Firestore
  //   final List<InventoryItem> items = await InventoryItem.getInventoryItems();

  //   setState(() {
  //     InventoryItems = items;
  //   });
  // }

// Usage example:

// void mains() async {
//   // Add a Inventory item by a broker
//   final InventoryItem newItemByBroker = InventoryItem(
//     id: '1',
//     title: 'New Item by Broker',
//     description: 'This item is added by the broker',
//     imageUrl: 'https://example.com/image.jpg',
//     brokerId: 'broker1', // ID of the broker who added the item
//   );

//   await newItemByBroker.addItem();

//   // Add a Inventory item by an employee
//   final InventoryItem newItemByEmployee = InventoryItem(
//     id: '2',
//     title: 'New Item by Employee',
//     description: 'This item is added by an employee',
//     imageUrl: 'https://example.com/image.jpg',
//     brokerId: 'employee1', // ID of the employee who added the item
//   );

//   await newItemByEmployee.addItem();

  // Get Inventory items for a specific broker
//   final List<InventoryItem> InventoryItems =
//       await InventoryItem.getInventoryItemsForBroker('broker1');
//   InventoryItems.forEach((item) {
//     print('Title: ${item.title}');
//     print('Description: ${item.description}');
//   });
// }
