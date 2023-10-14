import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yes_broker/Customs/text_utility.dart';

import 'custom_text.dart';

class DropDownField extends StatefulWidget {
  final String title;
  final List optionsList;
  final List<Map<String, dynamic>>? multipleValuesmap;
  final void Function(Object e) onchanged;
  final String? defaultValues;
  final bool isMultiValueOnDropdownlist;
  final FontWeight labelFontWeight;
  final bool isMandatory;
  final double labelFontSize;

  const DropDownField({
    super.key,
    required this.title,
    required this.optionsList,
    required this.onchanged,
    this.labelFontWeight = FontWeight.w500,
    this.isMandatory = false,
    this.labelFontSize = 16,
    this.defaultValues,
    this.isMultiValueOnDropdownlist = false,
    this.multipleValuesmap,
  });

  @override
  State<DropDownField> createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<DropDownField> {
  String? errorText;
  String? selectedValues;

  @override
  void initState() {
    super.initState();
    selectedValues = widget.defaultValues;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: widget.title,
                style: TextStyle(
                  fontFamily: GoogleFonts.dmSans().fontFamily,
                  color: Colors.black,
                  fontSize: widget.labelFontSize,
                  fontWeight: widget.labelFontWeight,
                ),
              ),
              if (widget.isMandatory)
                const TextSpan(
                  text: ' ',
                ),
              if (widget.isMandatory)
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
        // CustomText(
        //   fontWeight: FontWeight.w500,
        //   color: Colors.black,
        //   size: 16,
        //   title: widget.title,
        // ),
        const SizedBox(height: 4),
        DropdownButtonHideUnderline(
          child: InputDecorator(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              isDense: true,
            ),
            child: DropdownButton(
              // isDense: true,
              enableFeedback: false,
              // itemHeight: null,
              focusColor: Colors.transparent,
              hint: const CustomText(
                title: '--select--',
                color: Colors.grey,
              ),
              icon: const Icon(Icons.expand_more),
              isExpanded: true,
              borderRadius: BorderRadius.circular(10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
              value: selectedValues!.isEmpty ? null : selectedValues!,
              onChanged: (e) {
                widget.onchanged(e!);
                setState(() {
                  selectedValues = e;
                });
              },
              items: widget.optionsList.map((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: CustomText(title: value, softWrap: true),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomDropdownItem extends StatelessWidget {
  final String text;
  final String title;

  const CustomDropdownItem({super.key, required this.text, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(text: title, fontsize: 18),
        const SizedBox(height: 8),
        AppText(text: text),
      ],
    );
  }
}
