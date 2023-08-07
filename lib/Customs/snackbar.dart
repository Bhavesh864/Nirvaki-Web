import 'package:flutter/material.dart';
import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/utils/colors.dart';

customSnackBar({required BuildContext context, required String text}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: AppColor.primary,
      content: AppText(
        text: text,
        textColor: Colors.white,
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      dismissDirection: DismissDirection.endToStart,
      margin: const EdgeInsets.only(bottom: 50, left: 10, right: 10),
      duration: const Duration(milliseconds: 3000),
    ),
  );
}
