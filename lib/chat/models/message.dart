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
  // final String repliedMessage;
  // final String repliedTo;
  // final MessageEnum repliedMessageType;

  ChatMessage({
    required this.senderId,
    required this.senderName,
    required this.recieverid,
    required this.text,
    required this.type,
    required this.timeSent,
    required this.messageId,
    required this.isSeen,
    // required this.repliedMessage,
    // required this.repliedTo,
    // required this.repliedMessageType,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'recieverid': recieverid,
      'text': text,
      'type': type.type,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'messageId': messageId,
      'isSeen': isSeen,
      'senderName': senderName,
      // 'repliedMessage': repliedMessage,
      // 'repliedTo': repliedTo,
      // 'repliedMessageType': repliedMessageType.type,
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
    );
  }
}
