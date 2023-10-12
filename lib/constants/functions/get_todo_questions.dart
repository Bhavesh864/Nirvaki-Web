import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/validation/basic_validation.dart';

import 'package:yes_broker/riverpodstate/all_selected_ansers_provider.dart';

import 'package:yes_broker/widgets/questionaries/assign_user.dart';

import '../../Customs/custom_text.dart';
import '../../Customs/dropdown_field.dart';
import '../../Customs/label_text_field.dart';
import '../../widgets/card/questions card/chip_button.dart';
import '../firebase/questionModels/todo_question.dart';
import '../utils/colors.dart';
import 'calendar/calendar_functions.dart';

Widget buildTodoQuestions(
  Question question,
  List<Screen> screensDataList,
  int currentScreenIndex,
  AllChipSelectedAnwers notify,
  Function nextQuestion,
  BuildContext context,
  List<Map<String, dynamic>> selectedValues,
  Function(bool value) linkState,
) {
  if (question.questionOptionType == 'chip') {
    return Column(
      children: [
        for (var option in question.questionOption)
          StatefulBuilder(builder: (context, setState) {
            return ChipButton(
              text: option,
              bgColor: selectedValues.any((answer) => answer["id"] == question.questionId && answer["item"] == option)
                  ? AppColor.primary.withOpacity(0.2)
                  : AppColor.primary.withOpacity(0.05),
              onSelect: () {
                if (option == 'Yes') {
                  linkState(true);
                } else {
                  linkState(false);
                }
                if (currentScreenIndex < screensDataList.length - 1) {
                  notify.add({"id": question.questionId, "item": option});
                  nextQuestion(screensDataList: screensDataList, option: option);
                } else {
                  // Handle reaching the last question
                }
              },
            );
          }),
      ],
    );
  } else if (question.questionOptionType == 'textfield') {
    String? dueTime = "";
    final existingTime = selectedValues.any((element) => element["id"] == 13);
    if (existingTime) {
      dueTime = selectedValues.firstWhere((element) => element["id"] == 13)["item"];
    }
    final value = selectedValues.where((e) => e["id"] == question.questionId).toList();
    TextEditingController controller = TextEditingController(text: value.isNotEmpty ? value[0]["item"] : "");
    TextEditingController timeController = TextEditingController(text: dueTime);

    if (question.questionTitle == 'Due date') {
      return Column(
        children: [
          GestureDetector(
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(DateTime.now().year + 1),
              ).then(
                (pickedDate) {
                  if (pickedDate == null) {
                    return;
                  }
                  DateFormat formatter = DateFormat('dd-MM-yyyy');
                  controller.text = formatter.format(pickedDate);
                  notify.add({"id": question.questionId, "item": controller.text});
                },
              );
            },
            child: LabelTextInputField(
              isDatePicker: true,
              onChanged: (newvalue) {
                notify.add({"id": question.questionId, "item": newvalue.trim()});
              },
              hintText: 'DD/MM/YYYY',
              inputController: controller,
              labelText: question.questionTitle,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter ${question.questionTitle}";
                }
                return null;
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              pickFromDateTime(
                pickDate: false,
                pickedDate: DateTime.now(),
                context: context,
                dateController: controller,
                timeController: timeController,
              ).then((value) => {
                    notify.add({"id": 13, "item": timeController.text})
                  });
            },
            child: LabelTextInputField(
              isDatePicker: true,
              onChanged: (newvalue) {
                notify.add({"id": 13, "item": newvalue.trim()});
              },
              hintText: 'HH:MM',
              rightIcon: Icons.schedule,
              inputController: timeController,
              labelText: 'Due time',
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter due time";
                }
                return null;
              },
            ),
          ),
        ],
      );
    }
    return LabelTextInputField(
      keyboardType: TextInputType.name,
      inputController: controller,
      isMandatory: true,
      labelText: question.questionTitle,
      onChanged: (newvalue) {
        notify.add({"id": question.questionId, "item": newvalue.trim()});
      },
      validator: (value) => validateForNormalFeild(value: value, props: "Title"),
    );
  } else if (question.questionOptionType == 'textarea') {
    final value = selectedValues.where((e) => e["id"] == question.questionId).toList();
    TextEditingController controller = TextEditingController(text: value.isNotEmpty ? value[0]["item"] : "");
    return LabelTextAreaField(
      labelText: question.questionTitle,
      inputController: controller,
      onChanged: (newvalue) {
        notify.add({"id": question.questionId, "item": newvalue.trim()});
      },
      validator: (value) => validateForNormalFeild(value: value, props: "Description"),
    );
  } else if (question.questionOptionType == "Assign") {
    return AssignUser(
      addUser: (user) {
        notify.add({"id": question.questionId, "item": user});
      },
      assignedUserIds: const [],
    );
  } else if (question.questionOptionType == 'dropdown') {
    // String? defaultValue;
    // if (selectedValues.any((answer) => answer["id"] == question.questionId)) {
    //   defaultValue = selectedValues.firstWhere((answer) => answer["id"] == question.questionId)["item"] ?? "";
    // }
    return FutureBuilder(
        future: CardDetails.getCardDetails(),
        builder: (context, snapshot) {
          // String defaultDropdownValue = defaultValue ?? "";
          final List options = [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: DropDownField(
                title: "",
                optionsList: const [],
                onchanged: (e) {},
                defaultValues: "",
              ),
            );
          } else if (snapshot.hasData) {
            List<CardDetails> listofCards = snapshot.data!.where((user) => user.workitemId!.contains("IN") || user.workitemId!.contains("LD")).toList();
            for (var data in listofCards) {
              final newData = "${data.cardTitle} (${data.workitemId})";
              options.add(newData);
            }
          }
          return DropDownField(
            defaultValues: "",
            title: question.questionTitle,
            optionsList: options,
            isMultiValueOnDropdownlist: true,
            onchanged: (Object e) {
              CardDetails selectedUser = snapshot.data!.firstWhere((user) => "${user.cardTitle} (${user.workitemId})" == e);
              notify.add({"id": question.questionId, "item": selectedUser});
            },
          );
        });
  }
  return const SizedBox.shrink();
}
