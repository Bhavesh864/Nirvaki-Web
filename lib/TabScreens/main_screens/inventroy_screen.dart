import 'package:flutter/material.dart';
import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/constants/colors.dart';
import 'package:yes_broker/constants/constants.dart';
import 'package:yes_broker/widgets/workitems_list.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            spreadRadius: 12,
            blurRadius: 4,
            offset: const Offset(5, 5),
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        children: [
          !Responsive.isMobile(context)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          top: 10, bottom: 5, left: 20, right: 20),
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: CustomTextInput(
                        controller: TextEditingController(),
                        hintText: 'Search',
                        leftIcon: Icons.search,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.filter_alt_outlined),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.view_stream_outlined),
                        ),
                      ],
                    )
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: CustomText(
                        title: 'Inventory',
                        fontWeight: FontWeight.w600,
                        size: 18,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.filter_list),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.more_horiz),
                        ),
                      ],
                    )
                  ],
                ),
          SizedBox(
            height: height! * 0.70,
            child: Row(
              children: [
                const Expanded(
                  child: WorkItemsList(
                    headerShow: false,
                  ),
                ),
                !Responsive.isMobile(context)
                    ? const Expanded(
                        child: WorkItemsList(
                          headerShow: false,
                        ),
                      )
                    : Container(),
                width! > 1100
                    ? const Expanded(
                        child: WorkItemsList(headerShow: false),
                      )
                    : Container(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
