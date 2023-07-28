import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

final FirebaseAuth auth = FirebaseAuth.instance;

@HiveType(typeId: 0)
class User {
  String brokerId;
  String userId;
  String userfirstname;
  String userlastname;
  int mobile;
  String email;
  String role;
  String status;
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
      // Check if the user exists in the 'users' box in Hive
      final usersBox = Hive.box('users');
      final userFromHive = usersBox.get(userId);
      print("userFromHive=====>$userFromHive");
      if (userFromHive != null) {
        return userFromHive;
      } else {
        final DocumentSnapshot documentSnapshot = await usersCollection.doc(userId).get();
        if (documentSnapshot.exists) {
          final Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
          final User user = User.fromMap(data);
          usersBox.put(userId, user);
          return user;
        } else {
          return null;
        }
      }
    } catch (error) {
      if (kDebugMode) {
        // print('Failed to get user: $error');
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

Future<String?> signinwith(email, password) async {
  String res = 'Something went wrong';
  try {
    await auth.signInWithEmailAndPassword(email: email, password: password);
    res = "success";
    return res;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      return 'No user found for that email.';
    } else if (e.code == 'wrong-password') {
      return 'Wrong password provided.';
    }
    return e.toString();
  } catch (E) {
    return E.toString();
  }
  // return null;
}

Future<String> signUpwith(email, password) async {
  String res = 'Something went wrong';
  try {
    await auth.createUserWithEmailAndPassword(email: email, password: password);
    // final User item = User(
    //     brokerId: auth.currentUser!.uid,
    //     status: 'accepted',
    //     name: 'testing',
    //     userId: auth.currentUser!.uid,
    //     mobile: 123456789,
    //     email: email,
    //     role: 'broker',
    //     image: '');
    // await User.addUser(item);
    res = "success";
    return res;
  } catch (er) {
    // print(er);
    return er.toString();
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
