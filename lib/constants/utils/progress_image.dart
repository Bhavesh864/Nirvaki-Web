import 'package:flutter/material.dart';
import 'package:yes_broker/constants/utils/constants.dart';

class ProgressImage extends StatefulWidget {
  const ProgressImage({super.key, required this.url});
  final String url;

  @override
  State<ProgressImage> createState() => _ProgressImageState();
}

class _ProgressImageState extends State<ProgressImage> {
  @override
  Widget build(BuildContext context) {
    return Image.network(
      widget.url,
      frameBuilder: (_, image, loadingBuilder, __) {
        if (loadingBuilder == null) {
          return const SizedBox(
            height: 300,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return image;
      },
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
          ),
        );
      },
      errorBuilder: (_, __, ___) => Image.network(
        noImg,
        height: 300,
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
