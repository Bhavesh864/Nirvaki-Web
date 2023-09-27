// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatContact {
  final String name;
  final String profilePic;
  final String contactId;
  final Timestamp timeSent;
  final String lastMessage;
  final bool lastMessageIsSeen;
  final String lastMessageSenderId;
  final String role;

  ChatContact({
    required this.name,
    required this.profilePic,
    required this.contactId,
    required this.timeSent,
    required this.lastMessage,
    required this.lastMessageIsSeen,
    required this.lastMessageSenderId,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilePic': profilePic,
      'contactId': contactId,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'lastMessage': lastMessage,
      'lastMessageIsSeen': lastMessageIsSeen,
      'lastMessageSenderId': lastMessageSenderId,
      'role': role,
    };
  }

  factory ChatContact.fromMap(Map<String, dynamic> map) {
    return ChatContact(
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      contactId: map['contactId'] as String,
      timeSent: Timestamp.fromMillisecondsSinceEpoch(map['timeSent']),
      lastMessage: map['lastMessage'] as String,
      lastMessageIsSeen: map['lastMessageIsSeen'] as bool,
      lastMessageSenderId: map['lastMessageSenderId'] as String,
      role: map['role'] as String,
    );
  }
}
