// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

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
  final FutureOr<String?> Function(PhoneNumber?)? phonenumberValidator;

  const LabelTextInputField({
    Key? key,
    required this.labelText,
    this.labelFontWeight = FontWeight.w500,
    this.hintText = 'Type here..',
    this.isDropDown = false,
    this.rightIcon = Icons.calendar_month,
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
    this.phonenumberValidator,
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
                  style: TextStyle(
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
        isPhoneNumberField
            ? Container(
                margin: const EdgeInsets.only(
                  right: 7,
                  left: 7,
                  top: 4,
                ),
                child: IntlPhoneField(
                  inputFormatters: <TextInputFormatter>[
                    // FilteringTextInputFormatter.digitsOnly,
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColor.inputFieldBorderColor,
                          )),
                      errorStyle: const TextStyle(height: 0),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red, width: 1),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      hintText: hintText,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColor.inputFieldBorderColor,
                          )),
                      // isDense: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColor.primary,
                        ),
                      ),
                      errorMaxLines: 1,
                      enabled: false),
                  initialCountryCode: 'IN',
                  validator: phonenumberValidator,
                  onChanged: (phone) => onChanged!(phone.completeNumber),
                ),
              )
            : CustomTextInput(
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
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
            textCapitalization: TextCapitalization.characters,
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
