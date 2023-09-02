import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/firebase/Hive/hive_methods.dart';

import '../../../riverpodstate/user_data.dart';

final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
Box box = Hive.box("users");
final currentUser = box.get(AppConst.getAccessToken());
final FirebaseAuth auth = FirebaseAuth.instance;

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String brokerId;
  @HiveField(1)
  String userId;
  @HiveField(2)
  String userfirstname;
  @HiveField(3)
  String userlastname;
  @HiveField(4)
  String mobile;
  @HiveField(5)
  String email;
  @HiveField(6)
  String role;
  @HiveField(7)
  String status;
  @HiveField(8)
  String image;
  @HiveField(9)
  String whatsAppNumber;
  @HiveField(10)
  String? managerid;
  @HiveField(11)
  String? managerName;
  @HiveField(12)
  String? fcmToken;
  User(
      {required this.brokerId,
      required this.status,
      required this.userfirstname,
      required this.userlastname,
      required this.userId,
      required this.mobile,
      required this.fcmToken,
      this.managerName,
      this.managerid,
      required this.email,
      required this.role,
      required this.whatsAppNumber,
      required this.image});

  // Convert User object to a map

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    final json = snapshot.data() as Map<String, dynamic>;

    return User(
        brokerId: json["brokerId"],
        status: json["status"],
        fcmToken: json["fcmToken"],
        userfirstname: json["userfirstname"],
        userlastname: json["userlastname"],
        userId: json["userId"],
        managerid: json["managerid"],
        mobile: json["mobile"],
        managerName: json["managerName"],
        email: json["email"],
        image: json["image"],
        role: json["role"],
        whatsAppNumber: json["whatsAppNumber"]);
  }

  Map<String, dynamic> toMap() {
    return {
      'brokerId': brokerId,
      'userfirstname': userfirstname,
      'userlastname': userlastname,
      'mobile': mobile,
      "whatsAppNumber": whatsAppNumber,
      'email': email,
      'role': role,
      "managerid": managerid,
      "managerName": managerName,
      'userId': userId,
      "status": status,
      'image': image,
      "fcmToken": fcmToken,
    };
  }

  // Create User object from a map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        brokerId: map['brokerId'],
        userfirstname: map['userfirstname'],
        userlastname: map['userlastname'],
        mobile: map['mobile'],
        email: map["email"],
        whatsAppNumber: map["whatsAppNumber"],
        role: map['role'],
        userId: map['userId'],
        status: map['status'],
        fcmToken: map["fcmToken"],
        managerName: map["managerName"],
        managerid: map["managerid"],
        image: map['image']);
  }
//  -----------------------------Methods------------------------------------------------------------------->

  static Future<void> addUser(User user) async {
    try {
      await usersCollection.doc(user.userId).set(user.toMap());
      // print('User added successfully');
    } catch (error) {
      // print('Failed to add user: $error');
    }
  }

  static Future<List<User>> getAllUsers() async {
    try {
      final QuerySnapshot querySnapshot = await usersCollection.where("brokerId", isEqualTo: currentUser["brokerId"]).get();
      final List<User> users = [];
      for (final DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        if (documentSnapshot.exists) {
          final Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
          final User user = User.fromMap(data);
          users.add(user);
        }
      }
      return users;
    } catch (error) {
      if (kDebugMode) {
        print('Failed to get users: $error');
      }
      return [];
    }
  }

  static Future<User?> getUser(String userId, {WidgetRef? ref}) async {
    try {
      final hiveUserData = UserHiveMethods.getdata(userId);
      // print("userhiveform=====>$hiveUserData");
      if (hiveUserData != null) {
        final Map<String, dynamic> userDataMap = Map.from(hiveUserData);
        final User user = User.fromMap(userDataMap);
        return user;
      } else {
        final DocumentSnapshot documentSnapshot = await usersCollection.doc(userId).get();
        if (documentSnapshot.exists) {
          final Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
          final User user = User.fromMap(data);
          ref.read(userDataProvider.notifier).storeUserData(user);
          UserHiveMethods.addData(key: userId, data: user.toMap());
          return user;
        } else {
          return null;
        }
      }
    } catch (error) {
      print(error);
      if (kDebugMode) {
        print('Failed to get user: $error');
      }
      return null;
    }
  }

  static Future<void> updateUser(User updatedUser) async {
    try {
      await usersCollection.doc(updatedUser.brokerId).update(updatedUser.toMap());
      // print('User updated successfully');
    } catch (error) {
      // print('Failed to update user: $error');
    }
  }

  static Future<void> updateFcmToken({required dynamic fcmtoken, required String userid}) async {
    try {
      await usersCollection.doc(userid).update({"fcmToken": fcmtoken});
      print('User updated successfully');
    } catch (error) {
      print('Failed to update user: $error');
    }
  }

  static Future<void> deleteUser(String userId) async {
    try {
      await usersCollection.doc(userId).delete();
      // print('User deleted successfully');
    } catch (error) {
      // print('Failed to delete user: $error');
    }
  }

  static Future<List<String>> getUserTokensByIds(List<String> userIds) async {
    List<String> userTokens = [];
    try {
      for (String userId in userIds) {
        DocumentSnapshot userDoc = await usersCollection.doc(userId).get();
        if (userDoc.exists) {
          String appFcmToken = userDoc['fcmToken'];
          if (appFcmToken.isNotEmpty) {
            userTokens.add(appFcmToken);
          }
        }
      }
    } catch (e) {
      print('Error fetching user tokens: $e');
    }
    print("usertokens=======$userTokens");
    return userTokens;
  }
}

// void main() async {
// final UserCRUD userCRUD = UserCRUD();

// Create a new user
// final User newUser = User(
//     id: '1',
//     name: 'John Doe',
//     age: 25,
//     hobbies: ['Reading', 'Gaming'],
//     email: 'manishchayal@gmail.com');
// await userCRUD.addUser(newUser);

// // Read the user
// final User? retrievedUser = await userCRUD.getUser('VgbMfHuRlnDQQsEisOf4');
// if (retrievedUser != null) {
//   print('Name: ${retrievedUser.name}');
//   // print('Age: ${retrievedUser.age}');
//   // print('Hobbies: ${retrievedUser.obbies}');
// }

// // Update the user
// if (retrievedUser != null) {
//   retrievedUser.name = 'Jane Smith';

//   await userCRUD.updateUser(retrievedUser);
// }
// // Delete the user
// await userCRUD.deleteUser('1');
// // }

dynamic getDataById(dataArray, int id) {
  for (var data in dataArray) {
    if (data["id"] == id) {
      return data['item'];
    }
  }
  return null;
}
