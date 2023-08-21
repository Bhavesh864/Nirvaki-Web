import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/constants/utils/constants.dart';

import '../../riverpodstate/filter_list_items_provider.dart';

class WorkItemCheckboxOptions extends ConsumerStatefulWidget {
  const WorkItemCheckboxOptions({super.key});

  @override
  WorkItemCheckboxOptionsState createState() => WorkItemCheckboxOptionsState();
}

class WorkItemCheckboxOptionsState extends ConsumerState<WorkItemCheckboxOptions> {
  @override
  Widget build(BuildContext context) {
    final selectedInventoryFiltersProvider = ref.read(selectedFilterInventory.notifier);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: CustomText(
              title: 'Amenties',
              size: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: Responsive.isMobile(context) ? const NeverScrollableScrollPhysics() : const ScrollPhysics(),
              itemCount: inventoryFilterOtpion.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  height: 20,
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: CustomText(title: inventoryFilterOtpion[index]['title']),
                    value: inventoryFilterOtpion[index]['selected'],
                    onChanged: (value) {
                      if (value!) {
                        selectedInventoryFiltersProvider.addInventoryFilter(inventoryFilterOtpion[index]['title']);
                      } else {
                        selectedInventoryFiltersProvider.removeInventoryFilter(inventoryFilterOtpion[index]['title']);
                      }
                      setState(() {
                        inventoryFilterOtpion[index]['selected'] = value;
                      });
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
