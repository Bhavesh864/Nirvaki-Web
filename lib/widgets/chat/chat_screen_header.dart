// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/Customs/snackbar.dart';
import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/constants/functions/chat_group/group.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/customs/custom_text.dart';
import 'package:yes_broker/screens/main_screens/chat_list_screen.dart';
import 'package:yes_broker/screens/main_screens/chat_user_profile.dart';
import 'package:yes_broker/widgets/chat/group/leave_delete_group_button.dart';

import '../../chat/controller/chat_controller.dart';
import '../../chat/enums/message.enums.dart';
import '../../chat/models/message.dart';

class ChatScreenHeader extends ConsumerStatefulWidget {
  final ChatItem? chatItem;
  final User? user;
  final Function? showProfileScreen;
  final Function? goToChatList;
  final List<String>? selectedMessageList;
  final bool? selectedMode;
  final Function? removeAllItems;
  final Function? removeItem;
  final Function? toggleSelectedMode;
  final List<ChatMessage>? dataList;

  const ChatScreenHeader({
    Key? key,
    this.chatItem,
    this.user,
    this.showProfileScreen,
    this.goToChatList,
    this.selectedMessageList,
    this.selectedMode,
    this.removeAllItems,
    this.removeItem,
    this.toggleSelectedMode,
    this.dataList,
  }) : super(key: key);

  @override
  ConsumerState<ChatScreenHeader> createState() => _ChatScreenHeaderState();
}

class _ChatScreenHeaderState extends ConsumerState<ChatScreenHeader> {
  User? userInfo;

  void getUserDetails() async {
    final user = await User.getUser(widget.chatItem?.id ?? widget.user!.userId);
    setState(() {
      userInfo = user;
    });
  }

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String chatItemId = widget.chatItem?.id ?? widget.user?.userId ?? '';
    final bool isGroupChat = widget.chatItem?.isGroupChat ?? false;
    final String name = widget.chatItem?.name ?? '${widget.user?.userfirstname} ${widget.user?.userlastname}';
    final String profilePic = widget.chatItem?.profilePic ?? widget.user?.image ?? '';
    final String adminId = widget.chatItem?.adminId ?? '';
    // final messgeForwardMode = ref.watch(messgeForwardModeProvider);
    // final selectedMessageIndex = ref.watch(selectedMessageProvider);

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(chatItemId).snapshots(includeMetadataChanges: true),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final dataList = snapshot.data!.data();
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (Responsive.isMobile(context)) {
                          Navigator.of(context).pop();
                          // ref.read(messgeForwardModeProvider.notifier).setForwardMode(false);
                          // ref.read(selectedMessageProvider.notifier).setToEmpty();
                        } else {
                          widget.goToChatList!();
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.arrow_back,
                          size: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    !widget.selectedMode!
                        ? GestureDetector(
                            onTap: () {
                              if (Responsive.isMobile(context)) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => ChatUserProfile(
                                      profilePic: profilePic,
                                      name: name,
                                      user: userInfo,
                                      isGroupChat: isGroupChat,
                                      adminId: adminId,
                                      contactId: chatItemId,
                                    ),
                                  ),
                                );
                              } else {
                                widget.showProfileScreen!(userInfo);
                              }
                            },
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(
                                      profilePic.isEmpty ? noImg : profilePic,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      text: name,
                                      textColor: const Color.fromRGBO(44, 44, 46, 1),
                                      fontWeight: FontWeight.w600,
                                      fontsize: 16,
                                    ),
                                    if (!isGroupChat) ...[
                                      AppText(
                                        text: dataList!['isOnline'] ? "Online" : 'Offline',
                                        textColor: AppColor.grey,
                                        fontWeight: FontWeight.w500,
                                        fontsize: 12,
                                        maxLines: 1,
                                      ),
                                    ] else
                                      ...[]
                                  ],
                                ),
                              ],
                            ),
                          )
                        : CustomText(title: widget.selectedMessageList!.length.toString()),
                  ],
                ),
                if (widget.selectedMode!) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          customConfirmationAlertDialog(
                            context,
                            () {
                              ref.read(chatControllerProvider).deleteTextMessage(
                                    context,
                                    chatItemId,
                                    isGroupChat,
                                    widget.selectedMessageList!,
                                  );

                              widget.removeAllItems!();
                              Navigator.of(context).pop();
                            },
                            'Delete message',
                            'Are you sure want to delete?',
                            'Delete for me',
                          );
                        },
                        child: const Icon(
                          Icons.delete,
                          size: 22,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      if (widget.selectedMessageList!.length < 2) ...[
                        InkWell(
                          onTap: () async {
                            final selectedMsg = widget.dataList!.firstWhere((element) => element.messageId == widget.selectedMessageList![0]);
                            if (selectedMsg.type == MessageEnum.text) {
                              await Clipboard.setData(ClipboardData(text: selectedMsg.text));
                              widget.removeAllItems!();
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 1),
                                  backgroundColor: Colors.grey.shade600,
                                  behavior: SnackBarBehavior.floating,
                                  content: const Text(
                                    'Copied to clipboard.',
                                    textAlign: TextAlign.center,
                                  ),
                                  margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 60),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              customSnackBar(context: context, text: 'You can only copy text...');
                            }
                          },
                          child: const Icon(
                            Icons.copy,
                            size: 22,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                      const InkWell(
                        child: Icon(
                          Icons.shortcut,
                          size: 22,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      InkWell(
                        onTap: () {
                          widget.removeAllItems!();
                        },
                        child: const Icon(
                          Icons.close,
                          size: 22,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                ] else ...[
                  if (isGroupChat)
                    LeaveDeleteGroupPopupButton(
                      contactId: chatItemId,
                      adminId: adminId,
                    ),
                ],
              ],
            );
          }
          return const SizedBox();
        });
  }
}
