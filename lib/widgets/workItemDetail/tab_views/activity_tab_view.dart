import 'package:flutter/material.dart';
import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/Customs/custom_text.dart';

import '../../timeline_view.dart';

class ActivityTabView extends StatefulWidget {
  const ActivityTabView({super.key});

  @override
  State<ActivityTabView> createState() => _ActivityTabViewState();
}

class _ActivityTabViewState extends State<ActivityTabView> {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomText(
              title: 'Activity',
              fontWeight: FontWeight.w700,
              size: 18,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Type note here',
                    ),
                  ),
                ),
                CustomButton(
                  text: 'Add Note',
                  onPressed: () {},
                  height: 40,
                ),
              ],
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: SizedBox(
            height: 470,
            child: CustomTimeLineView(
              isScrollable: false,
            ),
          ),
        ),
      ],
    );
  }
}
