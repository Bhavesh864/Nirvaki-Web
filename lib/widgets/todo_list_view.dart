import 'package:flutter/material.dart';
import 'package:yes_broker/constants/colors.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/widgets/todo_item.dart';

class TodoListView extends StatelessWidget {
  const TodoListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              color: AppColor.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.all(5),
          margin: EdgeInsets.symmetric(
              horizontal: Responsive.isMobile(context) ? 0 : 10),
          child: SafeArea(
            right: false,
            child: Column(
              children: [
                Container(
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
                ),
                const SizedBox(
                  // height: Responsive.isMobile(context) ? height * 0.70 : 600,
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

// DropdownButtonHideUnderline(
//                     child: DropdownButton<String>(
//                         isDense: true,
//                         value: secondDropDown,
//                         isExpanded: true,
//                         menuMaxHeight: 200,
//                         items: [
//                           const DropdownMenuItem(
//                               child: Text(
//                                 "Select Course",
//                               ),
//                               value: ""),
//                           ...dropDownListData
//                               .map<DropdownMenuItem<String>>((data) {
//                             return DropdownMenuItem(
//                                 child: Center(
//                                   child: Container(
//                                     width: double.infinity,
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 10, vertical: 5),
//                                     decoration: BoxDecoration(
//                                       color: primaryColor.withOpacity(0.1),
//                                       borderRadius: BorderRadius.circular(5),
//                                     ),
//                                     child: Text(data['title']),
//                                   ),
//                                 ),
//                                 value: data['value']);
//                           }).toList(),
//                         ],
//                         onChanged: (value) {
//                           print("selected Value $value");
//                           setState(() {
//                             secondDropDown = value!;
//                           });
//                         }),
//                   ),



// ListView(
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
//                                   color: primaryColor.withOpacity(0.1),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Text(e['title']),
//                               ),
//                             ),
//                           ),
//                         )
//                         .toList(),
//                   ),