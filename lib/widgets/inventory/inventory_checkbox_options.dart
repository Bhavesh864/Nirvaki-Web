import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/constants/utils/constants.dart';

class InventoryCheckBoxOptions extends StatefulWidget {
  const InventoryCheckBoxOptions({super.key});

  @override
  State<InventoryCheckBoxOptions> createState() =>
      _InventoryCheckBoxOptionsState();
}

class _InventoryCheckBoxOptionsState extends State<InventoryCheckBoxOptions> {
  @override
  Widget build(BuildContext context) {
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
              itemCount: inventoryFilterOtpion.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  height: 20,
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: CustomText(
                        title: inventoryFilterOtpion[index]['title']),
                    value: inventoryFilterOtpion[index]['selected'],
                    onChanged: (value) {
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
