import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/Customs/custom_chip.dart';
import 'package:yes_broker/constants/utils/constants.dart';

class FilterOptions {
  List<String> roomConfigurations = [];
  RangeValues rentRange = const RangeValues(10000, 50000);
}

class TodoFilterView extends StatefulWidget {
  final Function closeFilterView;
  final Function(List<String>) onApplyFilters;

  TodoFilterView({super.key, required this.closeFilterView, required this.onApplyFilters});

  @override
  State<TodoFilterView> createState() => _TodoFilterViewState();
}

class _TodoFilterViewState extends State<TodoFilterView> {
  List<String> selectedList = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                title: 'Filter',
                fontWeight: FontWeight.w700,
                size: 18,
              ),
              IconButton(
                onPressed: () {
                  widget.closeFilterView();
                },
                icon: const Icon(
                  Icons.close,
                  size: 24,
                ),
              ),
            ],
          ),
          // Spacer(),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: CustomText(
                      title: 'To do Type',
                      size: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        CustomChip(
                          onPressed: () {
                            if (selectedList.contains('task')) {
                              selectedList.remove('task');
                            } else {
                              selectedList.add('task');
                            }
                            setState(() {});
                          },
                          label: CustomText(
                            title: 'Task',
                            size: 10,
                            color: selectedList.contains('task') ? Colors.white : Colors.black,
                          ),
                          color: selectedList.contains('task') ? AppColor.primary : AppColor.chipGreyColor,
                        ),
                        CustomChip(
                          onPressed: () {
                            if (selectedList.contains('follow up')) {
                              selectedList.remove('follow up');
                            } else {
                              selectedList.add('follow up');
                            }
                            setState(() {});
                          },
                          label: CustomText(
                            title: 'Follow up',
                            size: 10,
                            color: selectedList.contains('follow up') ? Colors.white : Colors.black,
                          ),
                          color: selectedList.contains('follow up') ? AppColor.primary : AppColor.chipGreyColor,
                        ),
                        CustomChip(
                          onPressed: () {
                            if (selectedList.contains('reminder')) {
                              selectedList.remove('reminder');
                            } else {
                              selectedList.add('reminder');
                            }
                            setState(() {});
                          },
                          label: CustomText(
                            title: 'Reminder',
                            size: 10,
                            color: selectedList.contains('reminder') ? Colors.white : Colors.black,
                          ),
                          color: selectedList.contains('reminder') ? AppColor.primary : AppColor.chipGreyColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: CustomText(
                      title: 'Linked to',
                      size: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        CustomChip(
                          onPressed: () {
                            if (selectedList.contains('inventory')) {
                              selectedList.remove('inventory');
                            } else {
                              selectedList.add('inventory');
                            }
                            setState(() {});
                          },
                          label: CustomText(
                            title: 'Inventory',
                            size: 10,
                            color: selectedList.contains('inventory') ? Colors.white : Colors.black,
                          ),
                          color: selectedList.contains('inventory') ? AppColor.primary : AppColor.chipGreyColor,
                        ),
                        CustomChip(
                          onPressed: () {
                            if (selectedList.contains('lead')) {
                              selectedList.remove('lead');
                            } else {
                              selectedList.add('lead');
                            }

                            setState(() {});
                          },
                          label: CustomText(
                            title: 'Lead',
                            size: 10,
                            color: selectedList.contains('lead') ? Colors.white : Colors.black,
                          ),
                          color: selectedList.contains('lead') ? AppColor.primary : AppColor.chipGreyColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: CustomText(
                      title: 'Status',
                      size: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    height: 100,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Wrap(
                      children: dropDownStatusDataList
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(right: 8.0, top: 8),
                              child: CustomChip(
                                onPressed: () {
                                  if (selectedList.contains(e.toString().toLowerCase())) {
                                    selectedList.remove(e.toString().toLowerCase());
                                  } else {
                                    selectedList.add(e.toString().toLowerCase());
                                  }
                                  setState(() {});
                                },
                                label: CustomText(
                                  title: e,
                                  size: 10,
                                  color: selectedList.contains(e.toString().toLowerCase()) ? Colors.white : Colors.black,
                                ),
                                color: selectedList.contains(e.toString().toLowerCase()) ? AppColor.primary : AppColor.chipGreyColor,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomButton(
              text: 'Apply Filters',
              onPressed: () {
                widget.onApplyFilters(selectedList);
              },
            ),
          ),
        ],
      ),
    );
  }
}
