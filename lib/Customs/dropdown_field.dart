import 'package:flutter/material.dart';

import 'custom_text.dart';

class DropDownField extends StatefulWidget {
  final String title;
  final List optionsList;
  const DropDownField(
      {super.key, required this.title, required this.optionsList});

  @override
  State<DropDownField> createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<DropDownField> {
  var selectedValues;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            fontWeight: FontWeight.w500,
            size: 16,
            title: widget.title,
          ),
          DropdownButtonHideUnderline(
            child: InputDecorator(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                isDense: true,
              ),
              child: DropdownButton(
                // isDense: true,
                itemHeight: null,
                focusColor: Colors.transparent,
                hint: const CustomText(
                  title: '--Select--',
                  color: Colors.grey,
                ),
                icon: const Icon(Icons.expand_more),
                isExpanded: true,
                borderRadius: BorderRadius.circular(6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                value: selectedValues,
                onChanged: (newValue) {
                  setState(() {
                    selectedValues = newValue!;
                  });
                },
                items: widget.optionsList.map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
