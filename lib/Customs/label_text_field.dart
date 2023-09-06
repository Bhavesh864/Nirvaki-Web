// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'custom_fields.dart';

class LabelTextInputField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool isDropDown;
  final bool isDatePicker;
  final bool isMandatory;
  final TextEditingController inputController;
  final Function(String)? onChanged;
  final FormFieldValidator<String>? validator;
  final String? initialvalue;

  const LabelTextInputField({
    Key? key,
    required this.labelText,
    this.hintText = 'Type here..',
    this.isDropDown = false,
    this.isDatePicker = false,
    required this.inputController,
    this.onChanged,
    this.validator,
    this.isMandatory = true,
    this.initialvalue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: labelText,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isMandatory)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
            ],
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
          initialvalue: initialvalue,
          indense: true,
          contentPadding: 0,
        ),
      ],
    );
  }
}
