import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/widgets/custom_chip.dart';

class TodoFilterView extends StatelessWidget {
  final Function closeFilterView;

  const TodoFilterView({super.key, required this.closeFilterView});

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
                    closeFilterView();
                  },
                  icon: const Icon(Icons.close)),
            ],
          ),
          // Spacer(),
          const SizedBox(
            height: 30,
          ),
          const Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
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
                          label: CustomText(
                            title: 'Task',
                            size: 10,
                          ),
                          color: AppColor.chipGreyColor,
                        ),
                        CustomChip(
                          label: CustomText(
                            title: 'Follow up',
                            size: 10,
                          ),
                          color: AppColor.chipGreyColor,
                        ),
                        CustomChip(
                          label: CustomText(
                            title: 'Reminder',
                            size: 10,
                          ),
                          color: AppColor.chipGreyColor,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
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
                          label: CustomText(
                            title: 'Inventory',
                            size: 10,
                          ),
                          color: AppColor.chipGreyColor,
                        ),
                        CustomChip(
                          label: CustomText(
                            title: 'Lead',
                            size: 10,
                          ),
                          color: AppColor.chipGreyColor,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: CustomText(
                      title: 'Status',
                      size: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        CustomChip(
                          label: CustomText(
                            title: 'New',
                            size: 10,
                          ),
                          color: AppColor.chipGreyColor,
                        ),
                        CustomChip(
                          label: CustomText(
                            title: 'In Progress',
                            size: 10,
                          ),
                          color: AppColor.chipGreyColor,
                        ),
                        CustomChip(
                          label: CustomText(
                            title: 'Closed',
                            size: 10,
                          ),
                          color: AppColor.chipGreyColor,
                        ),
                      ],
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
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
