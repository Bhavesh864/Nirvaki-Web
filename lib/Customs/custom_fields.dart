import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:yes_broker/customs/custom_text.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/customs/responsive.dart';

import '../constants/utils/constants.dart';
import '../customs/text_utility.dart';

//-------------------------------------------TextformField-------------------------------------->
class CustomTextInput extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText;
  final double contentPadding;
  final VoidCallback? ontap;
  final Widget? label;
  final bool enabled;
  final FocusNode? focusnode;
  final String? hintText;
  final IconData? leftIcon;
  final bool? obscureText;
  final bool? readonly;
  final bool? autofocus;
  final IconData? rightIcon;
  final bool isDense;
  final String? initialvalue;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final Function(String text)? onFieldSubmitted;
  final TextStyle? hintstyle;
  final FormFieldValidator<String>? validator;
  final Function(String)? onChanged;
  final EdgeInsetsGeometry? margin;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final bool onlyDigits;

  const CustomTextInput(
      {Key? key,
      required this.controller,
      this.labelText,
      this.hintText,
      this.isDense = true,
      this.leftIcon,
      this.focusnode,
      this.ontap,
      this.hintstyle = const TextStyle(color: Colors.grey),
      this.rightIcon,
      this.obscureText = false,
      this.keyboardType,
      this.onChanged,
      this.maxLength,
      this.validator,
      this.initialvalue,
      this.textInputAction,
      this.maxLines = 1,
      this.minLines = 1,
      this.readonly = false,
      this.label,
      this.enabled = true,
      this.autofocus = false,
      this.contentPadding = 0,
      this.onFieldSubmitted,
      this.autofillHints,
      this.onlyDigits = false,
      this.margin = const EdgeInsets.all(5)})
      : super(key: key);

  @override
  CustomTextInputState createState() => CustomTextInputState();
}

class CustomTextInputState extends State<CustomTextInput> {
  bool? _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: TextFormField(
        inputFormatters: widget.onlyDigits
            ? <TextInputFormatter>[
                // FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                LengthLimitingTextInputFormatter(10),
              ]
            : null,
        autofocus: widget.autofocus!,
        textInputAction: widget.textInputAction ?? TextInputAction.done,
        focusNode: widget.focusnode,
        autofillHints: widget.autofillHints,
        enabled: widget.enabled,
        onTap: widget.ontap,
        onFieldSubmitted: widget.onFieldSubmitted,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontFamily: GoogleFonts.dmSans().fontFamily,
          fontSize: 12,
        ),
        controller: widget.controller,
        decoration: InputDecoration(
          isDense: widget.isDense,
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
          label: widget.label,
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          labelText: widget.labelText,
          hintText: widget.hintText,
          hintStyle: widget.hintstyle,
          prefixIcon: widget.leftIcon != null ? Icon(widget.leftIcon, color: Colors.black) : null,
          suffixIcon: widget.rightIcon != null
              ? IconButton(
                  icon: Icon(
                    widget.rightIcon,
                    color: Colors.black,
                  ),
                  iconSize: 18,
                  onPressed: widget.obscureText == true
                      ? () {
                          setState(() {
                            _obscureText = !_obscureText!;
                          });
                        }
                      : null,
                )
              : const Icon(
                  Icons.account_circle_outlined,
                  color: Colors.transparent,
                ),
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
        ),
        obscureText: _obscureText!,
        maxLength: widget.maxLength,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        validator: widget.validator,
        readOnly: widget.readonly!,
        initialValue: widget.initialvalue,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
      ),
    );
  }
}

//-----------------------------------------Button------------------------------------>

