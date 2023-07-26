import 'package:flutter/material.dart';

import 'custom_fields.dart';
import 'custom_text.dart';

class LabelTextInputField extends StatelessWidget {
  const LabelTextInputField({
    super.key,
    required this.inputController,
    required this.labelText,
    this.isDropDown = false,
    this.onChanged,
    this.validator,
  });

  final String labelText;
  final bool isDropDown;
  final TextEditingController inputController;
  final Function(String)? onChanged;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4, right: 8, left: 2),
          child: CustomText(
            title: labelText,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.left,
          ),
        ),
        CustomTextInput(
          // indense: true,
          enabled: isDropDown ? false : true,
          rightIcon: isDropDown ? Icons.arrow_drop_down_sharp : null,
          controller: inputController,
          hintText: 'Type here..',
          onChanged: onChanged,
          validator: validator,
          contentPadding: 4,
        ),
      ],
    );
  }
}
