import 'package:android_path_provider/android_path_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

Future<void> downloadFile(String url, String type, BuildContext context, Function callback) async {
  Dio dio = Dio();
  String? dir = "";
  DateTime currentTime = DateTime.now();
  final customFormat = DateFormat('yyyyMMddHHmmss');
  String formattedDateTime = customFormat.format(currentTime);

  try {
    try {
      dir = await AndroidPathProvider.downloadsPath;
    } catch (e) {
      final directory = await getExternalStorageDirectory();
      dir = directory?.path;
    }
    if (type.contains('image')) {
      dir = "$dir/$formattedDateTime.jpeg";
    } else if (type.contains('video')) {
      dir = "$dir/$formattedDateTime.mp4";
    } else {
      dir = "$dir/$formattedDateTime.pdf";
    }

    await dio.download(url, dir, onReceiveProgress: (rec, total) {
      var progress = "${((rec / total) * 100).toStringAsFixed(0)}%";
      callback(true, progress);
      // setState(() {
      //   downloading = true;
      //   progressString = "${((rec / total) * 100).toStringAsFixed(0)}%";
      // });
      // if(progressString == '100%'){}
      // customSnackBar(context: context, text: 'Download Completed');
    });
  } catch (e) {
    print(e);
    callback(false, "");
    // customSnackBar(context: context, text: 'Download Failed');

    // setState(() {
    //   downloading = false;
    //   progressString = "Download failed";
    // });
  }
}
