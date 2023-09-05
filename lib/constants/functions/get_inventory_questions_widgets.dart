// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:yes_broker/constants/firebase/detailsModels/inventory_details.dart';

import 'package:yes_broker/constants/firebase/questionModels/inventory_question.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/riverpodstate/all_selected_ansers_provider.dart';
import 'package:yes_broker/widgets/questionaries/questions_form_photos_view.dart';
import 'package:yes_broker/widgets/questionaries/assign_user.dart';
import 'package:yes_broker/widgets/questionaries/google_maps.dart';
import '../../customs/custom_fields.dart';
import '../../customs/custom_text.dart';
import '../../customs/dropdown_field.dart';
import '../../customs/label_text_field.dart';
import '../../widgets/card/questions card/chip_button.dart';
import '../utils/colors.dart';

Widget buildInventoryQuestions(
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
              bgColor: selectedValues.any((answer) => answer["id"] == question.questionId && answer["item"] == option)
                  ? AppColor.primary.withOpacity(0.2)
                  : AppColor.primary.withOpacity(0.05),
              onSelect: () {
                nextQuestion(screensDataList: screensDataList, option: option);
                if (currentScreenIndex < screensDataList.length - 1) {
                  notify.add({"id": question.questionId, "item": option});
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
      selectedOption = selectedValues.firstWhere((answer) => answer["id"] == question.questionId)["item"] ?? "";
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
                      bgcolor: selectedOption == option ? AppColor.primary : AppColor.primary.withOpacity(0.05),
                      onSelected: (selectedItem) {
                        setState(() {
                          if (selectedOption == option) {
                            selectedOption = '';
                          } else {
                            selectedOption = option;
                          }
                        });
                        notify.add({"id": question.questionId, "item": selectedOption});
                      },
                      labelColor: selectedOption == option ? Colors.white : Colors.black,
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
    if (selectedValues.any((answer) => answer["id"] == question.questionId)) {
      selectedOptions = selectedValues.firstWhere((answer) => answer["id"] == question.questionId)["item"];
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
                  for (var item in question.questionOption)
                    Padding(
                      padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                      child: CustomChoiceChip(
                        label: item,
                        selected: selectedOptions.contains(item),
                        bgcolor: selectedOptions.contains(item) ? AppColor.primary : AppColor.primary.withOpacity(0.05),
                        onSelected: (selectedItem) {
                          setState(() {
                            if (selectedOptions.contains(item)) {
                              selectedOptions.remove(item);
                            } else {
                              selectedOptions.add(item);
                            }
                          });
                          notify.add({"id": question.questionId, "item": selectedOptions});
                        },
                        labelColor: selectedOptions.contains(item) ? Colors.white : Colors.black,
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  } else if (question.questionOptionType == 'textfield') {
    final value = selectedValues.where((e) => e["id"] == question.questionId).toList();
    TextEditingController controller = TextEditingController(text: value.isNotEmpty ? value[0]["item"] : "");
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
                    notify.add({"id": question.questionId, "item": newvalue.trim()});
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
    String? defaultValue;
    if (selectedValues.any((answer) => answer["id"] == question.questionId)) {
      defaultValue = selectedValues.firstWhere((answer) => answer["id"] == question.questionId)["item"];
    }
    return DropDownField(
      title: question.questionTitle,
      defaultValues: defaultValue ?? "",
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
    Propertyphotos? propertyphotos;
    if (selectedValues.any((answer) => answer["id"] == question.questionId)) {
      propertyphotos = selectedValues.firstWhere((answer) => answer["id"] == question.questionId)["item"];
    }
    return PhotosViewForm(notify: notify, id: question.questionId, propertyphotos: propertyphotos);
  }

  return const SizedBox.shrink();
}
