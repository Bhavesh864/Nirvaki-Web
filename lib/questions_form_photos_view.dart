import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/controllers/all_selected_ansers_provider.dart';
import 'package:yes_broker/pages/add_inventory.dart';

class PhotosViewForm extends ConsumerStatefulWidget {
  final AllChipSelectedAnwers? notify;
  final int id;
  const PhotosViewForm(this.notify, this.id, {super.key});

  @override
  _PhotosViewFormState createState() => _PhotosViewFormState();
}

class _PhotosViewFormState extends ConsumerState<PhotosViewForm> {
  List<Uint8List?> webImages = [];
  int numberOfColumns = 5;
  List<File?> images = [];
  List<String> itemTitles = [];
  bool isInitialized = false;

  final Set<String> roomsWithTwoImages = {};

  final Map<String, int> containersCountByRoom = {};

  List<Widget> imageContainers = [];

  String imageUrl = '';

  List<String> selectedImagesUrlList = [];

  @override
  void initState() {
    final answersArr = ref.read(myArrayProvider.notifier).state;
    itemTitles = [
      'Front Elevation',
    ];

    final selectedAnswerArr = answersArr.where((item) => item['id'] == 14 || item['id'] == 15 || item['id'] == 16).toList();

    for (var item in selectedAnswerArr) {
      int itemId = item['id'];
      dynamic roomItems = item['item'];

      if (roomItems is String) {
        for (int i = 1; i <= int.parse(roomItems); i++) {
          itemTitles.add(getItemTitle(itemId, i, containersCountByRoom[itemTitles[itemTitles.length - 1]] ?? 1, []));

          // Update the count of containers added for the room
          containersCountByRoom[itemTitles[itemTitles.length - 1]] = (containersCountByRoom[itemTitles[itemTitles.length - 1]] ?? 1) + 1;

          if (!roomsWithTwoImages.contains(itemTitles[itemTitles.length - 1])) {
            itemTitles.add(getItemTitle(itemId, i, containersCountByRoom[itemTitles[itemTitles.length - 1]] ?? 1, []));

            // Mark the room as having two images
            roomsWithTwoImages.add(itemTitles[itemTitles.length - 1]);
          }
        }
      } else if (roomItems is List<String>) {
        for (int i = 0; i < roomItems.length; i++) {
          itemTitles.add(getItemTitle(itemId, i + 1, containersCountByRoom[itemTitles[itemTitles.length - 1]] ?? 1, roomItems));

          // Update the count of containers added for the room
          containersCountByRoom[itemTitles[itemTitles.length - 1]] = (containersCountByRoom[itemTitles[itemTitles.length - 1]] ?? 1) + 1;

          if (!roomsWithTwoImages.contains(itemTitles[itemTitles.length - 1])) {
            itemTitles.add(getItemTitle(itemId, i + 1, containersCountByRoom[itemTitles[itemTitles.length - 1]] ?? 1, roomItems));

            // Mark the room as having two images
            roomsWithTwoImages.add(itemTitles[itemTitles.length - 1]);
          }
        }
      }
    }

    webImages = List.generate(itemTitles.length, (index) => null);
    images = List.generate(itemTitles.length, (index) => null);
    isInitialized = true;
    imageContainers = List.generate(itemTitles.length, (index) => getImageContainer(index));

    super.initState();
  }

  String getItemTitle(int itemId, int roomNumber, int containerIndex, List<String> roomList) {
    if (itemId == 14) {
      return 'Bed Room$roomNumber ($containerIndex)';
    } else if (itemId == 16) {
      return 'BathRoom$roomNumber ($containerIndex)';
    } else if (itemId == 15) {
      return '${roomList[roomNumber - 1]} ($containerIndex)';
    }
    return '';
  }

  Widget getImageContainer(int index) {
    return Column(
      children: [
        Card(
          child: SizedBox(
            width: 106,
            height: 100,
            child: webImages[index] == null
                ? const Icon(Icons.photo_rounded, size: 70, color: Colors.grey)
                : kIsWeb
                    ? Image.memory(
                        webImages[index]!,
                        fit: BoxFit.fill,
                      )
                    : Image.file(
                        images[index]!,
                        fit: BoxFit.fill,
                      ),
          ),
        ),
        const SizedBox(height: 4),
        CustomText(
          title: itemTitles[index],
          size: 14,
        ),
      ],
    );
  }

  Future<void> selectImage(int index) async {
    XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (kIsWeb) {
      if (pickedImage != null) {
        var f = await pickedImage.readAsBytes();

        setState(() {
          webImages[index] = f;
          images[index] = null;
        });

        print('for Web  ' + pickedImage.path);

        uploadImageToFirebase(index, f);

        // String base64String = base64Encode(f);
      }
    } else {
      if (pickedImage != null) {
        File selected = File(pickedImage.path);

        setState(() {
          images[index] = selected;
          webImages[index] = null;
        });
        print('for mobile  ' + pickedImage.path);

        uploadImageToFirebase(index, selected);
      }
    }
  }

  void uploadImageToFirebase(int index, dataToPut) async {
    final uniqueKey = DateTime.now().microsecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    Reference referenceImagesToUpload = referenceDirImages.child(uniqueKey);

    try {
      if (kIsWeb) {
        await referenceImagesToUpload.putData(dataToPut);
      } else {
        await referenceImagesToUpload.putFile(dataToPut);
      }
      imageUrl = await referenceImagesToUpload.getDownloadURL();
      selectedImagesUrlList.add(imageUrl);
      widget.notify!.add({'id': widget.id, 'item': selectedImagesUrlList});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: Responsive.isMobile(context) ? const ScrollPhysics() : const NeverScrollableScrollPhysics(),
      child: Container(
        constraints: BoxConstraints(
          minHeight: 0,
          maxHeight: Responsive.isMobile(context) ? 450 : 600,
        ),
        padding: const EdgeInsets.all(10),
        child: LayoutBuilder(builder: (context, constraints) {
          int crossAxisCount = (constraints.maxWidth / 120).floor();
          return GridView.builder(
            // scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: 145,
            ),
            itemCount: itemTitles.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectImage(index);
                  });
                },
                child: isInitialized
                    ? Column(
                        children: [
                          Card(
                            clipBehavior: Clip.antiAlias,
                            elevation: 2,
                            shadowColor: Colors.grey[300],
                            child: SizedBox(
                              width: constraints.maxWidth / crossAxisCount - 20,
                              height: constraints.maxWidth / crossAxisCount - 45,
                              child: kIsWeb
                                  ? webImages[index] == null
                                      ? const Icon(Icons.photo_rounded, size: 70, color: Colors.grey)
                                      : Image.memory(
                                          webImages[index]!,
                                          fit: BoxFit.fill,
                                        )
                                  : images[index] == null
                                      ? const Icon(Icons.photo_rounded, size: 70, color: Colors.grey)
                                      : Image.file(
                                          images[index]!,
                                          fit: BoxFit.fill,
                                        ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          CustomText(
                            title: itemTitles[index],
                            size: 14,
                          ),
                        ],
                      )
                    : const CircularProgressIndicator(),
              );
            },
          );
        }),
      ),
    );
  }
}
