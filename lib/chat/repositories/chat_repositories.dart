import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../Customs/snackbar.dart';
import '../../constants/app_constant.dart';
import '../../constants/firebase/userModel/user_info.dart';
import '../models/chat_contact.dart';
import '../enums/message.enums.dart';
import '../models/message.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    firestore: FirebaseFirestore.instance,
  ),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  // final FirebaseAuth auth;

  ChatRepository({
    required this.firestore,
    // required this.auth,
  });

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(AppConst.getAccessToken())
        .collection(
          'chats',
        )
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firestore.collection('users').doc(chatContact.contactId).get();
        var user = User.fromMap(userData.data()!);

        contacts.add(
          ChatContact(
            name: '${user.userfirstname}  ${user.userlastname}',
            profilePic: user.image,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage,
          ),
        );
      }
      return contacts;
    });
  }

  Stream<List<ChatMessage>> getChatStream(String recieverUserId) {
    return firestore
        .collection('users')
        .doc(AppConst.getAccessToken())
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<ChatMessage> messages = [];
      for (var document in event.docs) {
        messages.add(ChatMessage.fromMap(document.data()));
      }
      return messages;
    });
  }

  void setChatMessageSeens(
    BuildContext context,
    String recieverUserId,
    String messageId,
    bool isSender,
  ) async {
    print('alijksdflkajsd ----------$recieverUserId');
    print('messag id ----------$messageId');
    try {
      await firestore
          .collection('users')
          .doc(AppConst.getAccessToken())
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true}).then((value) => {print("sender")});

      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(AppConst.getAccessToken())
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true}).then((value) => {print("reciver")});
    } catch (e) {
      customSnackBar(
        context: context,
        text: e.toString(),
      );
      print(e.toString());
    }
  }

  void _saveDataToContactsSubCollection({
    required User senderUserData,
    required User receiverUserData,
    required String message,
    required Timestamp timestamp,
    required String receiverId,
  }) async {
    final ChatContact receiverChatContact = ChatContact(
      name: '${senderUserData.userfirstname}  ${senderUserData.userlastname}',
      profilePic: senderUserData.image,
      contactId: senderUserData.userId,
      timeSent: timestamp,
      lastMessage: message,
    );

    await firestore
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(
          AppConst.getAccessToken(),
        )
        .set(
          receiverChatContact.toMap(),
        );

    var senderChatContact = ChatContact(
      name: '${receiverUserData.userfirstname}  ${receiverUserData.userlastname}',
      profilePic: receiverUserData.image,
      contactId: receiverUserData.userId,
      timeSent: timestamp,
      lastMessage: message,
    );
    await firestore
        .collection('users')
        .doc(
          AppConst.getAccessToken(),
        )
        .collection('chats')
        .doc(
          receiverId,
        )
        .set(
          senderChatContact.toMap(),
        );
  }

  void _saveMessageToMessagesSubCollection({
    required String receiverId,
    required String text,
    required Timestamp timeSent,
    required String messageId,
    required String username,
    required String revceiverUsername,
    required MessageEnum messageType,
  }) async {
    final message = ChatMessage(
        senderId: AppConst.getAccessToken(),
        recieverid: receiverId,
        text: text,
        type: MessageEnum.text,
        timeSent: timeSent,
        messageId: messageId,
        isSeen: false,
        senderName: username
        // repliedMessage: repliedMessage,
        // repliedTo: repliedTo,
        // repliedMessageType: repliedMessageType,
        );

    await firestore
        .collection('users')
        .doc(AppConst.getAccessToken())
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .doc(
          messageId,
        )
        .set(
          message.toMap(),
        );

    await firestore
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(AppConst.getAccessToken())
        .collection('messages')
        .doc(
          messageId,
        )
        .set(
          message.toMap(),
        );
  }

  void sendTextMessage({
    required BuildContext context,
    required String message,
    required String receiverId,
    required User senderUser,
  }) async {
    try {
      final Timestamp timestamp = Timestamp.now();
      User receiverUserData;

      final userDataMap = await firestore.collection('users').doc(receiverId).get();
      receiverUserData = User.fromMap(userDataMap.data()!);

      var messageId = Uuid().v1();

      print(receiverId);

      _saveDataToContactsSubCollection(
        senderUserData: senderUser,
        receiverUserData: receiverUserData,
        message: message,
        timestamp: timestamp,
        receiverId: receiverId,
      );

      _saveMessageToMessagesSubCollection(
        receiverId: receiverId,
        text: message,
        timeSent: timestamp,
        messageId: messageId,
        revceiverUsername: '${receiverUserData.userfirstname}  ${receiverUserData.userlastname}',
        username: '${senderUser.userfirstname}  ${senderUser.userlastname}',
        messageType: MessageEnum.text,
      );
    } catch (e) {
      customSnackBar(
        context: context,
        text: e.toString(),
      );
    }
  }
}
