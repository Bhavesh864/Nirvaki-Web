import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:yes_broker/constants/app_constant.dart';

import 'package:yes_broker/constants/firebase/userModel/message.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // FirebaseDatabase database = FirebaseDatabase.instance;

  Future<void> sendMessage(String receiverId, String message) async {
    final User? user = await User.getUser(AppConst.getAccessToken());
    final Timestamp timestamp = Timestamp.now();
    UserChatMessage newMessage = UserChatMessage(
      senderId: user!.userId,
      senderEmail: "${user.userfirstname} ${user.userlastname}",
      receiverId: receiverId,
      timestamp: timestamp,
      message: message,
    );

    List<String> ids = [user.userId, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection(
          'messages',
        )
        .add(
          newMessage.toMap(),
        );
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join(('_'));
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy(
          'timestamp',
          descending: false,
        )
        .snapshots();
  }

  // Stream<List> getChatContacts() {
  //   return _firestore.collection('chat_rooms').doc(chatRoomId).collection('messages').snapshots().asyncMap((event) => null);
  // }
}

Future<List<User>> getAllGroups() async {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  try {
    final QuerySnapshot querySnapshot = await firebaseFirestore.collection("chat_rooms").where("members", arrayContains: AppConst.getAccessToken()).get();
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
