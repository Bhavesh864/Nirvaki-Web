// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:number_to_words/number_to_words.dart';

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
import '../firebase/detailsModels/lead_details.dart';
import '../utils/colors.dart';
import 'convertStringTorange/convert_range_string.dart';

Widget buildLeadQuestions(
  Question question,
  List<Screen> screensDataList,
  int currentScreenIndex,
  AllChipSelectedAnwers notify,
  Function nextQuestion,
  bool isRentSelected,
  bool isEdit,
  bool isPlotSelected,
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
  } else if (question.questionOptionType == 'smallchip') {
    String selectedOption = '';
    if (selectedValues.any((answer) => answer["id"] == question.questionId)) {
      selectedOption = selectedValues.firstWhere((answer) => answer["id"] == question.questionId)["item"] ?? "";
    }
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 7),
        child: Column(
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
        ),
      );
    });
  } else if (question.questionOptionType == 'multichip') {
    List<String> selectedOptions = [];
    List items = question.questionOption;
    if (selectedValues.any((answer) => answer["id"] == question.questionId)) {
      selectedOptions = selectedValues.firstWhere((answer) => answer["id"] == question.questionId)["item"];
    }
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 7),
          child: Column(
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
                        padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
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
                              notify.add({"id": question.questionId, "item": selectedOptions});
                            },
                            labelColor: selectedOptions.contains(item) ? Colors.white : Colors.black),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  } else if (question.questionOptionType == 'textfield') {
    String textResult = '';

    final value = selectedValues.where((e) => e["id"] == question.questionId).toList();
    TextEditingController controller = TextEditingController(text: value.isNotEmpty ? value[0]["item"] : "");

    bool isChecked = true;
    if (isPlotSelected && question.questionId == 30) {
      return const SizedBox();
    }
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
    return StatefulBuilder(
      builder: (context, setState) {
        final isPriceField = question.questionId == 46 || question.questionId == 48 || question.questionId == 50;
        final isvalidationtrue =
            question.questionTitle.contains('First') || question.questionTitle.contains('Mobile') || question.questionTitle == 'Rent' || question.questionTitle == 'Listing Price';
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabelTextInputField(
              keyboardType: isPriceField ? TextInputType.number : TextInputType.name,
              inputController: controller,
              labelText: question.questionTitle,
              onChanged: (newvalue) {
                try {
                  int number = int.parse(newvalue);
                  String words = NumberToWord().convert("en-in", number);
                  setState(() {
                    textResult = words;
                  });
                } catch (e) {
                  setState(() {
                    textResult = '';
                  });
                }
                notify.add({"id": question.questionId, "item": newvalue.trim()});
              },
              validator: isvalidationtrue
                  ? (value) {
                      if (value!.isEmpty) {
                        return "Please enter ${question.questionTitle}";
                      }
                      return null;
                    }
                  : null,
            ),
            isPriceField ? Text(textResult) : const SizedBox.shrink(),
          ],
        );
      },
    );
  } else if (question.questionOptionType == "Assign") {
    try {
      List<Assignedto> assignedusers = [];
      List<String> userids = [];
      if (isEdit) {
        if (selectedValues.any((answer) => answer["id"] == question.questionId)) {
          assignedusers = selectedValues.firstWhere((answer) => answer["id"] == question.questionId)["item"];
        }
        for (var user in assignedusers) {
          userids.add(user.userid!);
        }
        print(userids);
      }
      return AssignUser(
        addUser: (users) {
          notify.add({"id": question.questionId, "item": users});
        },
        assignedUserIds: userids,
      );
    } catch (e) {
      print(e);
    }
  } else if (question.questionOptionType == 'dropdown') {
    String? defaultValue;
    if (selectedValues.any((answer) => answer["id"] == question.questionId)) {
      defaultValue = selectedValues.firstWhere((answer) => answer["id"] == question.questionId)["item"] ?? "";
    }
    if (!isEdit && question.questionTitle.contains("Bedroom")) {
      defaultValue = "1";
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 7),
      child: DropDownField(
        title: question.questionTitle,
        defaultValues: defaultValue ?? "",
        optionsList: question.questionOption,
        onchanged: (Object e) {
          notify.add({"id": question.questionId, "item": e});
        },
      ),
    );
  } else if (question.questionOptionType == 'map') {
    final state = getDataById(selectedValues, 26);
    final city = getDataById(selectedValues, 27);
    final address1 = getDataById(selectedValues, 28);
    final address2 = getDataById(selectedValues, 29);
    final locality = getDataById(selectedValues, 54);
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
        locality: locality);
  } else if (question.questionOptionType == 'photo') {
    return PhotosViewForm(
      notify: notify,
      id: question.questionId,
      isEdit: isEdit,
    );
  } else if (question.questionOptionType == 'textarea') {
    final value = selectedValues.where((e) => e["id"] == question.questionId).toList();
    TextEditingController controller = TextEditingController(text: value.isNotEmpty ? value[0]["item"] : "");
    return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: 5,
      controller: controller,
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
  } else if (question.questionOptionType == "rangeSlider") {
    RangeValues? stateValue;
    if (selectedValues.any((answer) => answer["id"] == question.questionId)) {
      stateValue = selectedValues.firstWhere((answer) => answer["id"] == question.questionId)["item"] ?? "";
    }
    RangeValues buyRangeValues = const RangeValues(0, 100000000);
    RangeValues rentRangeValues = const RangeValues(0, 1000000);
    RangeValues defaultBuyRangeValues = stateValue ?? buyRangeValues;
    RangeValues defaultRentRangeValues = stateValue ?? rentRangeValues;
    if (isRentSelected) {
      double divisionValue = 5000;
      return StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              CustomText(
                title: 'Rent: ${formatValue(defaultRentRangeValues.start)} - ${formatValue(defaultRentRangeValues.end)}',
                size: 14,
              ),
              RangeSlider(
                values: defaultRentRangeValues,
                min: 0,
                max: 1000000,
                labels: RangeLabels(
                  formatValue(defaultRentRangeValues.start),
                  formatValue(defaultRentRangeValues.end),
                ),
                divisions: (100000000 - 1000) ~/ divisionValue,
                onChanged: (RangeValues newVal) {
                  setState(() {
                    defaultRentRangeValues = newVal;
                  });
                  notify.add({"id": question.questionId, "item": defaultRentRangeValues});
                },
              ),
            ],
          );
        },
      );
    } else {
      double divisionValue = 50000;
      return StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              CustomText(
                title: 'Buy: ${formatValue(defaultBuyRangeValues.start)} - ${formatValue(defaultBuyRangeValues.end)}',
                size: 14,
              ),
              RangeSlider(
                values: defaultBuyRangeValues,
                min: 0,
                max: 1000000000,
                labels: RangeLabels(
                  formatValue(defaultBuyRangeValues.start),
                  formatValue(defaultBuyRangeValues.end),
                ),
                divisions: (100000000 - 100000) ~/ divisionValue,
                onChanged: (RangeValues newVal) {
                  setState(() {
                    defaultBuyRangeValues = newVal;
                  });
                  notify.add({"id": question.questionId, "item": defaultBuyRangeValues});
                },
              ),
            ],
          );
        },
      );
    }
  }

  return const SizedBox.shrink();
}
