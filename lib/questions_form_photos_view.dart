import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/pages/add_inventory.dart';

class PhotosViewForm extends ConsumerStatefulWidget {
  const PhotosViewForm({super.key});

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

  // Use a map to store the corresponding indexes of webImages and images lists.
  Map<String, int> imageIndexes = {};

  @override
  void initState() {
    final answersArr = ref.read(myArrayProvider.notifier).state;
    int numberOfItems = answersArr.length;
    itemTitles = ['Front Elevation'];

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
      return 'Bed Room $roomNumber($containerIndex)';
    } else if (itemId == 16) {
      return 'BathRoom $roomNumber($containerIndex)';
    } else if (itemId == 15) {
      return '${roomList[roomNumber - 1]} ($containerIndex)';
    }
    return 'BhAVESH';
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
          images[index] = File('a');
        });

        String base64String = base64Encode(f);
      }
    } else {
      if (pickedImage != null) {
        var selected = File(pickedImage.path);
        setState(() {
          images[index] = selected;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: numberOfColumns,
          crossAxisSpacing: 15,
          mainAxisSpacing: 10,
          mainAxisExtent: 140,
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
                  )
                : const CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
