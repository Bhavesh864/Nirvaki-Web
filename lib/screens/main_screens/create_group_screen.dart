import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yes_broker/constants/app_constant.dart';

import 'package:yes_broker/constants/firebase/random_uid.dart';
import 'package:yes_broker/customs/custom_fields.dart';
import 'package:yes_broker/customs/snackbar.dart';
import 'package:yes_broker/customs/text_utility.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/screens/main_screens/chat_screen.dart';
import '../../constants/firebase/userModel/message.dart';
import '../../constants/firebase/userModel/user_info.dart';
import '../../widgets/chat/group/newgroup_user_list.dart';

class CreateGroupScreen extends StatefulWidget {
  final List<User>? list;
  final bool? createGroup;
  const CreateGroupScreen({super.key, this.list, this.createGroup = true});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  bool isConfirm = false;
  final groupNameController = TextEditingController();
  List<User> selectedUser = [];
  File? groupIcon;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  void toggleUser(User user) {
    setState(() {
      if (selectedUser.contains(user)) {
        selectedUser.remove(user);
      } else {
        selectedUser.add(user);
      }
    });
  }

  void createGroup() async {
    User? userDetails = await User.getUser(AppConst.getAccessToken());
    String generatedId = generateUid();
    String groupId = '${userDetails!.userfirstname}_$generatedId';

    await firebaseFirestore.collection('groups').doc().set({
      'id': groupId,
      'members': [AppConst.getAccessToken(), AppConst.getAccessToken()],
      'groupName': groupNameController.text,
      "groupIcon": "",
      // "groupIcon": File(groupIcon!.path),
      "admin": AppConst.getAccessToken(),
      "adminName": userDetails.userfirstname,
      "createdAt": Timestamp.now(),
      "isGroup": true,
      "recentMessage": "",
      "recentMsgSenderId": "",
    });

    await firebaseFirestore
        .collection('chat_rooms')
        .doc(groupId)
        .collection(
          'messages',
        )
        .add({});
    setState(() {
      selectedUser = [];
      isConfirm = false;
    });
  }

  Future<void> selectImagee() async {
    XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      groupIcon = File(pickedImage!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        iconTheme: const IconThemeData(size: 20),
        centerTitle: false,
        title: AppText(
          text: widget.createGroup! ? 'New Group' : 'New Chat',
          fontsize: 15,
          textColor: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          if (isConfirm) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: selectImagee,
                    child: CircleAvatar(
                      backgroundImage: groupIcon != null ? FileImage(groupIcon!) : null,
                      radius: 25,
                      child: groupIcon != null
                          ? null
                          : const Icon(
                              Icons.camera_alt_outlined,
                              size: 22,
                            ),
                    ),
                  ),
                  SizedBox(
                    width: width! * 3 / 4,
                    child: CustomTextInput(
                      controller: groupNameController,
                      labelText: 'Group Name',
                    ),
                  ),
                ],
              ),
            )
          ],
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 5),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: NewGroupUserList(
                users: widget.list!,
                selectedUser: selectedUser,
                toggleUser: (user) {
                  if (widget.createGroup!) {
                    toggleUser(user);
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => ChatScreen(user: user),
                      ),
                    );
                  }
                },
              ),
              // child: SizedBox(),
            ),
          ),
        ],
      ),
      floatingActionButton: widget.createGroup!
          ? FloatingActionButton(
              onPressed: () {
                if (selectedUser.isEmpty) {
                  fadedCustomSnackBar(context: context, text: 'At least 1 user must be selected');
                  return;
                }
                if (!isConfirm) {
                  setState(() {
                    isConfirm = true;
                  });
                  return;
                }
                if (groupIcon == null) {
                  fadedCustomSnackBar(context: context, text: 'Select a group icon');
                  return;
                }
                if (groupNameController.text == '') {
                  fadedCustomSnackBar(context: context, text: 'Enter group name');
                  return;
                }
                fadedCustomSnackBar(context: context, text: '${groupNameController.text} Group Created');
                createGroup();
                Navigator.of(context).pop();
              },
              backgroundColor: AppColor.primary,
              child: isConfirm ? const Icon(Icons.check) : const Icon(Icons.arrow_forward_outlined),
            )
          : null,
    );
  }
}
