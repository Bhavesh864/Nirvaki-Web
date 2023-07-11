import 'package:flutter/material.dart';

import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/widgets/todo/todo_item.dart';

class TodoListView extends StatelessWidget {
  final bool headerShow;
  const TodoListView({super.key, this.headerShow = true});

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              color: AppColor.secondary,
              borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.all(5),
          margin: EdgeInsets.symmetric(
              horizontal: Responsive.isMobile(context) ? 0 : 10),
          child: SafeArea(
            right: false,
            child: Column(
              children: [
                headerShow
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 50,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              title: 'To Do',
                              fontWeight: FontWeight.w600,
                            ),
                            Icon(Icons.more_horiz),
                          ],
                        ),
                      )
                    : Container(),
                const SizedBox(
                  // height: Responsive.isMobile(context) ? height * 0.70 : 600,
                  // child: ListView.builder(
                  //   shrinkWrap: true,
                  //   physics: Responsive.isMobile(context)
                  //       ? const NeverScrollableScrollPhysics()
                  //       : const ClampingScrollPhysics(),
                  //   itemCount: userData.length,
                  //   itemBuilder: (context, index) {
                  //     return CustomCard(
                  //       index: index,
                  //       isTodoItem: true,
                  //     );
                  //   },
                  // ),
                  child: TodoItem(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//                     primary: true,
//                     shrinkWrap: true,
//                     children: dropDownListData
//                         .map(
//                           (e) => InkWell(
//                             onTap: () {
//                               setState(() {
//                                 selectedOption = e.value;
//                               });
//                             },
//                             child: Center(
//                               child: Container(
//                                 width: width * 0.1,
//                                 margin: const EdgeInsets.symmetric(
//                                     horizontal: 5, vertical: 5),
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 10, vertical: 5),
//                                 decoration: BoxDecoration(
//                                   color: AppColor.secondary,
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Text(e['title']),
//                               ),
//                             ),
//                           ),
//                         )
//                         .toList(),
//                   ),