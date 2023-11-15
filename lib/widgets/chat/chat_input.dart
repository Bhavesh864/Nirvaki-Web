// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/Customs/snackbar.dart';
import 'package:yes_broker/constants/utils/colors.dart';

import '../../chat/controller/chat_controller.dart';
import '../../chat/enums/message.enums.dart';
import '../../chat/pick_methods.dart';
import '../../riverpodstate/chat/message_sending_loader.dart';

Future<Uint8List> convertPlatformFileToFile(PlatformFile platformFile) async {
  final fileBytes = platformFile.bytes;

  if (fileBytes != null) {
    final file = File(platformFile.name);

    return file.readAsBytes();
    // return file;
  }

  throw Exception("Failed to convert PlatformFile to File");
}

class ChatInput extends ConsumerStatefulWidget {
  final String revceiverId;
  final bool isGroupChat;

  const ChatInput({
    super.key,
    required this.revceiverId,
    required this.isGroupChat,
  });

  @override
  ConsumerState<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends ConsumerState<ChatInput> with SingleTickerProviderStateMixin {
  final TextEditingController messageController = TextEditingController();
  bool isShowEmojiContainer = false;
  FocusNode focusNode = FocusNode();
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      // reverseDuration: const Duration(seconds: 1),
    )..repeat();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // Use a different curve for the upward motion
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void showKeyboard() => focusNode.requestFocus();

  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  void sendTextMessage() {
    if (messageController.text.trim().isNotEmpty) {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            messageController.text.trim(),
            widget.revceiverId,
            widget.isGroupChat,
            messageType: MessageEnum.text,
          );
    }
    messageController.clear();
    focusNode.unfocus();
  }

  void sendFileMessage(
    File? file,
    MessageEnum messageEnum,
    FilePickerResult? webImage,
  ) {
    ref.read(messageSendingProvider.notifier).state = true;
    ref.read(chatControllerProvider).sendFileMessage(
          context,
          file,
          widget.revceiverId,
          messageEnum,
          widget.isGroupChat,
          webImage,
        );
  }

  // void selectImage() async {
  //   File? image = await pickImageFromGallery(context);
  //   if (image != null) {
  //     sendFileMessage(image, MessageEnum.image);
  //   }
  // }

  // void selectVideo() async {
  //   File? video = await pickVideoFromGallery(context);
  //   if (video != null) {
  //     sendFileMessage(video, MessageEnum.video);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final isMessageSending = ref.watch(messageSendingProvider);

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: Responsive.isDesktop(context)
                ? const BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  )
                : null,
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 6),
          child: Row(
            children: [
              InkWell(
                onTap: toggleEmojiKeyboardContainer,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    !isShowEmojiContainer ? Icons.mood : Icons.keyboard_outlined,
                    size: 16,
                  ),
                ),
              ),
              Expanded(
                child: RawKeyboardListener(
                  focusNode: FocusNode(),
                  onKey: (RawKeyEvent event) {
                    if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
                      sendTextMessage();
                    }
                  },
                  child: TextField(
                    textInputAction: TextInputAction.send,
                    focusNode: focusNode,
                    controller: messageController,
                    minLines: 1,
                    maxLines: 7,
                    textCapitalization: TextCapitalization.sentences,
                    autocorrect: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: 'Start typing...',
                      hintStyle: TextStyle(
                        fontFamily: GoogleFonts.dmSans().fontFamily,
                        fontSize: 12,
                        letterSpacing: 0.3,
                        color: const Color(0xFF666668),
                      ),
                    ),
                    onSubmitted: (_) {
                      sendTextMessage();
                    },
                  ),
                ),
              ),
              if (isMessageSending) ...[
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0.0, -_animation.value * 13.0), // Adjust the bounce height
                        child: const Icon(
                          Icons.upload,
                          size: 32.0,
                          color: AppColor.primary, // Customize color as needed
                        ),
                      );
                    },
                  ),
                ),
              ] else ...[
                InkWell(
                  onTap: () async {
                    if (!Responsive.isMobile(context)) {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.any,
                        allowMultiple: false,
                      );

                      // final Uint8List file = await convertPlatformFileToFile(result.files[0]);

                      // // return;

                      // print(file);

                      // final File file = File(result!.files.first.name);

                      // print(result!.files.first.bytes);

                      sendFileMessage(null, MessageEnum.file, result);

                      // XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
                      // if (image != null) {
                      //   var f = await image.readAsBytes();

                      //   sendFileMessage(null, MessageEnum.image, f);
                      // }
                    } else {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (builder) => bottomSheet(context),
                      );
                    }
                    // if (kIsWeb) {
                    //   XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
                    //   if (image != null) {
                    //     var f = await image.readAsBytes();

                    //     sendFileMessage(null, MessageEnum.image, f);
                    //   }
                    // } else {
                    //   final image = await pickImageFromGallery(context);

                    //   sendFileMessage(image!, MessageEnum.image, null);
                    // }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Icon(
                      Icons.attach_file_rounded,
                      size: 16,
                    ),
                  ),
                ),
                InkWell(
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(
                      Icons.send_outlined,
                      size: 16,
                    ),
                  ),
                  onTap: () {
                    sendTextMessage();
                  },
                ),
              ]
            ],
          ),
        ),
        isShowEmojiContainer
            ? SizedBox(
                height: 255,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    messageController.text = messageController.text + emoji.emoji;
                  },
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  Widget bottomSheet(context) {
    return SizedBox(
      height: 250,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // iconCreation(Icons.folder, Colors.indigo, "Files", context),
                  iconCreation(Icons.insert_drive_file, Colors.indigo, "Document", context),
                  const SizedBox(
                      // width: 40,
                      ),
                  iconCreation(Icons.insert_photo, Colors.purple, "Gallery", context),
                  const SizedBox(
                      // width: 40,
                      ),
                  iconCreation(Icons.camera_alt, Colors.pink, "Camera", context),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // iconCreation(Icons.headset, Colors.orange, "Audio", context),
                  const SizedBox(
                    width: 30,
                  ),
                  // iconCreation(Icons.location_pin, Colors.teal, "Location", context),
                  iconCreation(Icons.headset, Colors.orange, "Video", context),
                  // iconCreation(Icons.person, Colors.blue, "Contact", context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(IconData icons, Color color, String text, BuildContext context) {
    return InkWell(
      onTap: () async {
        Navigator.of(context).pop();

        if (text == 'Gallery') {
          final File? image = await pickImageFromGaller(context);
          if (image != null) {
            sendFileMessage(image, MessageEnum.image, null);
          }
        }
        if (text == 'Video') {
          final File? image = await pickVideoFromGallery(context);
          if (image != null) {
            sendFileMessage(image, MessageEnum.video, null);
          }
        }
        if (text == 'Camera') {
          XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);

          if (image != null && await image.length() > 10 * 1024 * 1024) {
            sendFileMessage(File(image.path), MessageEnum.image, null);
          } else {
            customSnackBar(context: context, text: 'Image should be less then 10MB');
          }
        } else if (text == 'Document') {
          final file = await pickDocument(context);

          if (file != null) {
            sendFileMessage(file, MessageEnum.file, null);
          }
        }
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: color,
            child: Icon(
              icons,
              // semanticLabel: "Help",
              size: 25,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              // fontWeight: FontWeight.w100,
            ),
          )
        ],
      ),
    );
  }
}

Future<File?> pickDocument(BuildContext context) async {
  final FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    final PlatformFile platformFile = result.files.single;

    // Check the size of the document
    if (platformFile.size > 50 * 1024 * 1024) {
      // 50MB limit
      // Handle the size limit exceeded
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("File Size Limit Exceeded"),
            content: const Text("The selected document is too large. Please choose a smaller document."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      return null;
    }

    return File(platformFile.path!);
  }

  return null;
}

Future<File?> pickImageFromGaller(BuildContext context) async {
  final imagePicker = ImagePicker();
  final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    final File imageFile = File(image.path);

    if (await imageFile.length() > 10 * 1024 * 1024) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("File Size Limit Exceeded"),
            content: const Text("The selected image is too large. Please choose a smaller image less than 10MB."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      return null;
    }

    return imageFile;
  }

  return null;
}
