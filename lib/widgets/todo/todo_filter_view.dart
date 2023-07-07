import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/constants/colors.dart';
import 'package:yes_broker/widgets/custom_chip.dart';

class TodoFilterView extends StatelessWidget {
  const TodoFilterView({super.key});

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
              IconButton(onPressed: () {}, icon: Icon(Icons.close)),
            ],
          ),
          // Spacer(),
          const SizedBox(
            height: 30,
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: 300,
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
                          label: const CustomText(
                            title: 'Task',
                            size: 10,
                          ),
                          color: AppColor.chipGreyColor,
                        ),
                        CustomChip(
                          label: const CustomText(
                            title: 'Follow up',
                            size: 10,
                          ),
                          color: AppColor.chipGreyColor,
                        ),
                        CustomChip(
                          label: const CustomText(
                            title: 'Reminder',
                            size: 10,
                          ),
                          color: AppColor.chipGreyColor,
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
                          label: const CustomText(
                            title: 'Inventory',
                            size: 10,
                          ),
                          color: AppColor.chipGreyColor,
                        ),
                        CustomChip(
                          label: const CustomText(
                            title: 'Lead',
                            size: 10,
                          ),
                          color: AppColor.chipGreyColor,
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
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        CustomChip(
                          label: const CustomText(
                            title: 'New',
                            size: 10,
                          ),
                          color: AppColor.chipGreyColor,
                        ),
                        CustomChip(
                          label: const CustomText(
                            title: 'In Progress',
                            size: 10,
                          ),
                          color: AppColor.chipGreyColor,
                        ),
                        CustomChip(
                          label: const CustomText(
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
          const Spacer(),
          CustomButton(
            text: 'Apply Filters',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
