import 'package:flutter/material.dart';

import 'package:yes_broker/constants/colors.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/widgets/calendar_view.dart';
import 'package:yes_broker/widgets/timeline_view.dart';
import 'package:yes_broker/widgets/todo/todo_list_view.dart';
import 'package:yes_broker/widgets/workitems_list.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

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
            flex: _size.width > 1340 ? 3 : 5,
            child: const Padding(
              padding: EdgeInsets.only(top: 8, left: 0),
              child: TodoListView(),
            ),
          ),
          _size.width > 1200
              ? Expanded(
                  flex: _size.width > 1340 ? 3 : 5,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: WorkItemsList(),
                  ),
                )
              : Container(),
          Expanded(
            flex: _size.width > 1340 ? 4 : 6,
            child: Column(
              children: [
                const Expanded(
                  flex: 2,
                  child: CustomCalendarView(),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppColor.secondary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: 10, top: 10, bottom: 10),
                          child: CustomText(
                            title: 'Timeline',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        CustomTimeLineView(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
