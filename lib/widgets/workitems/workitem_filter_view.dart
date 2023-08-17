import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/Customs/custom_chip.dart';
import 'package:yes_broker/riverpodstate/filter_list_items_provider.dart';
import 'package:yes_broker/widgets/workitems/inventory_checkbox_options.dart';

class FilterOptions {
  List<String> roomConfigurations = [];
  RangeValues rentRange = RangeValues(10000, 50000);
}

class WorkItemFilterView extends ConsumerStatefulWidget {
  final Function closeFilterView;
  final List<CardDetails> originalCardList;

  const WorkItemFilterView({
    super.key,
    this.closeFilterView = _defaultCloseFunction,
    required this.originalCardList,
  });

  static void _defaultCloseFunction() {}

  @override
  WorkItemFilterViewState createState() => WorkItemFilterViewState();
}

class WorkItemFilterViewState extends ConsumerState<WorkItemFilterView> {
  late FilterOptions filterOptions = FilterOptions();
  List<String> datalist = ['Studio', '1RK', '1BHK', '2BHK', '3BHK', '4BHK', '5BHK', '5BHK +'];

  @override
  Widget build(BuildContext context) {
    final selectedInventoryFiltersProvider = ref.read(selectedFilterInventory.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Responsive.isMobile(context)
          ? AppBar(
              toolbarHeight: 50,
              elevation: 0,
              title: const CustomText(
                title: 'Filter your search',
                fontWeight: FontWeight.w700,
                size: 18,
              ),
              iconTheme: const IconThemeData(color: Colors.black, size: 24),
            )
          : null,
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: Container(
            height: 800,
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
                  height: !Responsive.isMobile(context) ? 650 : 700,
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
                      Wrap(
                        children: datalist
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.only(right: 8, top: 8),
                                child: CustomChip(
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
                      const WorkItemCheckboxOptions(),
                    ],
                  ),
                ),
                // const Spacer(),
                CustomButton(
                  text: 'Apply Filters',
                  onPressed: () {
                    // Get the selected filter items from the Riverpod state
                    // final selectedFilters = selectedInventoryFiltersProvider.state;

                    // Apply the filtering logic to your card listing data
                    // final filteredList = widget.originalCardList.where((card) {
                    //   if (selectedFilters.isEmpty) {
                    //     return true; // Show all cards if no filters selected
                    //   }
                    //   return selectedFilters.any(
                    //     (filter) => card.roomconfig!.additionalroom!.contains(filter),
                    //   );
                    // }).toList();

                    // Update the listing using the filtered results (you need to define originalCardList)
                    // ref.read(filteredCardListProvider.notifier).updateFilteredList(filteredList);

                    widget.closeFilterView();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
