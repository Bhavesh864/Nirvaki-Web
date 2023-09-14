import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:yes_broker/chat/models/chat_group.dart';
import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/customs/snackbar.dart';
import 'package:yes_broker/riverpodstate/user_data.dart';

import '../../constants/firebase/userModel/user_info.dart';
import '../../riverpodstate/upload_file_to_firebase.dart';

final groupRepositoryProvider = Provider(
  (ref) => GroupRepository(
    firestore: FirebaseFirestore.instance,
    ref: ref,
  ),
);

class GroupRepository {
  final FirebaseFirestore firestore;
  final ProviderRef ref;
  GroupRepository({
    required this.firestore,
    required this.ref,
  });

  void createGroup(
    BuildContext context,
    String name,
    File? profilePic,
    List<User> selectedUsers,
    Uint8List? webImage,
  ) async {
    try {
      final User currentUser = ref.read(userDataProvider);
      List<String> uids = [];

      for (int i = 0; i < selectedUsers.length; i++) {
        var userCollection = await firestore
            .collection('users')
            .where(
              'email',
              isEqualTo: selectedUsers[i].email.replaceAll(
                    ' ',
                    '',
                  ),
            )
            .get();

        if (userCollection.docs.isNotEmpty && userCollection.docs[0].exists) {
          uids.add(userCollection.docs[0].data()['userId']);
        }
      }

      var groupId = const Uuid().v1();

      String profileUrl = await ref.read(commonFirebaseStorageRepositoryProvider).storeFileToFirebase(
            'group/$groupId',
            profilePic,
            webImage,
          );

      ChatGroup group = ChatGroup(
        senderId: AppConst.getAccessToken(),
        name: name,
        groupId: groupId,
        lastMessage: '${currentUser.userfirstname} ${currentUser.userlastname} has created the group',
        groupIcon: profileUrl,
        membersUid: [AppConst.getAccessToken().toString(), ...uids],
        timeSent: Timestamp.now(),
        lastMessageIsSeen: false,
        lastMessageSenderId: AppConst.getAccessToken().toString(),
        groupCreatedBy: '${currentUser.userfirstname} ${currentUser.userlastname} created group "$name"',
      );

      await firestore.collection('groups').doc(groupId).set(group.toMap());
    } catch (e) {
      customSnackBar(context: context, text: e.toString());
    }
  }
}
