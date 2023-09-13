// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yes_broker/Customs/responsive.dart';

import 'package:yes_broker/chat/controller/group_controller.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/customs/custom_fields.dart';
import 'package:yes_broker/customs/loader.dart';
import 'package:yes_broker/customs/snackbar.dart';
import 'package:yes_broker/customs/text_utility.dart';

import '../../constants/firebase/Methods/fetch_user.dart';
import '../../constants/firebase/userModel/user_info.dart';
import '../../widgets/chat/group/newgroup_user_list.dart';
import 'chat_screen.dart';

final selectedGroupUsers = StateProvider<List<User>>((ref) => []);

class CreateGroupScreen extends ConsumerStatefulWidget {
  final bool? createGroup;
  final String? alreadySelectedUser;

  const CreateGroupScreen({
    super.key,
    this.createGroup,
    this.alreadySelectedUser,
  });

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  Future<List<User>>? _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = fetchUsers(ref);
    if (widget.alreadySelectedUser != null) {
      selectedUsers.add(widget.alreadySelectedUser!);
    }
  }

  final groupNameController = TextEditingController();
  List<String> selectedUsers = [];
  File? groupIcon;
  Uint8List? groupIconWeb;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  void toggleUser(User user) {
    final selectedUserssState = ref.read(selectedGroupUsers.notifier);

    setState(() {
      if (selectedUsers.contains(user.userId)) {
        selectedUsers.remove(user.userId);
        selectedUserssState.update((state) {
          state.remove(user);
          return state;
        });
      } else {
        selectedUsers.add(user.userId);
        ref.read(selectedGroupUsers.notifier).update((state) => [...state, user]);
      }
    });
  }

  void createGroup() async {
    if (groupNameController.text.trim().isNotEmpty) {
      ref.read(groupControllerProvider).createGroup(
            context,
            groupNameController.text.trim(),
            null,
            ref.read(selectedGroupUsers),
            groupIconWeb,
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

  void onPressCreateGroupButton() {
    if (selectedUsers.isEmpty) {
      fadedCustomSnackBar(context: context, text: 'At least 1 user must be selected');
      return;
    }
    if (groupIcon == null && groupIconWeb == null) {
      fadedCustomSnackBar(context: context, text: 'Select a group icon');
      return;
    }
    if (groupNameController.text == '') {
      fadedCustomSnackBar(context: context, text: 'Enter group name');
      return;
    }
    createGroup();
    fadedCustomSnackBar(context: context, text: '${groupNameController.text} Group Created');
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

          if (Responsive.isMobile(context)) {
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
                          selectedUser: selectedUsers,
                          toggleUser: (user) {
                            if (widget.createGroup!) {
                              toggleUser(user);
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => ChatScreen(
                                    user: user,
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
                        onPressCreateGroupButton();
                      },
                      backgroundColor: AppColor.primary,
                      child: const Icon(Icons.check),
                    )
                  : null,
            );
          } else {
            return Column(
              children: [
                if (widget.createGroup!) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
                            if (image != null) {
                              var f = await image.readAsBytes();

                              setState(() {
                                groupIconWeb = f;
                              });
                            }
                          },
                          child: CircleAvatar(
                            backgroundImage: groupIconWeb != null ? MemoryImage(groupIconWeb!) : null,
                            radius: 25,
                            child: groupIconWeb != null
                                ? null
                                : const Icon(
                                    Icons.camera_alt_outlined,
                                    size: 22,
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: 250,
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
                        selectedUser: selectedUsers,
                        toggleUser: (user) {
                          if (widget.createGroup!) {
                            toggleUser(user);
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => ChatScreen(
                                  user: user,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      onPressCreateGroupButton();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          text: 'Create Group',
                          textColor: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontsize: 17,
                        ),
                        SizedBox(width: 8.0),
                        Icon(
                          Icons.group_add_outlined,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        }
        return const SizedBox();
      },
    );
  }
}
