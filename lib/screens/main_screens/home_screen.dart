import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/constants/firebase/questionModels/todo_question.dart';

import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/widgets/app/nav_bar.dart';
import 'package:yes_broker/widgets/calendar_view.dart';
import 'package:yes_broker/widgets/timeline_view.dart';
import 'package:yes_broker/widgets/todo/todo_list_view.dart';
import 'package:yes_broker/widgets/workitems_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // add();
  }

  add() async {
    List<TodoQuestion> screensList = [
      TodoQuestion(screens: [
        Screen(
          questions: [
            Question(
              questionId: 1,
              questionOptionType: "chip",
              questionTitle: "What kind of to do is it?",
              questionOption: ["Task", "Follow Up", "Reminder"],
            ),
          ],
          isActive: true,
          previousScreenId: "",
          screenId: "S1",
          nextScreenId: "S2",
        ),
        Screen(
          questions: [
            Question(
              questionId: 2,
              questionOptionType: "textfield",
              questionTitle: "Task Name",
              questionOption: "",
            ),
            Question(
              questionId: 3,
              questionOptionType: "textarea",
              questionTitle: "Task Description",
              questionOption: "",
            ),
          ],
          isActive: true,
          previousScreenId: "S1",
          screenId: "S2",
          title: "Task Name and Description",
          nextScreenId: "S3",
        ),
        Screen(
          questions: [
            Question(
              questionId: 4,
              questionOptionType: "date",
              questionTitle: "Due date",
              questionOption: "",
            ),
          ],
          isActive: true,
          previousScreenId: "S2",
          screenId: "S3",
          title: "Due Date for task",
          nextScreenId: "S4",
        ),
        Screen(
          questions: [
            Question(
              questionId: 5,
              questionOptionType: "chip",
              questionTitle: "Do you want to link  work item?",
              questionOption: ["Yes", "No"],
            ),
          ],
          isActive: true,
          previousScreenId: "S3",
          screenId: "S4",
          nextScreenId: "S5",
        ),
        Screen(
          questions: [
            Question(
              questionId: 6,
              questionOptionType: "dropdown",
              questionTitle: "Link Work Item",
              questionOption: "",
            ),
          ],
          title: "Link Work Item",
          isActive: true,
          previousScreenId: "S4",
          screenId: "S5",
          nextScreenId: "S6",
        ),
        Screen(
          questions: [
            Question(questionId: 7, questionOptionType: "dropdown", questionTitle: "Link Inventory", questionOption: ""),
          ],
          isActive: true,
          previousScreenId: "S5",
          screenId: "S6",
          title: "Link Inventory",
          nextScreenId: "S7",
        ),
        Screen(
          questions: [
            Question(questionId: 12, questionOptionType: "Assign", questionTitle: "Assign to", questionOption: ""),
          ],
          isActive: true,
          previousScreenId: "S6",
          title: "Assign to",
          screenId: "S7",
          nextScreenId: "S8",
        ),
      ], type: '')
    ];
    await TodoQuestion.addScreens(screensList);
  }

  // await InventoryQuestions.addScreens(screensList);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer(
      builder: (context, ref, child) {
        final currentUserData = ref.watch(userProvider).state;
        print(currentUserData.email);
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
                flex: size.width > 1340 ? 3 : 5,
                child: const Padding(
                  padding: EdgeInsets.only(top: 8, left: 0),
                  child: TodoListView(),
                ),
              ),
              size.width > 1200
                  ? Expanded(
                      flex: size.width > 1340 ? 3 : 5,
                      child: const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: WorkItemsList(),
                      ),
                    )
                  : Container(),
              Expanded(
                flex: size.width > 1340 ? 4 : 6,
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
                              padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
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
      },
    );
  }
}
