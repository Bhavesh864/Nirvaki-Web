import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

Future<String?> getImageUrl(XFile image) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/image.png');
    await file.writeAsBytes(await image.readAsBytes());
    return file.uri.toString();
  } catch (e) {
    print(e);
  }
  return null;
}
