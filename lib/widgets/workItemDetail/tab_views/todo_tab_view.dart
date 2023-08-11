import 'package:flutter/material.dart';
import 'package:yes_broker/widgets/todo/todo_item.dart';

import '../../../Customs/responsive.dart';

import '../../../constants/utils/colors.dart';

class TodoTabView extends StatelessWidget {
  const TodoTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // constraints: BoxConstraints(
      //   minHeight: height! * 0.7,
      // ),
      decoration: BoxDecoration(
        color: AppColor.secondary,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: Responsive.isMobile(context) ? 1 : 2,
            mainAxisSpacing: 10.0, // Spacing between rows
            crossAxisSpacing: 10.0,
            mainAxisExtent: 160 // Spacing between columns
            ),
        itemCount: 3,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {},
          child: const TodoItem(),
        ),
      ),
    );
  }
}
