import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/widgets/todo/todo_list_view.dart';
import 'package:yes_broker/widgets/top_search_bar.dart';
import 'package:yes_broker/widgets/workitems/workitem_filter_view.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  bool isFilterOpen = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColor.secondary,
            spreadRadius: 12,
            blurRadius: 4,
            offset: Offset(5, 5),
          ),
        ],
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Column(
              children: [
                TopSerachBar(
                    title: 'Inventory',
                    isMobile: Responsive.isMobile(context),
                    isFilterOpen: isFilterOpen,
                    onFilterClose: () {
                      setState(() {
                        isFilterOpen = false;
                      });
                    },
                    onFilterOpen: () {
                      setState(() {
                        isFilterOpen = true;
                      });
                    }),
                Expanded(
                  // height: height! * 0.74,
                  child: Row(
                    children: [
                      const Expanded(
                        child: TodoListView(
                          headerShow: false,
                        ),
                      ),
                      !Responsive.isMobile(context)
                          ? const Expanded(
                              child: TodoListView(
                                headerShow: false,
                              ),
                            )
                          : Container(),
                      if (!Responsive.isMobile(context) && !isFilterOpen)
                        const Expanded(
                          child: TodoListView(headerShow: false),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Responsive.isDesktop(context) && isFilterOpen
              ? Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        width: 1,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      Expanded(
                        child: WorkItemFilterView(closeFilterView: () {
                          setState(() {
                            isFilterOpen = false;
                          });
                        }),
                      ),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
