import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yes_broker/Customs/responsive.dart';

import '../../Customs/custom_fields.dart';
import '../../Customs/dropdown_field.dart';
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
            Expanded(
              child: CarouselSlider(
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

void uploadFileToFirebase(PlatformFile fileToUpload) async {
  print(fileToUpload);

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
  } catch (e) {
    print(e);
  }
}

void showUploadDocumentModal(
  BuildContext context,
  List<String> selectedDocName,
  PlatformFile? selectedFile,
  List<PlatformFile> pickedDocuments,
  Function onPressed,
) {
  String docName = '';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, innerSetState) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Container(
                padding: const EdgeInsets.all(15),
                height: 300,
                width: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      optionsList: const ['Adhaar card', 'Agreement', 'Insurance'],
                      onchanged: (value) {
                        docName = value.toString();
                      },
                    ),
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
                    CustomButton(
                      text: 'Done',
                      onPressed: () {
                        if (docName != '' && selectedFile != null) {
                          selectedDocName.add(docName);
                          uploadFileToFirebase(selectedFile!);
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
