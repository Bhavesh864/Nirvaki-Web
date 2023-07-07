import 'package:flutter/material.dart';
import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/constants/colors.dart';
import 'package:yes_broker/widgets/custom_chip.dart';
import 'package:yes_broker/widgets/inventory/inventory_checkbox_options.dart';

class InventoryFilterView extends StatelessWidget {
  const InventoryFilterView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Expanded(
        child: Container(
          height: 800,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                  IconButton(onPressed: () {}, icon: const Icon(Icons.close)),
                ],
              ),
              // Spacer(),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 650,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: CustomText(
                        title: 'Room Configuration',
                        size: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                      child: Row(
                        children: [
                          CustomChip(
                            label: CustomText(
                              title: 'Studio',
                              size: 10,
                            ),
                            color: AppColor.chipGreyColor,
                          ),
                          CustomChip(
                            label: CustomText(
                              title: '1RK',
                              size: 10,
                            ),
                            color: AppColor.chipGreyColor,
                          ),
                          CustomChip(
                            label: CustomText(
                              title: '1BHK',
                              size: 10,
                            ),
                            color: AppColor.chipGreyColor,
                          ),
                          CustomChip(
                            label: CustomText(
                              title: '2BHK',
                              size: 10,
                            ),
                            color: AppColor.chipGreyColor,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                      child: Row(
                        children: [
                          CustomChip(
                            label: CustomText(
                              title: '3BHK',
                              size: 10,
                            ),
                            color: AppColor.chipGreyColor,
                          ),
                          CustomChip(
                            label: CustomText(
                              title: '4BHK',
                              size: 10,
                            ),
                            color: AppColor.chipGreyColor,
                          ),
                          CustomChip(
                            label: CustomText(
                              title: '5BHK',
                              size: 10,
                            ),
                            color: AppColor.chipGreyColor,
                          ),
                          CustomChip(
                            label: CustomText(
                              title: '5BHK +',
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
                        title: 'Rent Range',
                        size: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const CustomText(
                      title: '₹10,0000 - ₹50,000 per month',
                      size: 14,
                    ),
                    Container(
                      height: 100,
                      color: AppColor.primary,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const InventoryCheckBoxOptions(),
                  ],
                ),
              ),
              const Spacer(),
              CustomButton(
                text: 'Apply Filters',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
