// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:yes_broker/chat/enums/message.enums.dart';

class ChatMessage {
  final String senderId;
  final String recieverid;
  final String text;
  final String senderName;
  final MessageEnum type;
  final Timestamp timeSent;
  final String messageId;
  final bool isSeen;
  final String profilePic;
  // final String repliedMessage;
  // final String repliedTo;
  // final MessageEnum repliedMessageType;

  ChatMessage({
    required this.senderId,
    required this.recieverid,
    required this.text,
    required this.senderName,
    required this.type,
    required this.timeSent,
    required this.messageId,
    required this.isSeen,
    required this.profilePic,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'recieverid': recieverid,
      'text': text,
      'senderName': senderName,
      'type': type.type,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'messageId': messageId,
      'isSeen': isSeen,
      'profilePic': profilePic,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      senderName: map['senderName'] ?? '',
      senderId: map['senderId'] ?? '',
      recieverid: map['recieverid'] ?? '',
      text: map['text'] ?? '',
      type: (map['type'] as String).toEnum(),
      timeSent: Timestamp.fromMillisecondsSinceEpoch(map['timeSent']),
      messageId: map['messageId'] ?? '',
      isSeen: map['isSeen'] ?? false,
      // repliedMessage: map['repliedMessage'] ?? '',
      // repliedTo: map['repliedTo'] ?? '',
      // repliedMessageType: (map['repliedMessageType'] as String).toEnum(),
      profilePic: map['profilePic'] as String,
    );
  }
}
