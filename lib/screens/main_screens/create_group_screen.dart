import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yes_broker/chat/controller/group_controller.dart';

import 'package:yes_broker/customs/custom_fields.dart';
import 'package:yes_broker/customs/loader.dart';
import 'package:yes_broker/customs/snackbar.dart';
import 'package:yes_broker/customs/text_utility.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import '../../constants/firebase/Methods/fetch_user.dart';
import '../../constants/firebase/userModel/user_info.dart';
import '../../widgets/chat/group/newgroup_user_list.dart';
import 'chat_screen.dart';

final selectedGroupUsers = StateProvider<List<User>>((ref) => []);

class CreateGroupScreen extends ConsumerStatefulWidget {
  final bool? createGroup;
  const CreateGroupScreen({super.key, this.createGroup = true});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  Future<List<User>>? _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = fetchUsers();
  }

  // bool isConfirm = false;
  final groupNameController = TextEditingController();
  List<String> selectedUser = [];
  File? groupIcon;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  void toggleUser(User user) {
    setState(() {
      if (selectedUser.contains(user.userId)) {
        selectedUser.remove(user.userId);
      } else {
        selectedUser.add(user.userId);
      }
    });
    ref.read(selectedGroupUsers.notifier).update((state) => [...state, user]);
  }

  void createGroup() async {
    if (groupNameController.text.trim().isNotEmpty && groupIcon != null) {
      ref.read(groupControllerProvider).createGroup(
            context,
            groupNameController.text.trim(),
            groupIcon!,
            ref.read(selectedGroupUsers),
          );
      Navigator.of(context).pop();
      ref.read(selectedGroupUsers.notifier).update((state) => []);
    }
  }

  Future<void> _showImageSourceDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.pop(context); // Close the dialog
                  XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
                  if (image != null) {
                    setState(() {
                      groupIcon = File(image.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context); // Close the dialog
                  XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      groupIcon = File(image.path);
                    });
                  }
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _usersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        if (snapshot.hasData) {
          final filterUser = snapshot.data!;
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
                if (widget.createGroup!) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: _showImageSourceDialog,
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
                  ),
                ],
                StatefulBuilder(builder: (context, setstate) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 5),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: NewGroupUserList(
                        users: filterUser,
                        selectedUser: selectedUser,
                        toggleUser: (user) {
                          if (widget.createGroup!) {
                            toggleUser(user);
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => ChatScreen(
                                  name: '${user.userfirstname} ${user.userlastname}',
                                  profilePic: user.image,
                                  contactId: user.userId,
                                  isGroupChat: false,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  );
                }),
              ],
            ),
            floatingActionButton: widget.createGroup!
                ? FloatingActionButton(
                    onPressed: () {
                      if (selectedUser.isEmpty) {
                        fadedCustomSnackBar(context: context, text: 'At least 1 user must be selected');
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
                    },
                    backgroundColor: AppColor.primary,
                    child: const Icon(Icons.check),
                  )
                : null,
          );
        }
        return const SizedBox();
      },
    );
  }
}
