import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yes_broker/customs/custom_text.dart';
import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/firebase/detailsModels/inventory_details.dart' as inventory;
import 'package:yes_broker/constants/firebase/detailsModels/lead_details.dart' as lead;
import 'package:yes_broker/constants/firebase/random_uid.dart';
import 'package:yes_broker/constants/utils/constants.dart';

import '../../customs/custom_fields.dart';
import '../../customs/dropdown_field.dart';
import '../../widgets/card/questions card/chip_button.dart';
import '../firebase/detailsModels/todo_details.dart';
import '../utils/colors.dart';

void showImageSliderCarousel(List<String> imageUrls, int initialIndex, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: const EdgeInsets.all(0),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: Responsive.isMobile(context) ? null : 550,
                initialPage: initialIndex,
                enlargeCenterPage: true,
                viewportFraction: Responsive.isMobile(context) ? 0.7 : 0.55,
                enableInfiniteScroll: false,
              ),
              items: imageUrls.map(
                (url) {
                  return Builder(
                    builder: (BuildContext context) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.network(
                          url,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  );
                },
              ).toList(),
            ),
            Positioned(
              top: -5,
              right: 10,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

void uploadAttachmentsToFirebaseStorage(PlatformFile fileToUpload, String id, String docname, Function updateState, String titleName) async {
  final uniqueKey = DateTime.now().microsecondsSinceEpoch.toString();

  Reference referenceRoot = FirebaseStorage.instance.ref();
  Reference referenceDirImages = referenceRoot.child('attachments');

  Reference referenceImagesToUpload = referenceDirImages.child(uniqueKey);

  try {
    if (kIsWeb) {
      await referenceImagesToUpload.putData(fileToUpload.bytes!);
    } else {
      await referenceImagesToUpload.putFile(File(fileToUpload.path!));
    }
    final downloadUrl = await referenceImagesToUpload.getDownloadURL();
    print('downloadurl.-------$downloadUrl');

    if (id.contains(ItemCategory.isInventory)) {
      inventory.Attachments attachments = inventory.Attachments(
        id: generateUid(),
        createdby: AppConst.getAccessToken(),
        createddate: Timestamp.now(),
        path: downloadUrl,
        title: titleName == '' ? docname : titleName,
        type: docname,
      );
      await inventory.InventoryDetails.addAttachmentToItems(itemid: id, newAttachment: attachments).then((value) => updateState());
    } else if (id.contains(ItemCategory.isLead)) {
      lead.Attachments attachments = lead.Attachments(
        id: generateUid(),
        createdby: AppConst.getAccessToken(),
        createddate: Timestamp.now(),
        path: downloadUrl,
        title: titleName == '' ? docname : titleName,
        type: docname,
      );

      await lead.LeadDetails.addAttachmentToItems(itemid: id, newAttachment: attachments).then((value) => updateState());
    } else if (id.contains(ItemCategory.isTodo)) {
      Attachments attachments = Attachments(
        id: generateUid(),
        createdby: AppConst.getAccessToken(),
        createddate: Timestamp.now(),
        path: downloadUrl,
        title: titleName == '' ? docname : titleName,
        type: docname,
      );
      await TodoDetails.addAttachmentToItems(itemid: id, newAttachment: attachments).then((value) => updateState());
    }
    // InventoryDetails.deleteAttachment(itemId: id, attachmentIdToDelete: "1");
  } catch (e) {
    print(e);
  }
}

void showUploadDocumentModal(
  BuildContext context,
  Function updateState,
  List<String> selectedDocName,
  PlatformFile? selectedFile,
  List<PlatformFile> pickedDocuments,
  Function onPressed,
  String id,
) {
  String docName = '';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      final TextEditingController titleController = TextEditingController();
      return StatefulBuilder(
        builder: (context, innerSetState) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Container(
                padding: const EdgeInsets.all(15),
                height: docName == 'Other' ? 400 : 300,
                width: Responsive.isMobile(context) ? width : 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Upload New Document',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          iconSize: 20,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    DropDownField(
                      title: 'Document Type',
                      defaultValues: "",
                      optionsList: const ['Adhaar card', 'Agreement', 'Insurance', 'Other'],
                      onchanged: (value) {
                        docName = value.toString();
                        innerSetState(
                          () {},
                        );
                      },
                    ),
                    if (docName == 'Other') ...[
                      const Padding(
                        padding: EdgeInsets.only(top: 3.0),
                        child: CustomText(
                          title: 'Title',
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: TextField(
                          controller: titleController,
                          decoration: const InputDecoration(hintText: 'Enter title'),
                        ),
                      ),
                    ],
                    CustomButton(
                      text: selectedFile == null ? 'Upload Document' : selectedFile!.name.toString(),
                      rightIcon: Icons.publish_outlined,
                      buttonColor: AppColor.secondary,
                      textColor: Colors.black,
                      righticonColor: Colors.black,
                      titleLeft: true,
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles();
                        if (result != null) {
                          innerSetState(() {
                            pickedDocuments.addAll(result.files);
                            selectedFile = result.files[0];
                          });
                        }
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CustomButton(
                      text: 'Done',
                      onPressed: () {
                        if (docName != '' && selectedFile != null) {
                          selectedDocName.add(docName);
                          uploadAttachmentsToFirebaseStorage(selectedFile!, id, docName, updateState, titleController.text);
                          onPressed();
                          selectedFile = null;
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

void showConfirmDeleteAttachment(BuildContext context, Function onPressYes) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          height: 240,
          width: 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Do you want to remove insurance document?',
                      style: TextStyle(fontSize: Responsive.isMobile(context) ? 22 : 26, fontWeight: FontWeight.bold),
                    ),
                  ),
                  InkWell(
                    child: const Icon(
                      Icons.close,
                      size: 22,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ChipButton(
                text: 'Yes',
                onSelect: () {
                  onPressYes();
                  Navigator.of(context).pop();
                },
              ),
              ChipButton(
                text: 'No',
                onSelect: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showOwnerDetailsAndAssignToBottomSheet(BuildContext context, String title, Widget innerContent) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
    ),
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 20,
                    color: AppColor.primary,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            innerContent,
          ],
        ),
      );
    },
  );
}
