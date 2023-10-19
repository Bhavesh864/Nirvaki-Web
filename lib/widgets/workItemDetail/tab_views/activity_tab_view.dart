// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yes_broker/constants/utils/colors.dart';

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
  void submitTodo() {
    if (!kIsWeb) FocusManager.instance.primaryFocus?.unfocus();
    final workItemId = ref.read(selectedWorkItemId);
    final User? user = ref.read(userDataProvider);
    if (controller.text.trim().isNotEmpty) {
      submitActivity(itemid: workItemId, activitytitle: controller.text.trim(), user: user!);
      notifyToUser(currentuserdata: user, assignedto: widget.details.assignedto, content: "$workItemId added new Activity", title: controller.text, itemid: workItemId);
      controller.clear();
    } else {
      customSnackBar(context: context, text: 'Please enter note to submit');
    }
  }

  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                  child: TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      // enabledBorder: OutlineInputBorder(
                      //   borderRadius: BorderRadius.circular(6),
                      // ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      hintText: 'Type note here..',
                      hintStyle: TextStyle(
                        fontFamily: GoogleFonts.dmSans().fontFamily,
                        color: const Color(0xFF828282),
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                      isDense: true,
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                    ),
                    onFieldSubmitted: (_) => submitTodo(),
                  ),
                ),
                CustomButton(
                  text: 'Add Note',
                  fontWeight: FontWeight.w500,
                  onPressed: submitTodo,
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
