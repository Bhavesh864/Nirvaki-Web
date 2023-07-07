import 'package:flutter/material.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/constants/colors.dart';

//-------------------------------------------TextformField-------------------------------------->
class CustomTextInput extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText;
  final Widget? label;
  final bool enabled;
  final String hintText;
  final IconData? leftIcon;
  final bool? obscureText;
  final bool? readonly;
  final IconData? rightIcon;
  final String? initialvalue;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final TextStyle? hintstyle;
  final FormFieldValidator<String>? validator;
  final Function(String)? onChanged;

  const CustomTextInput(
      {Key? key,
      required this.controller,
      this.labelText,
      required this.hintText,
      this.leftIcon,
      this.hintstyle = const TextStyle(color: Colors.grey),
      this.rightIcon,
      this.obscureText = false,
      this.keyboardType,
      this.onChanged,
      this.maxLength,
      this.validator,
      this.initialvalue,
      this.maxLines = 1,
      this.minLines = 1,
      this.readonly = false,
      this.label,
      this.enabled = true})
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
    return SizedBox(
      height: 50,
      child: TextFormField(
        enabled: widget.enabled,
        style: const TextStyle(
          color: AppColor.primary,
        ),
        controller: widget.controller,
        decoration: InputDecoration(
          label: widget.label,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
          labelText: widget.labelText,
          hintText: widget.hintText,
          hintStyle: widget.hintstyle,
          prefixIcon: widget.leftIcon != null ? Icon(widget.leftIcon) : null,
          suffixIcon: widget.rightIcon != null
              ? IconButton(
                  icon: Icon(widget.rightIcon),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText!;
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          isDense: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AppColor.primary,
            ),
          ),
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
  const CustomButton(
      {Key? key,
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
      this.textStyle})
      : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1.0,
      child: GestureDetector(
        onTapDown: (_) {
          setState(() {
            _isPressed = true;
          });
        },
        onTapUp: (_) {
          setState(() {
            _isPressed = false;
          });
          widget.onPressed();
        },
        onTapCancel: () {
          setState(() {
            _isPressed = false;
          });
        },
        child: Opacity(
          opacity: widget.opacity,
          child: Container(
            height: widget.height,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              // color: widget.buttonColor,
              color: widget.buttonColor.withOpacity(_isPressed ? 0.8 : 1.0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.leftIcon != null)
                  Icon(
                    widget.leftIcon,
                    color: widget.lefticonColor,
                  ),
                const SizedBox(width: 8.0),
                CustomText(
                  title: widget.text,
                  color: widget.textColor,
                  size: widget.fontsize!,
                ),
                if (widget.rightIcon != null)
                  Icon(
                    widget.rightIcon,
                    color: widget.righticonColor,
                  ),
              ],
            ),
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
      children: [
        Checkbox(
          fillColor: MaterialStatePropertyAll(widget.fillColor),
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
          )
      ],
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
