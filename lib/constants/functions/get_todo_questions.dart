import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/validation/basic_validation.dart';

import 'package:yes_broker/riverpodstate/all_selected_ansers_provider.dart';

import 'package:yes_broker/widgets/questionaries/assign_user.dart';

import '../../Customs/dropdown_field.dart';
import '../../Customs/label_text_field.dart';
import '../../widgets/card/questions card/chip_button.dart';
import '../firebase/questionModels/todo_question.dart';
import '../firebase/userModel/user_info.dart';
import '../utils/colors.dart';
import 'calendar/calendar_functions.dart';
import 'filterdataAccordingRole/data_according_role.dart';

Widget buildTodoQuestions(
  Question question,
  List<Screen> screensDataList,
  int currentScreenIndex,
  AllChipSelectedAnwers notify,
  Function nextQuestion,
  BuildContext context,
  List<Map<String, dynamic>> selectedValues,
  Function(bool value) linkState,
  WidgetRef ref,
  User currentUser,
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
      fontWeight: FontWeight.normal,
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
    List<User> userList = [];
    // String? defaultValue;
    String? selectedvalue;

    // if (selectedValues.any((answer) => answer["id"] == question.questionId)) {
    //   defaultValue = selectedValues.firstWhere((answer) => answer["id"] == question.questionId)["item"] ?? "";
    // }
    return FutureBuilder(
        future: CardDetails.getCardDetails(),
        builder: (context, snapshot) {
          final List options = [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (snapshot.hasData) {
            final filterItem = filterCardsAccordingToRoleInFutureBuilder(snapshot: snapshot, ref: ref, userList: userList, currentUser: currentUser);
            List<CardDetails> listofCards = filterItem!.where((user) => user.workitemId!.contains("IN") || user.workitemId!.contains("LD")).toList();
            for (var data in listofCards) {
              final newData = "${data.cardTitle} (${data.workitemId})";
              options.add(newData);
            }
          }
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 7),
              child: CustomDropdownFormField<String>(
                label: question.questionTitle,
                value: selectedvalue,
                isMandatory: true,
                items: options,
                onChanged: (value) {
                  setState(() {
                    selectedvalue = value;
                  });
                  notify.add({"id": question.questionId, "item": value});
                },
                validator: (p0) => validateForNormalFeild(value: p0, props: question.questionTitle),
              ),
            );
          });
          // return DropDownField(
          //   defaultValues: "",
          //   title: question.questionTitle,
          //   optionsList: options,
          //   isMultiValueOnDropdownlist: true,
          //   onchanged: (Object e) {
          //     // CardDetails selectedUser = snapshot.data!.firstWhere((user) => user.workitemId == e);
          //     CardDetails selectedUser = snapshot.data!.firstWhere((user) => "${user.cardTitle} (${user.workitemId})" == e);
          //     notify.add({"id": question.questionId, "item": selectedUser});
          //   },
          // );
        });
  }
  return const SizedBox.shrink();
}
