import 'package:flutter/material.dart';

import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/widgets/card/questions%20card/chip_button.dart';

import '../../../Customs/custom_fields.dart';
import '../../../Customs/custom_text.dart';
import '../../../Customs/responsive.dart';

class DropDownCard extends StatefulWidget {
  final List<dynamic>? values;
  final String? question;
  final int? id;
  final VoidCallback? onSelect;
  const DropDownCard(
      {super.key, this.values, this.question, this.id, this.onSelect});

  @override
  State<DropDownCard> createState() => _DropDownCardState();
}

class _DropDownCardState extends State<DropDownCard> {
  String? selectedValue = 'Select a item';

  List<String> selectedValues = [];
  List<String> selectedChoices = [];

  int? selectIndex;
  @override
  Widget build(BuildContext context) {
    print(widget.values);
    print(widget.question);
    return Center(
      child: SingleChildScrollView(
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
                CustomText(
                  softWrap: true,
                  textAlign: TextAlign.center,
                  size: 30,
                  title: widget.question!,
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
                                  title: widget.values![index]['roomconfig']),
                              if (widget.values![index]['type'] == "dropdown")
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
                                            // selectedValues[index] = newValue!;
                                          }
                                        });
                                      },
                                      // items: values.map((value) {
                                      //   return DropdownMenuItem<String>(
                                      //     value: value,
                                      //     child: Text(value),
                                      //   );
                                      // }).toList(),
                                      items: List.generate(
                                        values.length,
                                        (index) => DropdownMenuItem<String>(
                                          value: values[index],
                                          child: Text(values[index]),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (widget.values![index]["type"] == "chip")
                                Wrap(
                                  children: values.map((value) {
                                    if (widget.id == 10) {
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 6),
                                        child: ChipButton(
                                          text: value,
                                          onSelect: () {},
                                          width: 120,
                                        ),
                                      );
                                    }
                                    return Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 6),
                                        child: CustomChoiceChip(
                                          label: value,
                                          labelColor:
                                              selectedChoices.contains(value)
                                                  ? Colors.white
                                                  : Colors.black,
                                          selected:
                                              selectedChoices.contains(value),
                                          onSelected: (selected) {
                                            setState(() {
                                              if (selected) {
                                                selectedChoices.add(value);
                                              } else {
                                                selectedChoices.remove(value);
                                              }
                                            });
                                          },
                                        ));
                                  }).toList(),
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
                    onPressed: () => {widget.onSelect!()},
                    height: 39,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
