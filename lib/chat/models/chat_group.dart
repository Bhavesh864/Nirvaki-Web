// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatGroup {
  final String senderId;
  final String name;
  final String groupId;
  final String groupIcon;
  final Timestamp timeSent;
  final String lastMessage;
  final List<String> membersUid;

  ChatGroup({
    required this.senderId,
    required this.name,
    required this.groupId,
    required this.groupIcon,
    required this.timeSent,
    required this.lastMessage,
    required this.membersUid,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'name': name,
      'groupId': groupId,
      'groupIcon': groupIcon,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'lastMessage': lastMessage,
      'membersUid': membersUid,
    };
  }

  factory ChatGroup.fromMap(Map<String, dynamic> map) {
    return ChatGroup(
      senderId: map['senderId'] as String,
      name: map['name'] as String,
      groupId: map['groupId'] as String,
      groupIcon: map['groupIcon'] as String,
      timeSent: Timestamp.fromMillisecondsSinceEpoch(map['timeSent']),
      lastMessage: map['lastMessage'] as String,
      membersUid: List<String>.from(
        (map['membersUid']),
      ),
    );
  }
}
