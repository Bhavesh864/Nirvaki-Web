import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/utils/colors.dart';

// class DropDownField extends StatefulWidget {
//   final String title;
//   final List optionsList;
//   final List<Map<String, dynamic>>? multipleValuesmap;
//   final void Function(Object e) onchanged;
//   final String? defaultValues;
//   final bool isMultiValueOnDropdownlist;
//   final FontWeight labelFontWeight;
//   final bool isMandatory;
//   final double labelFontSize;

//   const DropDownField({
//     super.key,
//     required this.title,
//     required this.optionsList,
//     required this.onchanged,
//     this.labelFontWeight = FontWeight.w500,
//     this.isMandatory = false,
//     this.labelFontSize = 16,
//     this.defaultValues,
//     this.isMultiValueOnDropdownlist = false,
//     this.multipleValuesmap,
//   });

//   @override
//   State<DropDownField> createState() => _DropDownFieldState();
// }

// class _DropDownFieldState extends State<DropDownField> {
//   String? errorText;
//   String? selectedValues;

//   @override
//   void initState() {
//     super.initState();
//     selectedValues = widget.defaultValues;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         RichText(
//           text: TextSpan(
//             children: [
//               TextSpan(
//                 text: widget.title,
//                 style: TextStyle(
//                   fontFamily: GoogleFonts.dmSans().fontFamily,
//                   color: Colors.black,
//                   fontSize: widget.labelFontSize,
//                   fontWeight: widget.labelFontWeight,
//                 ),
//               ),
//               if (widget.isMandatory)
//                 const TextSpan(
//                   text: ' ',
//                 ),
//               if (widget.isMandatory)
//                 const TextSpan(
//                   text: '*',
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.red,
//                   ),
//                 ),
//             ],
//           ),
//         ),
//         // CustomText(
//         //   fontWeight: FontWeight.w500,
//         //   color: Colors.black,
//         //   size: 16,
//         //   title: widget.title,
//         // ),
//         const SizedBox(height: 4),
//         DropdownButtonHideUnderline(
//           child: InputDecorator(
//             decoration: InputDecoration(
//               contentPadding: const EdgeInsets.all(0),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               isDense: true,
//             ),
//             child: DropdownButton(
//               // isDense: true,
//               enableFeedback: false,
//               // itemHeight: null,
//               focusColor: Colors.transparent,
//               hint: const CustomText(
//                 title: '--select--',
//                 color: Colors.grey,
//               ),
//               icon: const Icon(Icons.expand_more),
//               // isExpanded: true,
//               borderRadius: BorderRadius.circular(10),
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
//               value: selectedValues!.isEmpty ? null : selectedValues!,
//               onChanged: (e) {
//                 widget.onchanged(e!);
//                 setState(() {
//                   selectedValues = e;
//                 });
//               },
//               items: widget.optionsList.map((value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                   // child: Text(title: value, softWrap: true),
//                 );
//               }).toList(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

class CustomDropdownFormField<T> extends StatefulWidget {
  final String label;
  final String? hintText;
  final T? value;
  final List<dynamic> items;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;
  final IconData? righticon;
  final TextStyle? hintStyle;
  final String? title;
  final double labelFontSize;
  final FontWeight? labelFontWeight;
  final bool isMandatory;
  const CustomDropdownFormField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.righticon,
    this.hintText,
    this.hintStyle = const TextStyle(color: Colors.grey),
    this.title,
    this.labelFontSize = 16,
    this.labelFontWeight,
    this.isMandatory = false,
  });

  @override
  State<CustomDropdownFormField<T>> createState() => _CustomDropdownFormFieldState<T>();
}

class _CustomDropdownFormFieldState<T> extends State<CustomDropdownFormField<T>> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: widget.label,
                style: TextStyle(
                  fontFamily: GoogleFonts.dmSans().fontFamily,
                  color: Colors.black,
                  fontSize: widget.labelFontSize,
                  fontWeight: widget.labelFontWeight,
                ),
              ),
              if (widget.isMandatory)
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
        const SizedBox(height: 4),
        DropdownButtonFormField<T>(
          value: widget.value,
          isExpanded: true,
          borderRadius: BorderRadius.circular(10),
          isDense: true,
          padding: const EdgeInsets.all(0),
          focusColor: Colors.transparent,
          icon: const Icon(Icons.expand_more, color: Colors.transparent),
          items: widget.items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                '$item',
                softWrap: true,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            );
          }).toList(),
          onChanged: widget.onChanged,
          validator: widget.validator,
          decoration: InputDecoration(
            // isDense: widget.isDense,
            isDense: true,
            hoverColor: Colors.transparent,
            suffixIcon: const Icon(
              Icons.expand_more,
            ),
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
            hintText: "--Select--",
            hintStyle: widget.hintStyle,
            focusColor: Colors.transparent,
            fillColor: Colors.transparent,
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
        ),
      ],
    );
  }
}
