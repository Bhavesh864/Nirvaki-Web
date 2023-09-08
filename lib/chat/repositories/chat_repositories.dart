import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:yes_broker/chat/models/chat_group.dart';
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

  Stream<List<ChatGroup>> getChatGroups() {
    return firestore.collection('groups').snapshots().map(
      (event) {
        try {
          List<ChatGroup> groups = [];
          for (var document in event.docs) {
            var group = ChatGroup.fromMap(document.data());
            if (group.membersUid.contains(AppConst.getAccessToken().toString())) {
              groups.add(group);
            }
          }
          return groups;
        } catch (e) {
          print(e.toString());
          return [];
        }
      },
    );
  }

  Stream<List<ChatMessage>> getGroupChatStream(String groudId) {
    return firestore
        .collection('groups')
        .doc(groudId)
        .collection('chats')
        .orderBy(
          'timeSent',
        )
        .snapshots()
        .map((event) {
      List<ChatMessage> messages = [];
      for (var document in event.docs) {
        messages.add(ChatMessage.fromMap(document.data()));
      }
      return messages;
    });
  }

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
            name: '${user.userfirstname} ${user.userlastname}',
            profilePic: user.image,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage,
            lastMessageIsSeen: chatContact.lastMessageIsSeen,
            lastMessageSenderId: chatContact.lastMessageSenderId,
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
    try {
      await firestore
          .collection('users')
          .doc(AppConst.getAccessToken())
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});

      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(AppConst.getAccessToken())
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});
    } catch (e) {
      customSnackBar(
        context: context,
        text: e.toString(),
      );
    }
  }

  void setLastMessageSeen(
    BuildContext context,
    String recieverUserId,
    bool isGroupChat,
    String? groupId,
  ) async {
    try {
      if (isGroupChat) {
        await firestore.collection('groups').doc(groupId).update(
          {'lastMessageIsSeen': true},
        );

        await firestore.collection('groups').doc(recieverUserId).update(
          {'lastMessageIsSeen': true},
        );
      } else {
        await firestore
            .collection('users')
            .doc(AppConst.getAccessToken())
            .collection('chats')
            .doc(
              recieverUserId,
            )
            .update(
          {'lastMessageIsSeen': true},
        );

        await firestore
            .collection('users')
            .doc(recieverUserId)
            .collection('chats')
            .doc(
              AppConst.getAccessToken(),
            )
            .update(
          {'lastMessageIsSeen': true},
        );
      }
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
    required User? receiverUserData,
    required String message,
    required Timestamp timestamp,
    required String receiverId,
    required bool isGroupChat,
  }) async {
    print(message);
    final ChatContact receiverChatContact = ChatContact(
      name: '${senderUserData.userfirstname} ${senderUserData.userlastname}',
      profilePic: senderUserData.image,
      contactId: senderUserData.userId,
      timeSent: timestamp,
      lastMessage: message,
      lastMessageIsSeen: false,
      lastMessageSenderId: AppConst.getAccessToken().toString(),
    );

    if (isGroupChat) {
      await firestore.collection('groups').doc(receiverId).update({
        'lastMessage': message,
        'timeSent': DateTime.now().millisecondsSinceEpoch,
        'lastMessageSenderId': AppConst.getAccessToken().toString(),
        'lastMessageIsSeen': false,
      });
    } else {
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
        name: '${receiverUserData!.userfirstname} ${receiverUserData.userlastname}',
        profilePic: receiverUserData.image,
        contactId: receiverUserData.userId,
        timeSent: timestamp,
        lastMessage: message,
        lastMessageIsSeen: false,
        lastMessageSenderId: AppConst.getAccessToken().toString(),
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
  }

  void _saveMessageToMessagesSubCollection({
    required String receiverId,
    required String text,
    required Timestamp timeSent,
    required String messageId,
    required String username,
    required String revceiverUsername,
    required MessageEnum messageType,
    required bool isGroupChat,
    required String profilePic,
  }) async {
    final message = ChatMessage(
      senderId: AppConst.getAccessToken(),
      recieverid: receiverId,
      text: text,
      type: MessageEnum.text,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
      senderName: username,
      profilePic: profilePic,
      // repliedMessage: repliedMessage,
      // repliedTo: repliedTo,
      // repliedMessageType: repliedMessageType,
    );

    if (isGroupChat) {
      // groups -> group id -> chat -> message
      await firestore.collection('groups').doc(receiverId).collection('chats').doc(messageId).set(
            message.toMap(),
          );
    } else {
      // users -> sender id -> reciever id -> messages -> message id -> store message

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

      // users -> eciever id  -> sender id -> messages -> message id -> store message

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
  }

  void sendTextMessage({
    required BuildContext context,
    required String message,
    required String receiverId,
    required User senderUser,
    required bool isGroupChat,
    required String profilePic,
  }) async {
    try {
      final Timestamp timestamp = Timestamp.now();
      User? receiverUserData;

      if (!isGroupChat) {
        final userDataMap = await firestore.collection('users').doc(receiverId).get();
        receiverUserData = User.fromMap(userDataMap.data()!);
      }

      var messageId = const Uuid().v1();

      _saveDataToContactsSubCollection(
        senderUserData: senderUser,
        receiverUserData: receiverUserData,
        message: message,
        timestamp: timestamp,
        receiverId: receiverId,
        isGroupChat: isGroupChat,
      );

      _saveMessageToMessagesSubCollection(
        receiverId: receiverId,
        text: message,
        timeSent: timestamp,
        messageId: messageId,
        revceiverUsername: '${receiverUserData?.userfirstname} ${receiverUserData?.userlastname}',
        username: '${senderUser.userfirstname} ${senderUser.userlastname}',
        messageType: MessageEnum.text,
        isGroupChat: isGroupChat,
        profilePic: profilePic,
      );
    } catch (e) {
      customSnackBar(
        context: context,
        text: e.toString(),
      );
    }
  }
}
