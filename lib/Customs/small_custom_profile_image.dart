import 'package:flutter/material.dart';

class SmallCustomCircularImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  const SmallCustomCircularImage({super.key, required this.imageUrl, this.height = 20, this.width = 20});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      height: height,
      width: width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.fill),
        borderRadius: BorderRadius.circular(40),
      ),
    );
  }
}
