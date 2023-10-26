import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reorderables/reorderables.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/Customs/snackbar.dart';
import 'package:yes_broker/constants/firebase/detailsModels/inventory_details.dart';
import 'package:yes_broker/riverpodstate/all_selected_ansers_provider.dart';
import '../../customs/text_utility.dart';

class PhotosViewForm extends ConsumerStatefulWidget {
  final Propertyphotos? propertyphotos;
  final AllChipSelectedAnwers? notify;
  final int id;
  final bool isEdit;
  final void Function()? onNext;
  const PhotosViewForm({this.notify, required this.id, this.propertyphotos, required this.isEdit, this.onNext, super.key});

  @override
  PhotosViewFormState createState() => PhotosViewFormState();
}

class PhotosViewFormState extends ConsumerState<PhotosViewForm> {
  List roomImages = [];
  List<String> selectedImagesUrlList = [];
  List<String> selectedImagesTitleList = [];
  int isEditingTodoName = -1;
  TextEditingController todoNameEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool dragMode = false;
  int? draggableItemIndex;

  void startEditingTodoName(String todoName, int index) {
    setState(() {
      isEditingTodoName = index;
      todoNameEditingController.text = todoName;
    });
  }

  void cancelEditingTodoName() {
    setState(() {
      roomImages[isEditingTodoName]["title"] = todoNameEditingController.text;
      selectedImagesTitleList[isEditingTodoName] = todoNameEditingController.text;
    });
    setState(() {
      isEditingTodoName = -1;
      todoNameEditingController.clear();
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      Propertyphotos propertyphotos = Propertyphotos(imageTitle: selectedImagesTitleList, imageUrl: selectedImagesUrlList);
      widget.notify!.add({
        'id': widget.id,
        'item': propertyphotos,
      });
    });
  }

  Future<void> selectImage() async {
    List<XFile>? pickedImages = await ImagePicker().pickMultiImage(imageQuality: 60);
    List list = [];
    if (pickedImages.isNotEmpty) {
      for (var i = 0; i < pickedImages.length; i++) {
        var webUrl = await pickedImages[i].readAsBytes();
        var imageUrl = File(pickedImages[i].path);
        var title = "Photo";
        final obj = {"title": title, "imageUrl": imageUrl, "webImageUrl": webUrl};

        if (kIsWeb) {
          uploadImageToFirebase(webUrl, title);
        } else {
          uploadImageToFirebase(imageUrl, title);
        }
        list.add(obj);
      }
      setState(() {
        roomImages = [...roomImages, ...list];
      });

      Future.delayed(const Duration(milliseconds: 1000), () {
        Propertyphotos propertyphotos = Propertyphotos(imageTitle: selectedImagesTitleList, imageUrl: selectedImagesUrlList);
        widget.notify!.add({
          'id': widget.id,
          'item': propertyphotos,
        });
      });
    }
  }

