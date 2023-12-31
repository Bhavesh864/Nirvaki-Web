// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'package:yes_broker/constants/app_constant.dart';

final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

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
  dynamic fcmToken;
  @HiveField(13)
  bool isOnline;
  User({
    required this.brokerId,
    required this.status,
    required this.userfirstname,
    required this.userlastname,
    required this.userId,
    required this.mobile,
    required this.fcmToken,
    this.managerName,
    this.managerid,
    required this.isOnline,
    required this.email,
    required this.role,
    required this.whatsAppNumber,
    required this.image,
  });

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
        isOnline: json["isOnline"],
        whatsAppNumber: json["whatsAppNumber"]);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'brokerId': brokerId,
      'userId': userId,
      'userfirstname': userfirstname,
      'userlastname': userlastname,
      'mobile': mobile,
      'email': email,
      'role': role,
      'status': status,
      'image': image,
      'whatsAppNumber': whatsAppNumber,
      'managerid': managerid,
      'managerName': managerName,
      'fcmToken': fcmToken,
      'isOnline': isOnline,
    };
  }

  // Create User object from a map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      brokerId: map['brokerId'] as String,
      userId: map['userId'] as String,
      userfirstname: map['userfirstname'] as String,
      userlastname: map['userlastname'] as String,
      mobile: map['mobile'] as String,
      email: map['email'] as String,
      role: map['role'] as String,
      status: map['status'] as String,
      image: map['image'] as String,
      whatsAppNumber: map['whatsAppNumber'] as String,
      managerid: map['managerid'] != null ? map['managerid'] as String : null,
      managerName: map['managerName'] != null ? map['managerName'] as String : null,
      fcmToken: map['fcmToken'] != null ? map['fcmToken'] as dynamic : null,
      isOnline: map['isOnline'] as bool,
    );
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

  static Future<void> updateUser(User user) async {
    try {
      await usersCollection.doc(user.userId).update(user.toMap());
      print('User updated successfully');
    } catch (error) {
      print('Failed to update user: $error');
    }
  }

  static void setUserOnlineStatus(bool isOnline) async {
    if (AppConst.getAccessToken() != null) {
      await usersCollection.doc(AppConst.getAccessToken()).update({
        'isOnline': isOnline,
      });
    }
  }

  static Future<String> resetPassword(String email) async {
    try {
      var res = "pending";
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value) => {res = "success"});
      return res;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<List<User>> getListOfUsersByIds(List<dynamic> userIds) async {
    try {
      final QuerySnapshot querySnapshot = await usersCollection.where("userId", whereIn: userIds).get();
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
        print('Failed to get users by IDs: $error');
      }
      return [];
    }
  }

  static Future<List<User>> getAllUsers(User currentuser) async {
    try {
      final QuerySnapshot querySnapshot = await usersCollection.where("brokerId", isEqualTo: currentuser.brokerId).get();
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

  static Future<List<User>> getUserAllRelatedToBrokerId(User currentuser) async {
    try {
      final QuerySnapshot querySnapshot = await usersCollection.where("brokerId", isEqualTo: currentuser.brokerId).get();
      final List<User> users = [];
      for (final DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        if (documentSnapshot.exists) {
          final Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
          final User user = User.fromMap(data);
          users.add(user);
        }
      }
      final List<User> userRelatedBYmanager = users.where((element) => element.managerid == currentuser.userId).toList();
      return userRelatedBYmanager;
    } catch (error) {
      if (kDebugMode) {
        print('Failed to get users: $error');
      }
      return [];
    }
  }

  static Future<User?> getUser(String userId, {WidgetRef? ref}) async {
    try {
      // final hiveUserData = UserHiveMethods.getdata(userId);
      // if (hiveUserData != null) {
      //   final Map<String, dynamic> userDataMap = Map.from(hiveUserData);
      //   final User user = User.fromMap(userDataMap);
      //   AppConst.setRole(user.role);
      //   WidgetsBinding.instance.addPostFrameCallback((_) {
      //     ref?.read(userDataProvider.notifier).storeUserData(user);
      //   });
      //   return user;
      // } else {
      final DocumentSnapshot documentSnapshot = await usersCollection.doc(userId).get();
      if (documentSnapshot.exists) {
        final Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        final User user = User.fromMap(data);
        // UserHiveMethods.addData(key: userId, data: user.toMap());
        return user;
      } else {
        return null;
      }
      // }
    } catch (error) {
      if (kDebugMode) {
        print('Failed to get user: $error');
      }
      return null;
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
    return userTokens;
  }

  String toJson() => json.encode(toMap());
  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);
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
