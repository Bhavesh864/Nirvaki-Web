import 'package:flutter/material.dart';

import 'custom_fields.dart';
import 'custom_text.dart';

class LabelTextInputField extends StatelessWidget {
  const LabelTextInputField({
    super.key,
    required this.inputController,
    required this.labelText,
    this.isDropDown = false,
  });

  final String labelText;
  final bool isDropDown;
  final TextEditingController inputController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 8, left: 2),
            child: CustomText(
              title: labelText,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(
            height: 40,
            child: CustomTextInput(
              // indense: true,
              enabled: isDropDown ? false : true,
              rightIcon: isDropDown ? Icons.arrow_drop_down_sharp : null,
              controller: inputController,
              hintText: labelText,
            ),
          ),
        ],
      ),
    );
  }
}