  void uploadImageToFirebase(imageUrl, imageTitle) async {
    final uniqueKey = DateTime.now().microsecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImagesToUpload = referenceDirImages.child(uniqueKey);

    try {
      if (kIsWeb) {
        final metaData = SettableMetadata(contentType: 'image/jpeg');
        await referenceImagesToUpload.putData(imageUrl, metaData);
      } else {
        await referenceImagesToUpload.putFile(imageUrl);
      }
      imageUrl = await referenceImagesToUpload.getDownloadURL();
      setState(() {
        selectedImagesUrlList.add(imageUrl);
        selectedImagesTitleList.add(imageTitle);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        if (todoNameEditingController.text != "") {
          cancelEditingTodoName();
        } else {
          FocusScope.of(context).requestFocus(focusNode);
          customSnackBar(context: context, text: 'Field cannot be empty');
        }
      }
    });

    if (widget.propertyphotos != null && widget.propertyphotos!.imageTitle!.isNotEmpty) {
      List list = [];
      setState(() {
        selectedImagesTitleList.addAll(widget.propertyphotos!.imageTitle!);
        selectedImagesUrlList.addAll(widget.propertyphotos!.imageUrl!);
      });
      for (var i = 0; i < widget.propertyphotos!.imageTitle!.length; i++) {
        var title = widget.propertyphotos!.imageTitle![i];
        var imageUrl = widget.propertyphotos!.imageUrl![i];
        final obj = {"title": title, "imageUrl": imageUrl, "webImageUrl": imageUrl};
        list.add(obj);
      }
      setState(() {
        roomImages = [...list];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SingleChildScrollView(
        physics: Responsive.isMobile(context) ? const ScrollPhysics() : const NeverScrollableScrollPhysics(),
        child: Container(
          alignment: Alignment.topLeft,
          constraints: const BoxConstraints(
            minHeight: 0,
          ),
          padding: const EdgeInsets.all(10),
          child: LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = (constraints.maxWidth / 120).floor();
              return ReorderableWrap(
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    final item = roomImages.removeAt(oldIndex);
                    roomImages.insert(newIndex, item);
                    setState(() {
                      final titleItem = selectedImagesTitleList.removeAt(oldIndex);
                      selectedImagesTitleList.insert(newIndex, titleItem);
                    });
                    final urlItem = selectedImagesUrlList.removeAt(oldIndex);
                    selectedImagesUrlList.insert(newIndex, urlItem);
                  });

                  Future.delayed(const Duration(milliseconds: 500), () {
                    Propertyphotos propertyphotos = Propertyphotos(imageTitle: selectedImagesTitleList, imageUrl: selectedImagesUrlList);
                    widget.notify!.add({
                      'id': widget.id,
                      'item': propertyphotos,
                    });
                  });
                },
                needsLongPressDraggable: false,
                maxMainAxisCount: crossAxisCount,
                scrollDirection: Axis.horizontal,
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 10,
                runSpacing: 10,
                children: List.generate(
                  roomImages.length + 1,
                  (index) {
                    if (index < roomImages.length) {
                      return Stack(
                        key: const ValueKey('Enable drag'),
                        children: [
                          Column(
                            children: [
                              Card(
                                clipBehavior: Clip.antiAlias,
                                elevation: 2,
                                shadowColor: Colors.grey[300],
                                child: index > selectedImagesTitleList.length - 1
                                    ? Container(
                                        width: constraints.maxWidth / crossAxisCount - 20,
                                        height: constraints.maxWidth / crossAxisCount - 45,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: Responsive.isDesktop(context) ? 10 : 6),
                                          child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: Center(
                                                  child: CircularProgressIndicator.adaptive(
                                                strokeWidth: Responsive.isDesktop(context) ? 4 : 2,
                                              ))),
                                        ),
                                      )
                                    : SizedBox(
                                        width: constraints.maxWidth / crossAxisCount - 20,
                                        height: constraints.maxWidth / crossAxisCount - 45,
                                        child: roomImages[index]["webImageUrl"].contains("https")
                                            ? Image.network(
                                                roomImages[index]["webImageUrl"]!,
                                                fit: BoxFit.fill,
                                              )
                                            : kIsWeb
                                                ? Image.memory(
                                                    roomImages[index]["webImageUrl"]!,
                                                    fit: BoxFit.fill,
                                                  )
                                                : Image.file(
                                                    roomImages[index]["imageUrl"]!,
                                                    fit: BoxFit.fill,
                                                  ),
                                      ),
                              ),
                              const SizedBox(height: 4),
                              Wrap(
                                runSpacing: 10,
                                children: [
                                  isEditingTodoName == index
                                      ? SizedBox(
                                          width: constraints.maxWidth / crossAxisCount - 40,
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                              hintText: 'Type here...',
                                              hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                                              isDense: true,
                                            ),
                                            focusNode: focusNode,
                                            controller: todoNameEditingController,
                                            autofocus: true,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            onFieldSubmitted: (newValue) {
                                              todoNameEditingController.text = newValue;
                                              Future.delayed(const Duration(milliseconds: 300)).then((value) => {
                                                    if (newValue != "")
                                                      {cancelEditingTodoName(), FocusScope.of(context).requestFocus(focusNode)}
                                                    else
                                                      {FocusScope.of(context).requestFocus(focusNode), customSnackBar(context: context, text: 'Field cannot be empty')}
                                                  });
                                            },
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            if (index > selectedImagesTitleList.length - 1) {
                                              return;
                                            }
                                            startEditingTodoName("${roomImages[index]["title"]}", index);
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              if (roomImages[index]["title"].length > 16) ...[
                                                SizedBox(
                                                  width: constraints.maxWidth / crossAxisCount - 30,
                                                  child: CustomText(
                                                    title: "${roomImages[index]["title"]} ",
                                                    size: 14,
                                                    softWrap: true,
                                                  ),
                                                ),
                                              ] else ...[
                                                CustomText(
                                                  title: "${roomImages[index]["title"]} ",
                                                  size: 14,
                                                  softWrap: true,
                                                ),
                                              ],
                                              const SizedBox(
                                                width: 2,
                                              ),
                                              const Icon(
                                                Icons.edit,
                                                size: 18,
                                                color: Colors.black,
                                              )
                                            ],
                                          ),
                                        ),
                                ],
                              ),
                            ],
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  roomImages.remove(roomImages[index]);
                                  selectedImagesTitleList.remove(selectedImagesTitleList[index]);
                                  selectedImagesUrlList.remove(selectedImagesUrlList[index]);
                                });
                                Future.delayed(const Duration(milliseconds: 1000), () {
                                  Propertyphotos propertyphotos = Propertyphotos(imageTitle: selectedImagesTitleList, imageUrl: selectedImagesUrlList);
                                  widget.notify!.add({
                                    'id': widget.id,
                                    'item': propertyphotos,
                                  });
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                                child: const Icon(
                                  Icons.close,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return ReorderableWidget(
                        key: const ValueKey('Disable drag'),
                        reorderable: false,
                        child: GestureDetector(
                          onLongPress: () {},
                          onTap: () {
                            selectImage();
                          },
                          child: Column(
                            children: [
                              Card(
                                clipBehavior: Clip.antiAlias,
                                elevation: 2,
                                shadowColor: Colors.grey[300],
                                child: SizedBox(
                                    width: constraints.maxWidth / crossAxisCount - 20,
                                    height: constraints.maxWidth / crossAxisCount - 45,
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add_circle_outline_outlined, size: 40, color: Colors.grey),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        AppText(
                                          text: 'Add Photos',
                                          fontsize: 15,
                                          textColor: Colors.black,
                                        )
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
