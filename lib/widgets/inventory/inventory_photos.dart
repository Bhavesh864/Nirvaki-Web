import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerContainer extends StatefulWidget {
  final Function(File) onImageSelected;
  final Function(Uint8List)? webImageSelected;
  const ImagePickerContainer({super.key, required this.onImageSelected, required this.webImageSelected});

  @override
  ImagePickerContainerState createState() => ImagePickerContainerState();
}

class ImagePickerContainerState extends State<ImagePickerContainer> {
  File? _imageFile;
  Uint8List webImage = Uint8List(8);
  Future<void> _pickImage(ImageSource source) async {
    if (!kIsWeb) {
      final ImagePicker pickedImage = ImagePicker();
      XFile? image = await pickedImage.pickVideo(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        setState(() {
          _imageFile = selected;
          widget.onImageSelected(_imageFile!);
        });
      } else {
        print('No image selected.');
      }
    } else if (kIsWeb) {
      final ImagePicker pickedImage = ImagePicker();
      XFile? image = await pickedImage.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          webImage = f;
          _imageFile = File("a");
          widget.webImageSelected!(f);
        });
      } else {
        print('No image selected.');
      }
    } else {
      print("something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _pickImage(ImageSource.gallery);
        // showModalBottomSheet(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return SafeArea(
        //       child: Wrap(
        //         children: <Widget>[
        //           ListTile(
        //             leading: const Icon(Icons.photo_library),
        //             title: const Text('Photo Library'),
        //             onTap: () {
        //               _pickImage(ImageSource.gallery);
        //               Navigator.pop(context);
        //             },
        //           ),
        //           ListTile(
        //             leading: const Icon(Icons.camera_alt),
        //             title: const Text('Camera'),
        //             onTap: () {
        //               _pickImage(ImageSource.camera);
        //               Navigator.pop(context);
        //             },
        //           ),
        //         ],
        //       ),
        //     );
        //   },
        // );
      },
      child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: _imageFile == null
              ? Icon(Icons.add_photo_alternate, size: 50, color: Colors.grey[800])
              : kIsWeb
                  ? Image.memory(webImage, fit: BoxFit.fill)
                  : Image.file(_imageFile!, fit: BoxFit.fill)),
    );
  }
}
