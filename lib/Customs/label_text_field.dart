// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/utils/colors.dart';
import 'custom_fields.dart';

class LabelTextInputField extends StatelessWidget {
  final String labelText;
  final FontWeight labelFontWeight;
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
  final bool isPhoneNumberField;
  final EdgeInsetsGeometry margin;

  const LabelTextInputField({
    Key? key,
    required this.labelText,
    this.labelFontWeight = FontWeight.w500,
    this.margin = const EdgeInsets.symmetric(horizontal: 7, vertical: 0),
    this.hintText = 'Type here..',
    this.isDropDown = false,
    this.rightIcon = Icons.calendar_month_outlined,
    this.isDatePicker = false,
    this.isMandatory = false,
    this.maxLines,
    this.keyboardType = TextInputType.name,
    required this.inputController,
    this.onChanged,
    this.validator,
    this.initialvalue,
    this.onlyDigits = false,
    this.readyOnly = false,
    this.isPhoneNumberField = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: margin,
            padding: const EdgeInsets.only(bottom: 2),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: labelText,
                    style: TextStyle(
                      fontFamily: GoogleFonts.dmSans().fontFamily,
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: labelFontWeight,
                    ),
                  ),
                  if (isMandatory)
                    const TextSpan(
                      text: ' ',
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
            margin: margin,
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
            isDense: true,
          ),
        ],
      ),
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
  final FontWeight fontWeight;

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
    this.fontWeight = FontWeight.w600,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: labelText,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: fontWeight,
                  ),
                ),
                if (isMandatory)
                  const TextSpan(
                    text: ' ',
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
          const SizedBox(height: 3),
          TextFormField(
            textCapitalization: TextCapitalization.sentences,
            validator: validator,
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            controller: inputController,
            onChanged: onChanged,
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
      ),
    );
  }
}
