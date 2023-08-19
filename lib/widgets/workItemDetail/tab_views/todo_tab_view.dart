import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/custom_chip.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/widgets/todo/todo_item.dart';
import '../../../Customs/responsive.dart';
import '../../../constants/utils/colors.dart';

class TodoTabView extends StatelessWidget {
  final bool showTableView = false;
  const TodoTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: TextField(
                  controller: TextEditingController(),
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Row(
                children: [
                  const CustomChip(
                    label: Icon(
                      Icons.view_agenda_outlined,
                      size: 24,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Row(
                      children: [
                        Icon(Icons.add),
                        CustomText(
                          title: 'Add new',
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        if (showTableView)
          ...[]
        else ...[
          Container(
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
          ),
        ]
      ],
    );
  }
}
