import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commonFirebaseStorageRepositoryProvider = Provider(
  (ref) => CommonFirebaseStorageRepository(
    firebaseStorage: FirebaseStorage.instance,
  ),
);

class CommonFirebaseStorageRepository {
  final FirebaseStorage firebaseStorage;
  CommonFirebaseStorageRepository({
    required this.firebaseStorage,
  });

  Future<String> storeFileToFirebase(String ref, File? file, Uint8List? webImage) async {
    if (kIsWeb) {
      final metaData = SettableMetadata(contentType: 'image/jpeg');
      UploadTask uploadTask = firebaseStorage.ref().child(ref).putData(webImage!, metaData);
      TaskSnapshot snap = await uploadTask;

      String downloadUrl = await snap.ref.getDownloadURL();
      return downloadUrl;
    } else {
      UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file!);
      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();
      return downloadUrl;
    }
  }
}
