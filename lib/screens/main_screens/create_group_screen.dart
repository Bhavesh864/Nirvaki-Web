import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/Customs/snackbar.dart';
import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/constants.dart';

import '../../constants/firebase/userModel/user_info.dart';
import '../../widgets/chat/group/newgroup_user_list.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key, this.list});

  final List<User>? list;
  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  var isConfirm = false;
  final groupNameController = TextEditingController();
  List<String> selectedUser = [];
  File? groupIcon;
  late Future<List<User>> userList;
  void toggleUser(String user) {
    if (selectedUser.contains(user)) {
      setState(() {
        selectedUser.remove(user);
      });
    } else {
      setState(() {
        selectedUser.add(user);
      });
    }
  }

  Future<void> selectImagee() async {
    XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      groupIcon = File(pickedImage!.path);
    });
  }

  @override
  void initState() {
    super.initState();
    userList = User.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        iconTheme: const IconThemeData(size: 20),
        centerTitle: false,
        title: const AppText(
          text: 'New Group',
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
                      backgroundImage:
                          groupIcon != null ? FileImage(groupIcon!) : null,
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
                  toggleUser(user);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedUser.isEmpty) {
            fadedCustomSnackBar(
                context: context, text: 'At least 1 user must be selected');
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
          fadedCustomSnackBar(
              context: context,
              text: '${groupNameController.text} Group Created');
          Navigator.of(context).pop();
          setState(() {
            selectedUser = [];
            isConfirm = false;
          });
        },
        backgroundColor: AppColor.primary,
        child: isConfirm
            ? const Icon(Icons.check)
            : const Icon(Icons.arrow_forward_outlined),
      ),
    );
  }
}
