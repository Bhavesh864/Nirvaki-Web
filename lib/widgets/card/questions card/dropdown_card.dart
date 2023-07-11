import 'package:flutter/material.dart';
import 'package:yes_broker/constants/utils/constants.dart';

import '../../../Customs/custom_fields.dart';
import '../../../Customs/custom_text.dart';
import '../../../Customs/responsive.dart';

class DropDownCard extends StatefulWidget {
  final List<dynamic>? values;
  const DropDownCard({super.key, this.values});

  @override
  State<DropDownCard> createState() => _DropDownCardState();
}

class _DropDownCardState extends State<DropDownCard> {
  String? selectedValue = 'Select a item';

  List<String> selectedValues = [];

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
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.values?.length,
                    itemBuilder: (context, index) {
                      List values = widget.values![index]["values"];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              fontWeight: FontWeight.w500,
                              size: 16,
                              title: widget.values![index]['roomconfig'],
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                  value: selectedValues.length > index
                                      ? selectedValues[index]
                                      : null,
                                  onChanged: (newValue) {
                                    setState(() {
                                      if (selectedValues.length > index) {
                                        selectedValues[index] = newValue!;
                                      } else {
                                        selectedValues.add(newValue!);
                                      }
                                    });
                                  },
                                  items: values.map((value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  // items: [],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.only(top: 8),
                child: CustomButton(
                  width: 73,
                  text: 'Next',
                  onPressed: () {},
                  height: 39,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
