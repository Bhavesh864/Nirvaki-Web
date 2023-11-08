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
import 'package:yes_broker/chat/enums/message.enums.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/customs/custom_fields.dart';
import 'package:yes_broker/customs/loader.dart';
import 'package:yes_broker/customs/text_utility.dart';
import 'package:yes_broker/riverpodstate/chat/message_selection_state.dart';
import 'package:yes_broker/screens/main_screens/chat_screens/chat_list_screen.dart';
import '../../../chat/controller/chat_controller.dart';
import '../../../constants/firebase/userModel/user_info.dart';
import '../../../widgets/chat/group/newgroup_user_list.dart';

final selectedGroupUsers = StateProvider<List<User>>((ref) => []);

class ChatForwardScreen extends ConsumerStatefulWidget {
  final Function? goToChatList;
  final Function? goToChatScreen;

  const ChatForwardScreen({
    super.key,
    this.goToChatList,
    this.goToChatScreen,
  });

  @override
  ConsumerState<ChatForwardScreen> createState() => _ChatForwardScreenState();
}

class _ChatForwardScreenState extends ConsumerState<ChatForwardScreen> {
  final groupNameController = TextEditingController();
  List<String> selectedUsers = [];
  File? groupIcon;
  Uint8List? groupIconWeb;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  void toggleUse(ChatItem user) {
    if (selectedUsers.contains(user.id)) {
      selectedUsers.remove(user.id);
    } else {
      if (selectedUsers.length == 5) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Limit Reached"),
              content: const Text("You can only share with up to 5 chats."),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            );
          },
        );
      } else {
        selectedUsers.add(user.id);
      }
    }
  }

  void createGroup() async {
    if (groupNameController.text.trim().isNotEmpty) {
      ref.read(groupControllerProvider).createGroup(
            context,
            groupNameController.text.trim(),
            groupIcon,
            ref.read(selectedGroupUsers),
            groupIconWeb,
          );
      Navigator.of(context).pop();
      ref.read(selectedGroupUsers.notifier).update((state) => []);
    }
  }

  void onPressSendButton() {
    // print(ref.read(selectedMessageProvider));

    print(selectedUsers);
    // selectedUsers.map((userId) => {
    //       ref.read(selectedMessageProvider).map((msgData) => {
    //             if (msgData.type == MessageEnum.text)
    //               {
    //                 ref.read(chatControllerProvider).sendTextMessage(
    //                       context,
    //                       msgData.text,
    //                       userId,
    //                       widget.isGroupChat,
    //                     ),
    //               }
    //             else
    //               {
    //                 ref.read(chatControllerProvider).sendFileMessage(
    //                       context,
    //                       file,
    //                       widget.revceiverId,
    //                       messageEnum,
    //                       widget.isGroupChat,
    //                       webImage,
    //                     ),
    //               }
    //           }),
    //     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: mergeChatContactsAndGroups(ref),
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
                    title: const AppText(
                      text: 'Forward to...',
                      fontsize: 15,
                      textColor: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  body: Column(
                    children: [
                      StatefulBuilder(
                        builder: (context, setstate) {
                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(top: 5),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: GroupAndUsersMergedListToForward(
                                users: filterUser,
                                selectedUser: selectedUsers,
                                toggleUser: (user) {
                                  setstate(
                                    () {
                                      toggleUse(user);
                                    },
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      onPressSendButton();
                    },
                    backgroundColor: AppColor.primary,
                    child: const Icon(Icons.send),
                  ));
            } else {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          widget.goToChatList!();
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 22,
                        ),
                      ),
                      const AppText(
                        text: 'New Chat',
                        fontsize: 15,
                        textColor: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
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
                  StatefulBuilder(builder: (context, setstate) {
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 5),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: GroupAndUsersMergedListToForward(
                            users: filterUser,
                            selectedUser: selectedUsers,
                            toggleUser: (user) {
                              setstate(
                                () {
                                  toggleUse(user);
                                },
                              );
                            }),
                      ),
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        onPressSendButton();
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
      ),
    );
  }
}
