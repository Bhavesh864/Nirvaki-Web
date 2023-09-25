// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../constants/utils/colors.dart';
import 'custom_fields.dart';

class LabelTextInputField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool isDropDown;
  final IconData rightIcon;
  final bool isDatePicker;
  final bool isMandatory;
  final int? maxLines;
  final TextInputType keyboardType;
  final TextEditingController inputController;
  final Function(String)? onChanged;
  final FormFieldValidator<String>? validator;
  final String? initialvalue;
  final bool onlyDigits;
  final bool readyOnly;
  const LabelTextInputField({
    Key? key,
    required this.labelText,
    this.hintText = 'Type here..',
    this.isDropDown = false,
    this.rightIcon = Icons.calendar_month,
    this.isDatePicker = false,
    this.isMandatory = false,
    this.maxLines,
    this.keyboardType = TextInputType.none,
    required this.inputController,
    this.onChanged,
    this.validator,
    this.initialvalue,
    this.onlyDigits = false,
    this.readyOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 7),
          child: RichText(
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
                    text: '*',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
          ),
        ),
        CustomTextInput(
          onlyDigits: onlyDigits,
          enabled: isDropDown
              ? false
              : isDatePicker
                  ? false
                  : true,
          rightIcon: isDropDown
              ? Icons.arrow_drop_down_sharp
              : isDatePicker
                  ? rightIcon
                  : null,
          controller: inputController,
          hintText: hintText,
          onChanged: onChanged,
          readonly: readyOnly,
          keyboardType: keyboardType,
          validator: validator,
          maxLines: maxLines,
          initialvalue: initialvalue,
          indense: true,
          contentPadding: 0,
        ),
      ],
    );
  }
}

class LabelTextAreaField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool isDropDown;
  final bool isDatePicker;
  final bool isMandatory;
  final int? maxLines;
  final TextEditingController inputController;
  final Function(String)? onChanged;
  final FormFieldValidator<String>? validator;
  final String? initialvalue;

  const LabelTextAreaField({
    Key? key,
    required this.labelText,
    this.hintText = 'Type here..',
    this.isDropDown = false,
    this.isDatePicker = false,
    this.isMandatory = true,
    this.maxLines,
    required this.inputController,
    this.onChanged,
    this.validator,
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
        TextFormField(
          textCapitalization: TextCapitalization.characters,
          validator: validator,
          keyboardType: TextInputType.multiline,
          maxLines: 5,
          controller: inputController,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: 'Type here...',
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColor.inputFieldBorderColor,
              ),
            ),
            // isDense: true,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColor.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
