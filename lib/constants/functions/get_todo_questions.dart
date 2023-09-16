import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';

import 'package:yes_broker/riverpodstate/all_selected_ansers_provider.dart';

import 'package:yes_broker/widgets/questionaries/assign_user.dart';

import '../../Customs/custom_text.dart';
import '../../Customs/dropdown_field.dart';
import '../../Customs/label_text_field.dart';
import '../../widgets/card/questions card/chip_button.dart';
import '../firebase/questionModels/todo_question.dart';
import '../utils/colors.dart';

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
    final value = selectedValues.where((e) => e["id"] == question.questionId).toList();
    TextEditingController controller = TextEditingController(text: value.isNotEmpty ? value[0]["item"] : "");

    if (question.questionTitle == 'Due date') {
      return GestureDetector(
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
      );
    }

    return LabelTextInputField(
      inputController: controller,
      labelText: question.questionTitle,
      onChanged: (newvalue) {
        notify.add({"id": question.questionId, "item": newvalue.trim()});
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter ${question.questionTitle}";
        }
        return null;
      },
    );
  } else if (question.questionOptionType == 'textarea') {
    final value = selectedValues.where((e) => e["id"] == question.questionId).toList();
    TextEditingController controller = TextEditingController(text: value.isNotEmpty ? value[0]["item"] : "");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4, right: 8, left: 2),
          child: CustomText(
            title: question.questionTitle,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.left,
          ),
        ),
        TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: 5,
          controller: controller,
          onChanged: (newvalue) {
            notify.add({"id": question.questionId, "item": newvalue.trim()});
          },
          decoration: InputDecoration(
            hintText: 'Type here..',
            hintStyle: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w400),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(
                color: AppColor.primary,
              ),
            ),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return "Please enter ${question.questionTitle}";
            }
            return null;
          },
        ),
      ],
    );
  } else if (question.questionOptionType == "Assign") {
    return AssignUser(
      addUser: (user) {
        notify.add({"id": question.questionId, "item": user});
      },
    );
  } else if (question.questionOptionType == 'dropdown') {
    // String? defaultValue;
    // if (selectedValues.any((answer) => answer["id"] == question.questionId)) {
    //   defaultValue = selectedValues.firstWhere((answer) => answer["id"] == question.questionId)["item"] ?? "";
    // }
    return FutureBuilder(
        future: CardDetails.getCardDetails(),
        builder: (context, snapshot) {
          final List<String> options = [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (snapshot.hasData) {
            for (var data in snapshot.data!) {
              options.add(data.workitemId!);
            }
          }
          return DropDownField(
            defaultValues: "",
            title: question.questionTitle,
            optionsList: options,
            onchanged: (Object e) {
              CardDetails selectedUser = snapshot.data!.firstWhere((user) => user.workitemId == e);
              notify.add({"id": question.questionId, "item": selectedUser});
            },
          );
        });
  }
  return const SizedBox.shrink();
}
