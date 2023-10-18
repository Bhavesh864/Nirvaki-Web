// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/customs/custom_fields.dart';
import 'package:yes_broker/customs/custom_text.dart';
import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/customs/custom_chip.dart';
import 'package:yes_broker/riverpodstate/filter_list_items_provider.dart';

class FilterOptions {
  List<String> roomConfigurations = [];
}

class WorkItemFilterView extends ConsumerStatefulWidget {
  final Function closeFilterView;
  final Function(List<String>, RangeValues) setFilters;
  final List<CardDetails> originalCardList;

  const WorkItemFilterView({
    super.key,
    this.closeFilterView = _defaultCloseFunction,
    required this.originalCardList,
    this.setFilters = _defaultCloseFunction,
  });

  static void _defaultCloseFunction(k, w) {}

  @override
  WorkItemFilterViewState createState() => WorkItemFilterViewState();
}

class WorkItemFilterViewState extends ConsumerState<WorkItemFilterView> {
  late FilterOptions filterOptions = FilterOptions();
  List<String> datalist = ['Studio', '1BHK', '2BHK', '3BHK', '4BHK', '5BHK', '5BHK +'];
  RangeValues values = const RangeValues(0, 100);

  @override
  Widget build(BuildContext context) {
    var selectedInventoryFilters = ref.read(selectedFilterInventory);
    var selectedInventoryFiltersProvider = ref.read(selectedFilterInventory.notifier);

    Widget bottomButton() {
      return Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: Responsive.isMobile(context) ? null : const EdgeInsets.only(right: 25, bottom: 20, left: 15),
            decoration: BoxDecoration(
              color: Responsive.isMobile(context) ? Colors.white : Colors.transparent,
              boxShadow: Responsive.isMobile(context)
                  ? const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10.0,
                        offset: Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: Padding(
              padding: Responsive.isMobile(context) ? const EdgeInsets.symmetric(horizontal: 15, vertical: 8) : const EdgeInsets.all(0),
              child: CustomButton(
                text: 'Apply Filters',
                onPressed: () {
                  // widget.setFilters(selectedInventoryFilters, values);
                  if (Responsive.isMobile(context)) {
                    Navigator.of(context).pop();
                  } else {
                    widget.closeFilterView();
                  }
                },
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: bottomButton(),
      appBar: Responsive.isMobile(context)
          ? AppBar(
              toolbarHeight: 50,
              elevation: 0,
              title: const CustomText(
                title: 'Filter your search',
                fontWeight: FontWeight.w700,
                size: 16,
              ),
              iconTheme: const IconThemeData(color: Colors.black, size: 24),
            )
          : null,
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: Container(
            // height: 800,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (!Responsive.isMobile(context)) ...[
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
                          widget.setFilters([], values);
                          selectedInventoryFilters = [];
                        },
                        icon: const Icon(
                          Icons.close,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
                SizedBox(
                  // height: !Responsive.isMobile(context) ? 650 : 700,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                      Wrap(
                        children: datalist
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.only(right: 8, top: 8),
                                child: CustomChip(
                                  paddingVertical: 6,
                                  onPressed: () {
                                    if (filterOptions.roomConfigurations.contains(e)) {
                                      filterOptions.roomConfigurations.remove(e);
                                      selectedInventoryFiltersProvider.removeInventoryFilter(e);
                                    } else {
                                      filterOptions.roomConfigurations.add(e);
                                      selectedInventoryFiltersProvider.addInventoryFilter(e);
                                    }
                                    setState(() {});
                                  },
                                  label: CustomText(
                                    title: e,
                                    size: 10,
                                    color: filterOptions.roomConfigurations.contains(e) ? Colors.white : Colors.black,
                                  ),
                                  color: filterOptions.roomConfigurations.contains(e) ? AppColor.primary : AppColor.chipGreyColor,
                                ),
                              ),
                            )
                            .toList(),
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
                      CustomText(
                        title: '₹${values.start.toStringAsFixed(0)} - ₹${values.end.toStringAsFixed(0)} per month',
                        size: 14,
                      ),
                      RangeSlider(
                        values: values,
                        min: 0,
                        max: 500000000,
                        divisions: 100,
                        onChanged: (RangeValues newVal) {
                          setState(() {
                            values = newVal;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // const WorkItemCheckboxOptions(),
                    ],
                  ),
                ),
                // CustomButton(
                //   text: 'Apply Filters',
                //   onPressed: () {
                //     widget.setFilters(selectedInventoryFilters, values);
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FilterBottomButton extends StatelessWidget {
  const FilterBottomButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: CustomButton(text: 'Apply Filter', onPressed: () {}),
    );
  }
}
