// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'dart:typed_data';
// import 'package:flutter/foundation.dart' show kIsWeb;

// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart' as path;

// final FirebaseStorage storage = FirebaseStorage.instance;

// Future<List<String>> uploadImagesAndGetDownloadUrls(List<dynamic> images, String uniqueId, String category) async {
//   List<String> downloadUrls = [];
//   for (var image in images) {
//     String fileName;
//     Uint8List imageData;
//     if (image is Uint8List) {
//       imageData = image;
//       fileName = '${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';
//     } else if (image is XFile) {
//       imageData = await image.readAsBytes();
//       fileName = path.basename(image.path);
//     } else {
//       // Unsupported type
//       throw Exception('Unsupported image type');
//     }

//     String storagePath;

//     if (kIsWeb) {
//       // Web platform
//       storagePath = 'images/$uniqueId/$category/$fileName';
//     } else {
//       // Mobile platform (Android/iOS)
//       storagePath = 'images/$uniqueId/$category/$fileName';
//     }

//     Reference storageReference = FirebaseStorage.instance.ref().child(storagePath);
//     UploadTask uploadTask = storageReference.putData(imageData);
//     TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
//     String url = await snapshot.ref.getDownloadURL();

//     downloadUrls.add(url);
//   }
//   return downloadUrls;
// }

// Future<List<String>> uploadImagesAndGetDownloadUrlss({required List<File> images, required String uniqueId, required String category, required folderName}) async {
//   List<String> downloadUrls = [];
//   for (var image in images) {
//     String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//     String path = '$folderName/$uniqueId/$category/$fileName';
//     Reference storageReference = storage.ref().child(path);
//     UploadTask uploadTask = storageReference.putFile(image);
//     TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
//     String url = await snapshot.ref.getDownloadURL();
//     downloadUrls.add(url);
//   }
//   return downloadUrls;
// }
