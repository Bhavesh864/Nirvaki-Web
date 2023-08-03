import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:yes_broker/constants/firebase/Hive/hive_methods.dart';
import 'package:yes_broker/constants/firebase/userModel/broker_info.dart';

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
  int mobile;
  @HiveField(5)
  String email;
  @HiveField(6)
  String role;
  @HiveField(7)
  String status;
  @HiveField(8)
  String image;

  User(
      {required this.brokerId,
      required this.status,
      required this.userfirstname,
      required this.userlastname,
      required this.userId,
      required this.mobile,
      required this.email,
      required this.role,
      required this.image});

  // Convert User object to a map
  Map<String, dynamic> toMap() {
    return {
      'brokerId': brokerId,
      'userfirstname': userfirstname,
      'userlastname': userlastname,
      'mobile': mobile,
      'email': email,
      'role': role,
      'userId': userId,
      "status": status,
      'image': image
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
        role: map['role'],
        userId: map['userId'],
        status: map['status'],
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
      final QuerySnapshot querySnapshot = await usersCollection.get();
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

  static Future<User?> getUser(String userId) async {
    try {
      final hiveUserData = UserHiveMethods.getdata(userId);
      print("userhiveform=====>${hiveUserData}");
      if (hiveUserData != null) {
        final Map<String, dynamic> userDataMap = Map.from(hiveUserData);
        final User user = User.fromMap(userDataMap);
        return user;
      } else {
        final DocumentSnapshot documentSnapshot = await usersCollection.doc(userId).get();
        if (documentSnapshot.exists) {
          final Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
          final User user = User.fromMap(data);
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

  static Future<void> deleteUser(String userId) async {
    try {
      await usersCollection.doc(userId).delete();
      // print('User deleted successfully');
    } catch (error) {
      // print('Failed to delete user: $error');
    }
  }
}

Future<String?> signinMethod({required email, required password}) async {
  String res = 'Something went wrong';
  try {
    await auth.signInWithEmailAndPassword(email: email, password: password);
    res = "success";
    return res;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      return 'No user found for that email.';
    } else if (e.code == 'wrong-password') {
      return 'Wrong password provided for that user.';
    } else if (e.code == "email-already-in-use") {
      return "The account already exists for that email";
    } else if (e.code == "weak-password") {
      return "The password provided is too weak.";
    }
    return e.toString();
  } catch (E) {
    return E.toString();
  }
  // return null;
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
