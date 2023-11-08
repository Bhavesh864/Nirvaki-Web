import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/chat/models/chat_group.dart';

import 'package:yes_broker/chat/models/message.dart';
import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import '../enums/message.enums.dart';
import '../models/chat_contact.dart';
import '../repositories/chat_repositories.dart';

final chatControllerProvider = Provider(
  (ref) {
    final chatRepository = ref.watch(chatRepositoryProvider);
    return ChatController(
      chatRepository: chatRepository,
      ref: ref,
    );
  },
);

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<ChatMessage>> chatStream(String recieverUserId) {
    return chatRepository.getChatStream(recieverUserId);
  }

  Stream<List<ChatGroup>> chatGroups() {
    return chatRepository.getChatGroups();
  }

  Stream<List<ChatMessage>> groupChatStream(String groupId) {
    return chatRepository.getGroupChatStream(groupId);
  }

  void sendTextMessage(BuildContext context, String text, String receiverId, bool isGroupChat, {MessageEnum? messageType}) async {
    final User? user = await User.getUser(AppConst.getAccessToken());
    // ignore: use_build_context_synchronously
    chatRepository.sendTextMessage(
      context: context,
      message: text,
      receiverId: receiverId,
      senderUser: user!,
      isGroupChat: isGroupChat,
      profilePic: user.image,
      messageType: messageType,
      // messageReply: messageReply,
    );
    // ref.read(messageReplyProvider.state).update((state) => null);
  }

  void deleteTextMessage(
    BuildContext context,
    String docId,
    bool isGroupChat,
    List<String> messageId,
  ) async {
    // ignore: use_build_context_synchronously
    chatRepository.deleteTextMessage(
      context: context,
      docId: docId,
      isGroupChat: isGroupChat,
      messageId: messageId,
    );
  }

  void sendFileMessage(
    BuildContext context,
    File? file,
    String recieverUserId,
    MessageEnum messageEnum,
    bool isGroupChat,
    Uint8List? webImages,
  ) async {
    // ref.read(userDataAuthProvider).whenData(
    final User? user = await User.getUser(AppConst.getAccessToken());

    // ignore: use_build_context_synchronously
    chatRepository.sendFileMessage(
      context: context,
      file: file,
      recieverUserId: recieverUserId,
      senderUserData: user!,
      messageEnum: messageEnum,
      ref: ref,
      isGroupChat: isGroupChat,
      webImage: webImages,
    );
  }

  // void sendGIFMessage(
  //   BuildContext context,
  //   String gifUrl,
  //   String recieverUserId,
  //   bool isGroupChat,
  // ) {
  //   final messageReply = ref.read(messageReplyProvider);
  //   int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
  //   String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
  //   String newgifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';

  //   ref.read(userDataAuthProvider).whenData(
  //         (value) => chatRepository.sendGIFMessage(
  //           context: context,
  //           gifUrl: newgifUrl,
  //           recieverUserId: recieverUserId,
  //           senderUser: value!,
  //           messageReply: messageReply,
  //           isGroupChat: isGroupChat,
  //         ),
  //       );
  //   ref.read(messageReplyProvider.state).update((state) => null);
  // }

  void setChatMessageSeen(
    BuildContext context,
    String recieverUserId,
    String messageId,
    bool isSender,
  ) {
    chatRepository.setChatMessageSeens(
      context,
      recieverUserId,
      messageId,
      isSender,
    );
  }

  void setLastMessageSeen(
    BuildContext context,
    String recieverUserId,
    bool isGroupChat,
    String? groupId,
  ) {
    chatRepository.setLastMessageSeen(
      context,
      recieverUserId,
      isGroupChat,
      groupId,
    );
  }

  void setUserState(bool isOnline) {
    User.setUserOnlineStatus(isOnline);
  }
}