class CustomButton extends StatefulWidget {
  final String text;
  final bool? isBorder;
  final double? width;
  final bool titleLeft;
  final VoidCallback onPressed;
  final Color buttonColor;
  final Color textColor;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final Color lefticonColor;
  final Color righticonColor;
  final double opacity;
  final double? fontsize;
  final double height;
  final TextStyle? textStyle;
  final Color? borderColor;
  final EdgeInsets? padding;
  final FontWeight fontWeight;
  final double letterSpacing;
  final TextAlign textAlign;
  final bool? isAttachments;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.fontsize = 16,
    this.buttonColor = AppColor.primary,
    this.textColor = Colors.white,
    this.rightIcon,
    this.leftIcon,
    this.opacity = 1,
    this.righticonColor = Colors.white,
    this.lefticonColor = Colors.white,
    this.height = 50.0,
    this.textStyle,
    this.width,
    this.isBorder = true,
    this.borderColor = Colors.grey,
    this.titleLeft = false,
    this.fontWeight = FontWeight.w600,
    this.letterSpacing = 0,
    this.padding = const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8),
    this.textAlign = TextAlign.center,
    this.isAttachments = false,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          isPressed = false;
        });
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },
      child: Opacity(
        opacity: widget.opacity,
        child: Container(
          alignment: Alignment.center,
          height: widget.height,
          width: widget.width,
          padding: widget.padding,
          decoration: BoxDecoration(
            border: widget.isBorder! ? Border.all(color: widget.borderColor!) : null,
            color: widget.buttonColor,
            // color: widget.buttonColor.withOpacity(isPressed ? 0.8 : 1.0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: widget.titleLeft ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              if (widget.leftIcon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    widget.leftIcon,
                    color: widget.lefticonColor,
                    size: 24,
                  ),
                ),
              if (widget.isAttachments == false) ...[
                CustomText(
                  textAlign: TextAlign.center,
                  title: widget.text,
                  color: widget.textColor,
                  size: widget.fontsize!,
                  letterSpacing: widget.letterSpacing,
                  fontWeight: widget.fontWeight,
                ),
              ] else ...[
                SizedBox(
                  width: Responsive.isMobile(context) ? width! - 120 : 412,
                  child: Text(
                    widget.text,
                    textAlign: widget.textAlign,
                    style: TextStyle(
                      color: widget.textColor,
                      fontSize: widget.fontsize,
                      letterSpacing: widget.letterSpacing,
                      fontWeight: widget.fontWeight,
                    ),
                    softWrap: true,
                    maxLines: 1,
                  ),
                ),
              ],
              if (widget.titleLeft)
                const SizedBox(
                  width: 10,
                ),
              if (widget.rightIcon != null)
                Icon(
                  widget.rightIcon,
                  color: widget.righticonColor,
                  size: 18,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

//------------------------------------------- checkbox------------------------------------------?

class CustomCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final Color? fillColor;

  const CustomCheckbox({
    Key? key,
    required this.value,
    this.onChanged,
    this.label,
    this.fillColor,
  }) : super(key: key);

  @override
  CustomCheckboxState createState() => CustomCheckboxState();
}

class CustomCheckboxState extends State<CustomCheckbox> {
  bool _value = false;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  // checkboxlisttile -------------==
  // Theme(
  //   data: ThemeData(
  //       splashColor: Colors.transparent,
  //       highlightColor: Colors.transparent,
  //       hoverColor: Colors.transparent),
  //   child: ListTileTheme(
  //     horizontalTitleGap: 0,
  //     contentPadding: const EdgeInsets.all(0),
  //     child: CheckboxListTile(
  //       value: isChecked,
  //       dense: true,
  //       onChanged: (newVal) {
  //         setState(() {
  //           isChecked = newVal!;
  //         });
  //       },
  //       contentPadding: const EdgeInsets.only(bottom: 15),
  //       visualDensity:
  //           const VisualDensity(horizontal: 0, vertical: -4),
  //       fillColor: const MaterialStatePropertyAll(AppColor.primary),
  //       title:
  //           const CustomText(title: 'Use Same number for whatsapp'),
  //       controlAffinity: ListTileControlAffinity.leading,
  //       checkboxShape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(3),
  //       ),
  //     ),
  //   ),
  // ),

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          checkColor: Colors.white,
          // fillColor: MaterialStatePropertyAll(widget.fillColor),
          value: _value,
          onChanged: (value) {
            setState(() {
              _value = value!;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(value!);
            }
          },
        ),
        if (widget.label != null)
          CustomText(
            title: widget.label!,
            size: Responsive.isMobile(context) ? 14 : 16,
          ),
      ],
    );
  }
}

class CustomChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool isSmall;
  final Function(bool) onSelected;
  final Color? selectedColor;
  final Color? bgcolor;
  final Color labelColor;

  const CustomChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.selectedColor = AppColor.primary,
    required this.labelColor,
    this.bgcolor = AppColor.secondary,
    this.isSmall = true,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Container(
        constraints: BoxConstraints(
          minWidth: isSmall ? 80 : double.infinity,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: labelColor,
          ),
        ),
      ),
      selected: selected,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      labelPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      onSelected: onSelected,
      selectedColor: selectedColor,
      backgroundColor: bgcolor,
    );
  }
}

