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

  @override
  void initState() {
    final answersArr = ref.read(myArrayProvider.notifier).state;

    int numberOfItems = answersArr.length;
    itemTitles = ['Front Elevation'];
    itemTitles.addAll(List.generate(numberOfItems, (index) => 'Bed Room(${index + 1})'));
    webImages = List.generate(itemTitles.length, (index) => null);
    images = List.generate(itemTitles.length, (index) => null);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final answersArr = ref.watch(myArrayProvider.notifier).state;

    final selectedAnswerArr = answersArr.where((item) => item['id'] == 41 || item['id'] == 42 || item['id'] == 43).toList();

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
        itemCount: selectedAnswerArr.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              selectImage(index);
            },
            child: Column(
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
            ),
          );
        },
      ),
    );
  }
}
