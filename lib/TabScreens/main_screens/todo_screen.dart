import 'package:flutter/material.dart';
<<<<<<< HEAD

import 'package:yes_broker/constants/colors.dart';
=======
import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/Customs/responsive.dart';

import 'package:yes_broker/constants/colors.dart';
import 'package:yes_broker/widgets/todo/todo_filter_view.dart';
import 'package:yes_broker/widgets/todo/todo_list_view.dart';
>>>>>>> 2ab590c9ff4537099f67fd61496a3d966619937a

class TodoTabScreen extends StatelessWidget {
  const TodoTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
<<<<<<< HEAD
            color: primaryColor.withOpacity(0.1),
=======
            color: AppColor.secondary,
>>>>>>> 2ab590c9ff4537099f67fd61496a3d966619937a
            spreadRadius: 12,
            blurRadius: 4,
            offset: const Offset(5, 5),
          ),
        ],
        color: Colors.white,
      ),
<<<<<<< HEAD
      child: const Center(
        child: Text('Todo Screen'),
=======
      child: Row(
        children: [
          Expanded(
            flex: 5,
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
                      // width! > 1100
                      //     ? const Expanded(
                      //         child: WorkItemsList(headerShow: false),
                      //       )
                      //     : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Responsive.isDesktop(context)
              ? Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 10),
                        width: 1,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      const Expanded(
                        child: TodoFilterView(),
                      ),
                    ],
                  ),
                )
              : Container(),
        ],
>>>>>>> 2ab590c9ff4537099f67fd61496a3d966619937a
      ),
    );
  }
}
