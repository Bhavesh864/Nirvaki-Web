// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:number_to_words/number_to_words.dart';

import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/firebase/detailsModels/inventory_details.dart';
import 'package:yes_broker/constants/firebase/questionModels/inventory_question.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/constants/validation/basic_validation.dart';
import 'package:yes_broker/riverpodstate/all_selected_ansers_provider.dart';
import 'package:yes_broker/widgets/questionaries/questions_form_photos_view.dart';
import 'package:yes_broker/widgets/questionaries/assign_user.dart';
import 'package:yes_broker/widgets/questionaries/google_maps.dart';
import '../../customs/custom_fields.dart';
import '../../customs/custom_text.dart';
import '../../customs/dropdown_field.dart';
import '../../customs/label_text_field.dart';
import '../../widgets/card/questions card/chip_button.dart';
import '../firebase/statesModel/state_c_ity_model.dart';
import '../utils/colors.dart';

Widget buildInventoryQuestions(
  Question question,
  List<Screen> screensDataList,
  int currentScreenIndex,
  AllChipSelectedAnwers notify,
  Function nextQuestion,
  bool isRentSelected,
  bool isPlotSelected,
  bool isEdit,
  List<Map<String, dynamic>> selectedValues,
  List<States> stateList,
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
                Column(
                  children: [
                    LabelTextInputField(
                      keyboardType: TextInputType.number,
                      onlyDigits: true,
                      onChanged: (newvalue) {
                        notify.add({"id": question.questionId, "item": newvalue.trim()});
                      },
                      inputController: controller,
                      isMandatory: true,
                      labelText: question.questionTitle,
                      validator: (value) {
                        if (!isChecked && value!.isEmpty) {
                          return "Please enter ${question.questionTitle}";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
            ],
          );
        },
      );
    }
    return StatefulBuilder(
      builder: (context, setState) {
        final isPriceField = question.questionId == 46 || question.questionId == 48 || question.questionId == 50;
        final isDigitsOnly = question.questionTitle.contains('Mobile') ||
            question.questionTitle == 'Rent' ||
            question.questionTitle == 'Listing Price' ||
            question.questionTitle.contains('Floor Number') ||
            question.questionTitle.contains('Property Area');

        final isvalidationtrue =
            question.questionTitle.contains('First') || question.questionTitle.contains('Mobile') || question.questionTitle == 'Rent' || question.questionTitle == 'Listing Price';

        final isEmail = question.questionTitle.contains("Email");
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabelTextInputField(
              onlyDigits: isDigitsOnly,
              keyboardType: isPriceField ? TextInputType.number : TextInputType.name,
              inputController: controller,
              labelText: question.questionTitle,
              isMandatory: isvalidationtrue,
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
              validator: isEmail
                  ? validateEmailNotMandatory
                  : isvalidationtrue
                      ? (value) {
                          if (value!.isEmpty) {
                            return "Please enter ${question.questionTitle}";
                          }
                          return null;
                        }
                      : null,
            ),
            isPriceField ? AppText(text: textResult.toUpperCase(), textColor: AppColor.grey, fontsize: 16) : const SizedBox.shrink(),
          ],
        );
      },
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
      }
      return AssignUser(
        addUser: (users) {
          notify.add({"id": question.questionId, "item": users});
        },
        assignedUserIds: userids,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  } else if (question.questionOptionType == 'dropdown') {
    String? defaultValue;
    final isState = question.questionTitle.contains("State");
    if (selectedValues.any((answer) => answer["id"] == question.questionId)) {
      defaultValue = selectedValues.firstWhere((answer) => answer["id"] == question.questionId)["item"] ?? "";
    }
    if (!isEdit && question.questionTitle.contains("Bedroom")) {
      defaultValue = "1";
    }
    if (isState) {
      try {
        List<String?> cities = [];
        final List<String?> states = stateList.map((e) => e.state).toList();
        return StatefulBuilder(builder: (context, setState) {
          void updateCitiesList(String? newSelectedState) {
            setState(() {
              cities = [];
            });
            print(cities);
            final index = states.indexOf(newSelectedState);
            if (index >= 0 && index < stateList.length && stateList[index].districts != null) {
              setState(() {
                cities = stateList[index].districts!;
              });
            }
          }

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 7),
            child: Column(
              children: [
                DropDownField(
                  title: question.questionTitle,
                  defaultValues: defaultValue ?? "",
                  optionsList: states,
                  onchanged: (Object e) {
                    final selectedState = e as String?;
                    updateCitiesList(selectedState);
                    notify.add({"id": question.questionId, "item": e});
                  },
                ),
                DropDownField(
                  title: "City",
                  defaultValues: defaultValue ?? "",
                  optionsList: cities,
                  onchanged: (Object e) {
                    notify.add({"id": 27, "item": e});
                  },
                ),
              ],
            ),
          );
        });
      } catch (e) {
        print(e.toString());
      }
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
      locality: locality,
    );
  } else if (question.questionOptionType == 'photo') {
    Propertyphotos? propertyphotos;
    if (isEdit) {
      if (selectedValues.any((answer) => answer["id"] == question.questionId)) {
        propertyphotos = selectedValues.firstWhere((answer) => answer["id"] == question.questionId)["item"];
      }
    }

    return PhotosViewForm(
      notify: notify,
      id: question.questionId,
      propertyphotos: propertyphotos,
      isEdit: isEdit,
    );
  }

  return const SizedBox.shrink();
}
