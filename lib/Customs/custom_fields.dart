import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:yes_broker/customs/custom_text.dart';
import 'package:yes_broker/constants/utils/colors.dart';

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
  final bool? indense;
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
      this.indense,
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
                FilteringTextInputFormatter.digitsOnly,
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
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
        controller: widget.controller,
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
          label: widget.label,
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          labelText: widget.labelText,
          hintText: widget.hintText,
          hintStyle: widget.hintstyle,

          prefixIcon: widget.leftIcon != null ? Icon(widget.leftIcon) : null,
          suffixIcon: widget.rightIcon != null
              ? IconButton(
                  icon: Icon(widget.rightIcon),
                  iconSize: 18,
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText!;
                    });
                  },
                )
              : null,
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
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8),
          decoration: BoxDecoration(
            border: widget.isBorder! ? Border.all(color: widget.borderColor!) : null,
            color: widget.buttonColor,
            // color: widget.buttonColor.withOpacity(isPressed ? 0.8 : 1.0),
            borderRadius: BorderRadius.circular(10),
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
              CustomText(
                textAlign: TextAlign.center,
                title: widget.text,
                color: widget.textColor,
                size: widget.fontsize!,
              ),
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
            size: 16,
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
      labelPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
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
