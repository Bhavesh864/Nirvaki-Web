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

  @override
  void initState() {
    super.initState();
    initializeLists();
  }

  void initializeLists() {
    final answersArr = ref.read(myArrayProvider.notifier).state;
    int numberOfItems = answersArr.length;
    itemTitles = ['Front Elevation'];
    itemTitles.addAll(List.generate(numberOfItems, (index) => 'Bed Room(${index + 1})'));

    print('itemTiles length --- ${itemTitles.length}');

    webImages = List.generate(itemTitles.length, (index) => null);
    images = List.generate(itemTitles.length, (index) => null);
    print('webimages length --- ${webImages.length}');
    isInitialized = true;
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
            child: images[index] == null
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

  @override
  Widget build(BuildContext context) {
    final answersArr = ref.watch(myArrayProvider.notifier).state;

    final selectedAnswerArr = answersArr.where((item) => item['id'] == 14 || item['id'] == 15 || item['id'] == 16).toList();

    final Set<String> roomsWithTwoImages = {};

    final Map<String, int> containersCountByRoom = {};

    List<Widget> imageContainers = [];
    imageContainers.add(getImageContainer(0));

    for (var item in selectedAnswerArr) {
      int itemId = item['id'];
      dynamic roomItems = item['item'];

      if (roomItems is String) {
        for (int i = 1; i <= int.parse(roomItems); i++) {
          itemTitles.add(getItemTitle(itemId, i, containersCountByRoom[itemTitles[itemTitles.length - 1]] ?? 1, []));
          webImages.add(null);
          images.add(null);
          imageContainers.add(getImageContainer(itemTitles.length - 1));

          // Update the count of containers added for the room
          containersCountByRoom[itemTitles[itemTitles.length - 1]] = (containersCountByRoom[itemTitles[itemTitles.length - 1]] ?? 1) + 1;

          if (!roomsWithTwoImages.contains(itemTitles[itemTitles.length - 1])) {
            itemTitles.add(getItemTitle(itemId, i, containersCountByRoom[itemTitles[itemTitles.length - 1]] ?? 1, []));
            webImages.add(null);
            images.add(null);
            imageContainers.add(getImageContainer(itemTitles.length - 1));

            // Mark the room as having two images
            roomsWithTwoImages.add(itemTitles[itemTitles.length - 1]);
          }
        }

        // Check if the room already has two images, if not, add another container
      } else if (roomItems is List<String>) {
        for (int i = 0; i < roomItems.length; i++) {
          itemTitles.add(getItemTitle(itemId, i + 1, containersCountByRoom[itemTitles[itemTitles.length - 1]] ?? 1, roomItems));
          webImages.add(null);
          images.add(null);
          imageContainers.add(getImageContainer(itemTitles.length - 1));

          // Update the count of containers added for the room
          containersCountByRoom[itemTitles[itemTitles.length - 1]] = (containersCountByRoom[itemTitles[itemTitles.length - 1]] ?? 1) + 1;

          // Check if the room already has two images, if not, add another container
          if (!roomsWithTwoImages.contains(itemTitles[itemTitles.length - 1])) {
            itemTitles.add(getItemTitle(itemId, i + 1, containersCountByRoom[itemTitles[itemTitles.length - 1]] ?? 1, roomItems));
            webImages.add(null);
            images.add(null);
            imageContainers.add(getImageContainer(itemTitles.length - 1));

            // Mark the room as having two images
            roomsWithTwoImages.add(itemTitles[itemTitles.length - 1]);
          }
        }
      }
    }
    print(webImages[1]);

    Future<void> selectImage(int index) async {
      XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (kIsWeb) {
        if (pickedImage != null) {
          var f = await pickedImage.readAsBytes();

          setState(() {
            webImages[index] = f;
            images[index] = File('a');
          });

          // print(webImages[0]);
          print(index);

          // String base64String = base64Encode(f);
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
        itemCount: imageContainers.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              selectImage(index);
            },
            child: isInitialized ? imageContainers[index] : const CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
