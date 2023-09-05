// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';

import 'package:yes_broker/constants/firebase/questionModels/lead_question.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/riverpodstate/all_selected_ansers_provider.dart';
import 'package:yes_broker/widgets/questionaries/questions_form_photos_view.dart';
import 'package:yes_broker/widgets/questionaries/assign_user.dart';
import 'package:yes_broker/widgets/questionaries/google_maps.dart';
import '../../Customs/custom_fields.dart';
import '../../Customs/custom_text.dart';
import '../../Customs/dropdown_field.dart';
import '../../Customs/label_text_field.dart';
import '../../widgets/card/questions card/chip_button.dart';
import '../utils/colors.dart';

Widget buildLeadQuestions(
  Question question,
  List<Screen> screensDataList,
  int currentScreenIndex,
  AllChipSelectedAnwers notify,
  Function nextQuestion,
  bool isRentSelected,
  List<Map<String, dynamic>> selectedValues,
) {
  if (question.questionOptionType == 'chip') {
    return Column(
      children: [
        for (var option in question.questionOption)
          StatefulBuilder(builder: (context, setState) {
            if (isRentSelected && option == "Plot") {
              return const SizedBox();
            }
            return ChipButton(
              text: option,
              bgColor: selectedValues.any((answer) =>
                      answer["id"] == question.questionId &&
                      answer["item"] == option)
                  ? AppColor.primary.withOpacity(0.2)
                  : AppColor.primary.withOpacity(0.05),
              onSelect: () {
                if (currentScreenIndex < screensDataList.length - 1) {
                  notify.add({"id": question.questionId, "item": option});
                  nextQuestion(
                      screensDataList: screensDataList, option: option);
                } else {
                  // Handle reaching the last question
                }
              },
            );
          }),
      ],
    );
  } else if (question.questionOptionType == 'smallchip') {
    String selectedOption = '';
    if (selectedValues.any((answer) => answer["id"] == question.questionId)) {
      selectedOption = selectedValues
          .firstWhere((answer) => answer["id"] == question.questionId)["item"];
    }

    return StatefulBuilder(builder: (context, setState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            fontWeight: FontWeight.w500,
            size: 16,
            title: question.questionTitle,
          ),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.start,
              children: [
                for (var option in question.questionOption)
                  Padding(
                    padding: const EdgeInsets.only(right: 10, bottom: 10),
                    child: CustomChoiceChip(
                      label: option,
                      selected: selectedOption == option,
                      onSelected: (selectedItem) {
                        setState(() {
                          if (selectedOption == option) {
                            selectedOption = '';
                          } else {
                            selectedOption = option;
                          }
                        });
                        notify.add({"id": question.questionId, "item": option});
                      },
                      labelColor: selectedOption == option
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
    });
  } else if (question.questionOptionType == 'multichip') {
    List<String> selectedOptions = [];
    List items = question.questionOption;
    if (selectedValues.any((answer) => answer["id"] == question.questionId)) {
      selectedOptions = selectedValues
          .firstWhere((answer) => answer["id"] == question.questionId)["item"];
    }
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              fontWeight: FontWeight.w500,
              size: 16,
              title: question.questionTitle,
            ),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.start,
                children: [
                  for (var item in items)
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                      child: CustomChoiceChip(
                          label: item,
                          selected: selectedOptions.contains(item),
                          onSelected: (selectedItem) {
                            setState(() {
                              if (selectedItem) {
                                selectedOptions.add(item);
                              } else {
                                selectedOptions.remove(item);
                              }
                            });
                            notify.add({
                              "id": question.questionId,
                              "item": selectedOptions
                            });
                          },
                          labelColor: selectedOptions.contains(item)
                              ? Colors.white
                              : Colors.black),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  } else if (question.questionOptionType == 'textfield') {
    final value =
        selectedValues.where((e) => e["id"] == question.questionId).toList();
    TextEditingController controller =
        TextEditingController(text: value.isNotEmpty ? value[0]["item"] : "");
    // TextEditingController controller = TextEditingController();
    bool isChecked = true;

    if (question.questionTitle == 'Whatsapp Number') {
      return StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              if (question.questionTitle == 'Whatsapp Number')
                CustomCheckbox(
                  value: isChecked,
                  label: 'Use this as whatsapp number',
                  onChanged: (value) {
                    setState(() {
                      isChecked = value;
                    });
                  },
                ),
              if (!isChecked)
                LabelTextInputField(
                  onChanged: (newvalue) {
                    notify.add(
                        {"id": question.questionId, "item": newvalue.trim()});
                  },
                  inputController: controller,
                  labelText: question.questionTitle,
                  validator: (value) {
                    if (isChecked && value!.isEmpty) {
                      return "Please enter ${question.questionTitle}";
                    }
                    return null;
                  },
                ),
            ],
          );
        },
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
    return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: 5,
      onChanged: (newvalue) {
        notify.add({"id": question.questionId, "item": newvalue.trim()});
      },
      decoration: InputDecoration(
        hintText: question.questionOption,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        // isDense: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
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
    );
  } else if (question.questionOptionType == "Assign") {
    return AssignUser(
      addUser: (user) {
        notify.add({"id": question.questionId, "item": user});
      },
    );
  } else if (question.questionOptionType == 'dropdown') {
    return DropDownField(
      title: question.questionTitle,
      optionsList: question.questionOption,
      onchanged: (Object e) {
        notify.add({"id": question.questionId, "item": e});
      },
    );
  } else if (question.questionOptionType == 'map') {
    final state = getDataById(notify.state, 26);
    final city = getDataById(notify.state, 27);
    final address1 = getDataById(notify.state, 28);
    final address2 = getDataById(notify.state, 29);
    return CustomGoogleMap(
      onLatLngSelected: (latLng) {
        notify.add({
          "id": question.questionId,
          "item": [latLng.latitude, latLng.longitude]
        });
      },
      cityName: city,
      stateName: state,
      address1: address1,
      address2: address2,
    );
  } else if (question.questionOptionType == 'photo') {
    return PhotosViewForm(notify, question.questionId);
  }

  return const SizedBox.shrink();
}
