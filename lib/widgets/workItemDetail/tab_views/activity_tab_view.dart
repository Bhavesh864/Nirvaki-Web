// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/Customs/snackbar.dart';
import 'package:yes_broker/constants/firebase/Methods/add_activity.dart';
import 'package:yes_broker/riverpodstate/selected_workitem.dart';

import '../../timeline_view.dart';

class ActivityTabView extends ConsumerStatefulWidget {
  const ActivityTabView({super.key});

  @override
  _ActivityTabViewState createState() => _ActivityTabViewState();
}

class _ActivityTabViewState extends ConsumerState<ActivityTabView> {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final workItemId = ref.read(selectedWorkItemId.notifier).state;
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
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      submitActivity(itemid: workItemId, activitytitle: controller.text);
                      controller.clear();
                    } else {
                      customSnackBar(context: context, text: 'Please enter note to submit');
                    }
                  },
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
