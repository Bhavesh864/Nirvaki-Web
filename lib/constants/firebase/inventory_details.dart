// import 'package:cloud_firestore/cloud_firestore.dart';

// final CollectionReference usersCollection =
//     FirebaseFirestore.instance.collection('inventoryDetails');

// class InventoryDetails {
//   final String id;
//   final String title;
//   final String description;
//   final String imageUrl;
//   final List<String> userId;
//   final String specs;
//   final String size;
//   final String price;
//   final String type;
//   final String status;
//   final Map<String, dynamic> customerDetails;
//   // final String customerFirstName;
//   // final String customerLastName;
//   // final int customerPhone;
//   // final int customerWhatsApp;
//   // final String customerEmail;
//   final String brokerId;
//   final String propertyName;
//   final String propertyCategory;
//   final String propertyComesFrom;

//   InventoryDetails({
//     required this.propertyName,
//     required this.customerDetails,
//     // required this.customerEmail,
//     required this.propertyCategory,
//     required this.propertyComesFrom,
//     required this.userId,
//     required this.specs,
//     required this.size,
//     required this.price,
//     required this.type,
//     required this.status,
//     // required this.customerPhone,
//     // required this.customerFirstName,
//     // required this.customerLastName,
//     // required this.customerWhatsApp,
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.imageUrl,
//     required this.brokerId,
//   });

//   // Convert InventoryDetails object to a map
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'title': title,
//       'description': description,
//       'imageUrl': imageUrl,
//       'brokerId': brokerId,
//       "userId": userId,
//       "specs": specs,
//       "size": size,
//       "price": price,
//       "type": type,
//       "customerDetails": customerDetails,
//       // "customerPhone": customerPhone,
//       "status": status,
//       // "customerFirstName": customerFirstName,
//       // "customerLastName": customerLastName,
//       // "customerWhatsApp": customerWhatsApp,
//       "propertyName": propertyName,
//       "propertyCategory": propertyCategory,
//       "propertyComesFrom": propertyComesFrom
//     };
//   }

//   // Create InventoryDetails object from a map
//   factory InventoryDetails.fromMap(Map<String, dynamic> map) {
//     return InventoryDetails(
//         id: map['id'],
//         title: map['title'],
//         description: map['description'],
//         imageUrl: map['imageUrl'],
//         brokerId: map['brokerId'],
//         userId: List<String>.from(map['userId']),
//         customerDetails: map['customerDetails'],
//         // customerFirstName: map['customerFirstName'],
//         // customerLastName: map['customerLastName'],
//         // customerPhone: map['customerPhone'],
//         // customerWhatsApp: map['customerWhatsApp'],
//         price: map['price'],
//         size: map['size'],
//         specs: map['specs'],
//         status: map['status'],
//         type: map['type'],
//         propertyName: map['propertyName'],
//         propertyCategory: map['propertyCategory'],
//         propertyComesFrom: map['propertyComesFrom']);
//   }

//   // Create a new Inventory item
//   static Future<void> addItem(InventoryDetails inventory) async {
//     try {
//       await usersCollection.doc(inventory.id).set(inventory.toMap());
//       print('Inventory item added successfully');
//     } catch (error) {
//       print('Failed to add Inventory item: $error');
//     }
//   }

//   // Get Inventory items added by the broker or employees under the broker
//   static Future<InventoryDetails?> getInventoryDetails(String id) async {
//     try {
//       final DocumentSnapshot documentSnapshot =
//           await usersCollection.doc(id).get();
//       final Map<String, dynamic> data =
//           documentSnapshot.data() as Map<String, dynamic>;
//       return InventoryDetails.fromMap(data);
//     } catch (error) {
//       print('Failed to get Inventory items: $error');
//       return null;
//     }
//   }

//   static Future<void> updateItem(InventoryDetails item) async {
//     try {
//       await usersCollection.doc(item.id).update(item.toMap());
//       print('Inventory item updated successfully');
//     } catch (error) {
//       print('Failed to update Inventory item: $error');
//     }
//   }

//   // Delete a Inventory item
//   static Future<void> deleteItem(String id) async {
//     try {
//       await usersCollection.doc(id).delete();
//       print('Inventory item deleted successfully');
//     } catch (error) {
//       print('Failed to delete Inventory item: $error');
//     }
//   }
// }


// // use this type
//   // void initState() {
//   //   super.initState();
//   //   fetchInventoryDetailss();
//   // }

//   // Future<void> fetchInventoryDetailss() async {
//   //   // Fetch Inventory items from Firestore
//   //   final List<InventoryDetails> items = await InventoryDetails.getInventoryDetailss();

//   //   setState(() {
//   //     InventoryDetailss = items;
//   //   });
//   // }

// // Usage example:

// // void mains() async {
// //   // Add a Inventory item by a broker
// //   final InventoryDetails newItemByBroker = InventoryDetails(
// //     id: '1',
// //     title: 'New Item by Broker',
// //     description: 'This item is added by the broker',
// //     imageUrl: 'https://example.com/image.jpg',
// //     brokerId: 'broker1', // ID of the broker who added the item
// //   );

// //   await newItemByBroker.addItem();

// //   // Add a Inventory item by an employee
// //   final InventoryDetails newItemByEmployee = InventoryDetails(
// //     id: '2',
// //     title: 'New Item by Employee',
// //     description: 'This item is added by an employee',
// //     imageUrl: 'https://example.com/image.jpg',
// //     brokerId: 'employee1', // ID of the employee who added the item
// //   );

// //   await newItemByEmployee.addItem();

//   // Get Inventory items for a specific broker
// //   final List<InventoryDetails> InventoryDetailss =
// //       await InventoryDetails.getInventoryDetailssForBroker('broker1');
// //   InventoryDetailss.forEach((item) {
// //     print('Title: ${item.title}');
// //     print('Description: ${item.description}');
// //   });
// // }
