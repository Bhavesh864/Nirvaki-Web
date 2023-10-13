import 'package:flutter/material.dart';
import 'package:yes_broker/Customs/text_utility.dart';

import 'custom_text.dart';

class DropDownField extends StatefulWidget {
  final String title;
  final List optionsList;
  final List<Map<String, dynamic>>? multipleValuesmap;
  final void Function(Object e) onchanged;
  final String? defaultValues;
  final bool isMultiValueOnDropdownlist;

  const DropDownField({
    super.key,
    required this.title,
    required this.optionsList,
    required this.onchanged,
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
        CustomText(
          fontWeight: FontWeight.w500,
          color: Colors.black,
          size: 16,
          title: widget.title,
        ),
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
              // itemHeight: null,
              focusColor: Colors.transparent,
              hint: const CustomText(
                title: '--Select--',
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
                  child: CustomText(title: value),
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
