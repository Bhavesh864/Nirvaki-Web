import 'package:flutter/material.dart';

import '../../constants/utils/image_constants.dart';

class CustomAppLogo extends StatelessWidget {
  const CustomAppLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Image.asset(
        appLogo,
        width: 60,
        height: 60,
      ),
    );
  }
}
