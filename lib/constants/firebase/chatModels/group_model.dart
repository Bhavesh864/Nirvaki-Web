import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference groupCollection = FirebaseFirestore.instance.collection('groups');

class Group {
  final String senderId;
  final String name;
  final String groupId;
  final String lastMessage;
  final String groupPic;
  final List<String> membersUid;
  final DateTime timeSent;
  Group({
    required this.senderId,
    required this.name,
    required this.groupId,
    required this.lastMessage,
    required this.groupPic,
    required this.membersUid,
    required this.timeSent,
  });

  factory Group.fromSnapshot(DocumentSnapshot snapshot) {
    final json = snapshot.data() as Map<String, dynamic>;
    return Group(
      senderId: json["senderId"],
      name: json["name"],
      groupId: json["groupId"],
      groupPic: json["groupPic"],
      lastMessage: json["lastMessage"],
      membersUid: json["membersUid"],
      timeSent: json["timeSent"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'name': name,
      'groupId': groupId,
      'lastMessage': lastMessage,
      'groupPic': groupPic,
      'membersUid': membersUid,
      'timeSent': timeSent.millisecondsSinceEpoch,
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      senderId: map['senderId'] ?? '',
      name: map['name'] ?? '',
      groupId: map['groupId'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      groupPic: map['groupPic'] ?? '',
      membersUid: List<String>.from(map['membersUid']),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
    );
  }

  // static Future<void> addMembersOnGroup({required String groupId, required List<String> userids}) async {
  //   try {
  //     QuerySnapshot querySnapshot = await groupCollection.where("groupId", isEqualTo: groupId).get();
  //     for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
  //       Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
  //       List<dynamic> memberids = data['membersUid'] ?? [];
  //       memberids.addAll(userids);
  //       await docSnapshot.reference.update({'membersUid': memberids});
  //       print('membersUid added successfully to item ${docSnapshot.id}');
  //     }
  //   } catch (error) {
  //     print('Failed to add membersUid to items: $error');
  //   }
  // }

  // static Future<void> deleteMember({required String groupId, required String memberIdToDelete}) async {
  //   try {
  //     QuerySnapshot querySnapshot = await groupCollection.where("groupId", isEqualTo: groupId).get();
  //     for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
  //       Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
  //       List<dynamic> memberids = data['membersUid'] ?? [];
  //       if (memberids.contains(memberIdToDelete)) {
  //         memberids.remove(memberIdToDelete);
  //         await docSnapshot.reference.update({'membersUid': memberids});
  //         print('Member deleted successfully from group ${docSnapshot.id}');
  //         return;
  //       }
  //     }
  //     print('Member not found in any group with groupId: $groupId');
  //   } catch (error) {
  //     print('Failed to delete member: $error');
  //   }
  // }
  static Future<void> addMembersOnGroup({required String groupId, required List<String> userids}) async {
    try {
      DocumentSnapshot docSnapshot = await groupCollection.doc(groupId).get();
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        List<dynamic> memberids = data['membersUid'] ?? [];
        memberids.addAll(userids);
        await docSnapshot.reference.update({'membersUid': memberids});
        print('membersUid added successfully to item with docId: $groupId');
      } else {
        print('Document not found with docId: $groupId');
      }
    } catch (error) {
      print('Failed to add membersUid to item with docId: $groupId, error: $error');
    }
  }

  static Future<void> deleteMember({required String groupId, required String memberIdToDelete}) async {
    try {
      DocumentSnapshot docSnapshot = await groupCollection.doc(groupId).get();
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        List<dynamic> memberids = data['membersUid'] ?? [];
        if (memberids.contains(memberIdToDelete)) {
          memberids.remove(memberIdToDelete);
          await docSnapshot.reference.update({'membersUid': memberids});
          print('Member deleted successfully from group with groupId: $groupId');
        } else {
          print('Member not found in group with groupId: $groupId');
        }
      } else {
        print('Document not found with groupId: $groupId');
      }
    } catch (error) {
      print('Failed to delete member from group with docId: $groupId, error: $error');
    }
  }

  static Future<void> deleteGroup(String groupId) async {
    try {
      await groupCollection.doc(groupId).delete();
      print('group deleted successfully');
    } catch (error) {
      print('Failed to delete group: $error');
    }
  }
}
