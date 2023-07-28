import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/widgets/todo/todo_list_view.dart';
import 'package:yes_broker/widgets/workitems/workitem_filter_view.dart';

import '../../widgets/top_search_bar.dart';

class LeadScreen extends StatefulWidget {
  const LeadScreen({super.key});

  @override
  State<LeadScreen> createState() => _LeadScreenState();
}

class _LeadScreenState extends State<LeadScreen> {
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
                    title: 'Lead',
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
                        )
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
                        child: WorkItemFilterView(
                          closeFilterView: () {
                            setState(() {
                              isFilterOpen = false;
                            });
                          },
                        ),
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
