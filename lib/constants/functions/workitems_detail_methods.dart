import 'package:carousel_slider/carousel_slider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
                  height: 550,
                  initialPage: initialIndex,
                  enlargeCenterPage: true,
                  viewportFraction: 0.55,
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

void showUploadDocumentModal(BuildContext context, List<String> selectedDocName, PlatformFile? selectedImage, List<PlatformFile> pickedDocuments, Function onPressed) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, innerSetState) {
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
                      selectedDocName.add(value.toString());
                    },
                  ),
                  CustomButton(
                    text: selectedImage == null ? 'Upload Document' : selectedImage!.name.toString(),
                    rightIcon: Icons.publish_outlined,
                    buttonColor: AppColor.secondary,
                    // isBorder: false,
                    textColor: Colors.black,
                    righticonColor: Colors.black,
                    titleLeft: true,
                    onPressed: () async {
                      // XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                      // if (pickedImage != null) {
                      //   innerSetState(
                      //     () {
                      //       selectedImage = pickedImage;
                      //     },
                      //   );
                      //   pickedDocuments.add(pickedImage); // Add picked document to the list
                      // }

                      FilePickerResult? result = await FilePicker.platform.pickFiles();

                      if (result != null) {
                        innerSetState(() {
                          pickedDocuments.addAll(result.files);
                          selectedImage = result.files[0];
                        });
                        print(selectedImage!.name);
                      }
                    },
                  ),
                  CustomButton(
                    text: 'Done',
                    onPressed: () {
                      onPressed();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      });
    },
  );
}
