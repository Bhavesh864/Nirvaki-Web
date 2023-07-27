// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'custom_fields.dart';
import 'custom_text.dart';

class LabelTextInputField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool isDropDown;
  final bool isDatePicker;
  final TextEditingController inputController;
  final Function(String)? onChanged;
  final FormFieldValidator<String>? validator;

  const LabelTextInputField({
    Key? key,
    required this.labelText,
    this.hintText = 'Type here..',
    this.isDropDown = false,
    this.isDatePicker = false,
    required this.inputController,
    this.onChanged,
    this.validator,
  }) : super(key: key);

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
          enabled: isDropDown
              ? false
              : isDatePicker
                  ? false
                  : true,
          rightIcon: isDropDown
              ? Icons.arrow_drop_down_sharp
              : isDatePicker
                  ? Icons.calendar_month
                  : null,
          controller: inputController,
          hintText: hintText,
          onChanged: onChanged,
          validator: validator,
          contentPadding: 4,
        ),
      ],
    );
  }
}
