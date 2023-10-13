// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:yes_broker/customs/custom_fields.dart';
import 'package:yes_broker/customs/custom_text.dart';
import 'package:yes_broker/customs/snackbar.dart';
import 'package:yes_broker/constants/firebase/Methods/add_activity.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/riverpodstate/selected_workitem.dart';

import '../../../constants/firebase/userModel/user_info.dart';
import '../../../customs/responsive.dart';
import '../../../constants/firebase/send_notification.dart';
import '../../../riverpodstate/user_data.dart';
import '../../timeline_view.dart';

class ActivityTabView extends ConsumerStatefulWidget {
  final dynamic details;
  const ActivityTabView({required this.details, super.key});

  @override
  ActivityTabViewState createState() => ActivityTabViewState();
}

class ActivityTabViewState extends ConsumerState<ActivityTabView> {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final workItemId = ref.watch(selectedWorkItemId);
    final User? user = ref.watch(userDataProvider);

    return Column(
      children: [
        Wrap(
          runSpacing: 20,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  margin: const EdgeInsets.only(right: 10),
                  width: Responsive.isMobile(context) ? width! * 0.6 : 400,
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Type note here...',
                      hintStyle: TextStyle(
                        fontFamily: GoogleFonts.dmSans().fontFamily,
                      ),
                      isDense: true,
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                CustomButton(
                  text: 'Add Note',
                  onPressed: () {
                    if (controller.text.trim().isNotEmpty) {
                      submitActivity(itemid: workItemId, activitytitle: controller.text.trim(), user: user!);
                      notifyToUser(
                          currentuserdata: user,
                          assignedto: widget.details.assignedto,
                          content: "$workItemId added new Activity",
                          title: controller.text,
                          itemid: workItemId);
                      controller.clear();
                    } else {
                      customSnackBar(context: context, text: 'Please enter note to submit');
                    }
                  },
                  height: Responsive.isMobile(context) ? 45 : 40,
                ),
              ],
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: CustomTimeLineView(
            isScrollable: false,
          ),
        ),
      ],
    );
  }
}
