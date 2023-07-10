import 'package:flutter/material.dart';
import 'package:yes_broker/constants/constants.dart';

import '../../../Customs/custom_text.dart';
import '../../../Customs/responsive.dart';

class DropDownCard extends StatefulWidget {
  const DropDownCard({super.key});

  @override
  State<DropDownCard> createState() => _DropDownCardState();
}

class _DropDownCardState extends State<DropDownCard> {
  String? selectedValue = 'Select a item';
  List<String> options = [
    'Select a item',
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4'
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 0,
            maxHeight: double.infinity,
          ),
          width: Responsive.isMobile(context) ? width! * 0.9 : 650,
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomText(
                softWrap: true,
                textAlign: TextAlign.center,
                size: 30,
                title: 'Room Details',
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 15,
              ),
              Theme(
                data: ThemeData(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent),
                child: DropdownButtonHideUnderline(
                  child: InputDecorator(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      isDense: true,
                    ),
                    child: DropdownButton(
                      borderRadius: BorderRadius.circular(6),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      value: selectedValue,
                      onChanged: (newValue) {
                        setState(() {
                          selectedValue = newValue!;
                        });
                      },
                      items: options.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              // LabelTextInputField(
              //   isDropDown: true,
              //   inputController: TextEditingController(),
              //   labelText: 'No. of Bedrooms?',
              // )
            ],
          ),
        ),
      ),
    );
  }
}
