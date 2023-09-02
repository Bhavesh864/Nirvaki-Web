import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:yes_broker/constants/app_constant.dart';

import 'package:yes_broker/constants/firebase/userModel/message.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseDatabase database = FirebaseDatabase.instance;
  // DatabaseReference ref = FirebaseDatabase.instance.ref();

  Future<void> sendMessage(String receiverId, String message) async {
    final User? user = await User.getUser(AppConst.getAccessToken());
    final Timestamp timestamp = Timestamp.now();
    print("timestamp--> $timestamp");

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

    // DatabaseReference messageRef = database.reference().child('chat_rooms/$chatRoomId/messages');
    // messageRef.push().set(newMessage.toMap());
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

    // DatabaseReference messageRef = database.reference().child('chat_rooms/$chatRoomId/messages');

    // return messageRef.orderByChild('timestamp').onValue;
  }
}