class CustomCheckboxListTile extends StatelessWidget {
  final void Function() onSelected;
  final bool isChecked;
  const CustomCheckboxListTile({
    super.key,
    required this.onSelected,
    this.isChecked = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7.0),
      child: GestureDetector(
        onTap: onSelected,
        child: Row(
          children: [
            Checkbox(
              value: isChecked,
              onChanged: (newVal) {
                onSelected();
              },
            ),
            const CustomText(title: 'Use Same number for whatsapp'),
          ],
        ),
      ),
    );
  }
}

// pickImage(ImageSource source) async {
//   final ImagePicker _imagePicker = ImagePicker();
//   XFile? _file = await _imagePicker.pickImage(source: source);
//   if (_file != null) {
//     return await _file.readAsBytes();
//   }
//   print('No Image Selected');
// }

class MobileNumberInputField extends StatefulWidget {
  const MobileNumberInputField({
    super.key,
    required this.isEmpty,
    required this.openModal,
    required this.countryCode,
    required this.onChange,
    required this.controller,
    required this.hintText,
    this.margin = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.validator,
    this.fontsize = 14.0,
    this.isMandatory = true,
    this.showLabel = true,
    this.isdense = true,
    this.contentpadding = EdgeInsets.zero,
    this.bottomMargin = const EdgeInsets.only(bottom: 0),
    this.fromProfile = false,
    this.innnerContainerPadding = const EdgeInsets.symmetric(vertical: 5),
  });
  final bool isEmpty;
  final bool isdense;
  final String countryCode;
  final String hintText;
  final double? fontsize;
  final bool? isMandatory;
  final bool? showLabel;
  final EdgeInsets? bottomMargin;
  final TextEditingController controller;
  final void Function() openModal;
  final void Function(String) onChange;
  final FormFieldValidator<String>? validator;
  final EdgeInsetsGeometry contentpadding;
  final bool? fromProfile;
  final EdgeInsets? innnerContainerPadding;
  final EdgeInsetsGeometry margin;
  @override
  State<MobileNumberInputField> createState() => _MobileNumberInputFieldState();
}

class _MobileNumberInputFieldState extends State<MobileNumberInputField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.showLabel == true)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                top: 2,
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.hintText,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        // fontWeight: FontWeight.w500//
                      ),
                    ),
                    const TextSpan(text: " "),
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
          ),
        Container(
          margin: widget.margin,
          decoration: BoxDecoration(
            border: Border.all(
              color: !widget.isEmpty ? Colors.grey : Colors.red,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: Responsive.isMobile(context) ? 4 : 10.0),
          child: Row(
            children: [
              InkWell(
                onTap: widget.openModal,
                child: Padding(
                  // padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                  padding: widget.fromProfile == true
                      ? const EdgeInsets.symmetric(horizontal: 5, vertical: 4)
                      : EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: Responsive.isMobile(context) ? 8 : 0,
                        ),
                  child: Row(
                    children: [
                      AppText(
                        text: widget.countryCode,
                        fontsize: kIsWeb ? 14 : 12,
                        // fontsize: widget.fontsize!,
                      ),
                      const Icon(
                        Icons.arrow_drop_down_outlined,
                      )
                    ],
                  ),
                ),
              ),
              if (widget.fromProfile == true) const SizedBox(width: 5),
              Expanded(
                child: Container(
                  height: kIsWeb ? 38 : 45,
                  padding: widget.fromProfile == true ? null : const EdgeInsets.symmetric(vertical: 5),
                  margin: widget.bottomMargin,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        maxLength: 10,
                        onChanged: (value) {
                          widget.onChange(value);
                        },
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12),
                        controller: widget.controller,
                        keyboardType: TextInputType.phone,
                        validator: widget.validator,
                        decoration: InputDecoration(
                          // suffixIcon: const Icon(
                          //   Icons.abc,
                          //   color: Colors.transparent,
                          // ),
                          isDense: widget.isdense,
                          hintText: "Type here..",
                          counterText: "",
                          hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                          contentPadding: widget.contentpadding,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
