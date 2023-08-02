import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';

import 'package:yes_broker/constants/firebase/userModel/user_info.dart';

final CollectionReference brokerInfosCollection = FirebaseFirestore.instance.collection('brokerInfo');

final auth.FirebaseAuth authentication = auth.FirebaseAuth.instance;

class BrokerInfo {
  String? brokerid;
  String? companyname;
  int? brokercompanynumber;
  int? brokercompanywhatsapp;
  String? brokercompanyemail;
  String? brokerlogo;
  String role;
  Map<String, dynamic> brokercompanyaddress;
  BrokerInfo({
    required this.brokerid,
    required this.role,
    required this.companyname,
    required this.brokercompanynumber,
    required this.brokercompanywhatsapp,
    required this.brokercompanyemail,
    required this.brokerlogo,
    required this.brokercompanyaddress,
  });

  // Convert BrokerInfo object to a map
  Map<String, dynamic> toMap() {
    return {
      'brokerid': brokerid,
      'companyname': companyname,
      'brokercompanynumber': brokercompanynumber,
      'brokercompanywhatsapp': brokercompanywhatsapp,
      'brokercompanyemail': brokercompanyemail,
      'brokerlogo': brokerlogo,
      'brokercompanyaddress': brokercompanyaddress,
      "role": role,
    };
  }

  // Create BrokerInfo object from a map
  factory BrokerInfo.fromMap(Map<String, dynamic> map) {
    return BrokerInfo(
      brokerid: map['brokerid'],
      companyname: map['companyname'],
      brokercompanynumber: map['brokercompanynumber'],
      brokercompanywhatsapp: map['brokercompanywhatsapp'],
      brokercompanyemail: map["brokercompanyemail"],
      role: map['role'],
      brokerlogo: map['brokerlogo'],
      brokercompanyaddress: map['brokercompanyaddress'],
    );
  }
//  -----------------------------Methods------------------------------------------------------------------->

  static Future<void> addBrokerInfo(BrokerInfo brokerInfo) async {
    try {
      await brokerInfosCollection.doc(brokerInfo.brokerid).set(brokerInfo.toMap());
      print('BrokerInfo added successfully');
    } catch (error) {
      print('Failed to add BrokerInfo: $error');
    }
  }

  static Future<BrokerInfo?> getBrokerInfo(String brokerInfo) async {
    try {
      final DocumentSnapshot documentSnapshot = await brokerInfosCollection.doc(brokerInfo).get();
      if (documentSnapshot.exists) {
        final Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        return BrokerInfo.fromMap(data);
      } else {
        return null;
      }
    } catch (error) {
      if (kDebugMode) {
        print('Failed to get BrokerInfo: $error');
      }
      return null;
    }
  }

  static Future<void> updateBrokerInfo(BrokerInfo updatedBrokerInfo) async {
    try {
      await brokerInfosCollection.doc(updatedBrokerInfo.brokerid).update(updatedBrokerInfo.toMap());
      print('BrokerInfo updated successfully');
    } catch (error) {
      print('Failed to update BrokerInfo: $error');
    }
  }

  static Future<void> deleteBrokerInfo(String brokerid) async {
    try {
      await brokerInfosCollection.doc(brokerid).delete();
      print('BrokerInfo deleted successfully');
    } catch (error) {
      print('Failed to delete BrokerInfo: $error');
    }
  }
}

Future<String?> signinwithbroker(email, password) async {
  String res = 'Something went wrong';
  try {
    await authentication.signInWithEmailAndPassword(email: email, password: password);
    res = "success";
    return res;
  } on auth.FirebaseAuthException catch (e) {
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

Future<String> signUpwithbroker(email, password, others) async {
  String res = 'Something went wrong';
  try {
    await authentication.createUserWithEmailAndPassword(email: email, password: password);
    final BrokerInfo item = BrokerInfo(
      brokerid: authentication.currentUser?.uid,
      role: 'broker',
      companyname: 'bhavesh',
      brokercompanynumber: 1234567890,
      brokercompanywhatsapp: 1234567890,
      brokercompanyemail: email,
      brokerlogo: "",
      brokercompanyaddress: {"Addressline1": 'pawan-puri', "Addressline2": 'nursing home', "city": "bikaner", "state": "rajasthan"},
    );
    final User items = User(
      brokerId: authentication.currentUser!.uid,
      status: 'accepted',
      userfirstname: 'bhavesh',
      userlastname: 'khatri',
      userId: authentication.currentUser!.uid,
      mobile: 1234567890,
      email: email,
      role: 'broker',
      image: '',
    );
    await User.addUser(items);
    await BrokerInfo.addBrokerInfo(item);
    res = "success";
    return res;
  } catch (er) {
    // print(er);
    return er.toString();
  }
}

// void main() async {
// final BrokerInfoCRUD BrokerInfoCRUD = BrokerInfoCRUD();

// Create a new BrokerInfo
// final BrokerInfo newBrokerInfo = BrokerInfo(
//     id: '1',
//     name: 'John Doe',
//     age: 25,
//     hobbies: ['Reading', 'Gaming'],
//     email: 'manishchayal@gmail.com');
// await BrokerInfoCRUD.addBrokerInfo(newBrokerInfo);

// // Read the BrokerInfo
// final BrokerInfo? retrievedBrokerInfo = await BrokerInfoCRUD.getBrokerInfo('VgbMfHuRlnDQQsEisOf4');
// if (retrievedBrokerInfo != null) {
//   print('Name: ${retrievedBrokerInfo.name}');
//   // print('Age: ${retrievedBrokerInfo.age}');
//   // print('Hobbies: ${retrievedBrokerInfo.obbies}');
// }

// // Update the BrokerInfo
// if (retrievedBrokerInfo != null) {
//   retrievedBrokerInfo.name = 'Jane Smith';

//   await BrokerInfoCRUD.updateBrokerInfo(retrievedBrokerInfo);
// }

// // Delete the BrokerInfo
// await BrokerInfoCRUD.deleteBrokerInfo('1');
// }
