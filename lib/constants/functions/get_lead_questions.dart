// ignore_for_file: invalid_use_of_protected_member
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:number_to_words/number_to_words.dart';

import 'package:yes_broker/constants/firebase/detailsModels/lead_details.dart';
import 'package:yes_broker/riverpodstate/arearange_state.dart';
import '../../Customs/snackbar.dart';
import '../../Customs/text_utility.dart';
import '../../customs/dropdown_field.dart';
import '../../pages/Auth/signup/company_details.dart';
import '../../pages/Auth/signup/country_code_modal.dart';
import 'convertStringTorange/convert_range_string.dart';
import 'package:yes_broker/constants/firebase/questionModels/lead_question.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/constants/validation/basic_validation.dart';
import 'package:yes_broker/riverpodstate/all_selected_ansers_provider.dart';
import 'package:yes_broker/widgets/questionaries/questions_form_photos_view.dart';
import 'package:yes_broker/widgets/questionaries/assign_user.dart';
import '../../Customs/custom_fields.dart';
import '../../Customs/custom_text.dart';
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
    bool isEdit,
    bool isPlotSelected,
    List<Map<String, dynamic>> selectedValues,
    bool isMobileNoEmpty,
    bool iswhatsappMobileNoEmpty,
    bool isChecked,
    Function(bool) isCheckedUpdate,
    WidgetRef ref,
    bool isBuy) {
  final areaRange = ref.watch(areaRangeSelectorState);
  final selectedOption = ref.watch(selectedOptionNotifier);
  final defaultAreaRangeValues = ref.watch(defaultAreaRangeValuesNotifier);

  if (question.questionOptionType == 'chip') {
    return Column(
      children: [
        for (var option in question.questionOption)
          StatefulBuilder(builder: (context, setState) {
            if (isRentSelected && option == "Plot") {
              return const SizedBox();
            }
            if (screensDataList.any((element) => element.screenId == "S2")) {
              if (isEdit) {
                if (isBuy && isRentSelected) {
                  final indexToRemove = selectedValues.indexWhere((map) => map['id'] == 32);
                  if (indexToRemove != -1) {
                    selectedValues.removeAt(indexToRemove);
                    selectedValues = selectedValues;
                  }
                }
              } else if (option == "Rent" || option == "Buy" && !isEdit) {
                final indexToRemove = selectedValues.indexWhere((map) => map['id'] == 32);
                if (indexToRemove != -1) {
                  selectedValues.removeAt(indexToRemove);
                  selectedValues = selectedValues;
                }
              }
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
    String selectedchipOption = '';

    if (selectedValues.any((answer) => answer["id"] == question.questionId)) {
      selectedchipOption = selectedValues.firstWhere((answer) => answer["id"] == question.questionId)["item"] ?? "";
    }
    if (isEdit && question.questionId == 23) {
      print("selectedchipOption---> $selectedchipOption");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(selectedOptionNotifier.notifier).setRange(selectedchipOption);
      });
    }
    // if (!isEdit && question.questionId == 23) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     // ref.read(selectedOptionNotifier.notifier).setRange(selectedchipOption);
    //     notify.add({"id": question.questionId, "item": "Sq ft"});
    //   });
    // }

    if (!isEdit && question.questionId == 47) {
      selectedchipOption = 'Ft';
      Future.delayed(const Duration(seconds: 1)).then((value) => notify.add({"id": 47, "item": "Ft"}));
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
                        child: question.questionId == 23
                            ? CustomChoiceChip(
                                label: option,
                                selected: selectedOption == option,
                                bgcolor: selectedOption == option ? AppColor.primary : AppColor.primary.withOpacity(0.05),
                                onSelected: (selectedItem) {
                                  setState(() {
                                    if (selectedOption != option) {
                                      ref.read(selectedOptionNotifier.notifier).setRange(option);
                                      notify.add({"id": question.questionId, "item": option});
                                      if (option == "Sq ft") {
                                        ref.read(areaRangeSelectorState.notifier).setRange(const RangeValues(100, 10000));
                                      } else if (option == "Sq yard") {
                                        ref.read(areaRangeSelectorState.notifier).setRange(const RangeValues(50, 5000));
                                      } else if (option == "Acre") {
                                        ref.read(areaRangeSelectorState.notifier).setRange(const RangeValues(0.25, 50));
                                      }
                                      final range = ref.watch(areaRangeSelectorState);
                                      ref.read(defaultAreaRangeValuesNotifier.notifier).setRange(range);
                                      notify.add({"id": 24, "item": range});
                                    }
                                  });
                                },
                                labelColor: selectedOption == option ? Colors.white : Colors.black,
                              )
                            : CustomChoiceChip(
                                label: option,
                                selected: selectedchipOption == option,
                                bgcolor: selectedchipOption == option ? AppColor.primary : AppColor.primary.withOpacity(0.05),
                                onSelected: (selectedItem) {
                                  setState(() {
                                    if (selectedchipOption != option && question.questionId != 23 && question.questionId != 24) {
                                      selectedchipOption = option;
                                      notify.add({"id": question.questionId, "item": option});
                                    }
                                  });
                                },
                                labelColor: selectedchipOption == option ? Colors.white : Colors.black,
                              )),
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
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.start,
                  children: [
                    for (var item in items)
                      Padding(
                        padding: const EdgeInsets.only(right: 5, top: 5, bottom: 5),
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
    print("leadmobilefild---------------");

    String textResult = '';

    final value = selectedValues.where((e) => e["id"] == question.questionId).toList();
    TextEditingController controller = TextEditingController(
        text: question.questionId == 56
            ? ""
            : value.isNotEmpty
                ? value[0]["item"]
                : "");
    String mobileCountryCode = '+91';
    String whatsappCountryCode = '+91';

    if (question.questionTitle == 'Mobile' && value.isNotEmpty) {
      List<String> splitString = value[0]["item"].split(' ');
      if (splitString.length == 2) {
        mobileCountryCode = splitString[0];
        controller.text = splitString[1];
      }
    }
    if (question.questionTitle == 'Whatsapp Number' && value.isNotEmpty) {
      List<String> splitString = value[0]["item"].split(' ');
      if (splitString.length == 2) {
        whatsappCountryCode = splitString[0];
        controller.text = splitString[1];
      }
    }
    void openModal({BuildContext? context, setState, bool? forMobile = true}) {
      showDialog(
        context: context!,
        builder: (context) {
          return CountryCodeModel(onCountrySelected: (data) {
            if (data.isNotEmpty) {
              setState(() {
                if (forMobile == true) {
                  mobileCountryCode = data;
                } else {
                  whatsappCountryCode = data;
                }
              });
              notify.add({"id": question.questionId, "item": "$data ${controller.text}"});
            }
          });
        },
      );
    }

    if (isPlotSelected && question.questionId == 30) {
      return const SizedBox();
    }

    if (question.questionTitle == 'Mobile') {
      return StatefulBuilder(builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MobileNumberInputField(
              fromProfile: true,
              controller: controller,
              hintText: question.questionTitle,
              isEmpty: isMobileNoEmpty,
              openModal: () {
                openModal(context: context, setState: setState);
              },
              countryCode: mobileCountryCode,
              onChange: (value) {
                notify.add({"id": question.questionId, "item": "$mobileCountryCode ${value.trim()}"});
              },
            ),
            if (isMobileNoEmpty)
              const Padding(
                padding: EdgeInsets.only(left: 15.0, bottom: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AppText(
                    text: 'Please enter Mobile Number',
                    textColor: Colors.red,
                    fontsize: 12,
                  ),
                ),
              ),
          ],
        );
      });
    }

    if (question.questionTitle == 'Whatsapp Number') {
      return StatefulBuilder(
        builder: (context, setState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (question.questionTitle == 'Whatsapp Number')
                CustomCheckbox(
                  value: isChecked,
                  label: 'Use this as whatsapp number',
                  onChanged: (value) {
                    isCheckedUpdate(value);
                  },
                ),
              if (!isChecked) ...[
                MobileNumberInputField(
                  fromProfile: true,
                  controller: controller,
                  hintText: question.questionTitle,
                  isEmpty: iswhatsappMobileNoEmpty,
                  openModal: () {
                    openModal(context: context, setState: setState, forMobile: false);
                  },
                  countryCode: whatsappCountryCode,
                  onChange: (value) {
                    notify.add({"id": question.questionId, "item": "$whatsappCountryCode ${value.trim()}"});
                  },
                ),
                if (!isChecked && iswhatsappMobileNoEmpty)
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0, bottom: 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AppText(
                        text: 'Please enter Whatsapp Number',
                        textColor: Colors.red,
                        fontsize: 12,
                      ),
                    ),
                  ),
              ],
            ],
          );
        },
      );
    }

    if (question.questionId == 56) {
      List<LocalityNames> selectedLocality = [];
      if (selectedValues.any((answer) => answer["id"] == question.questionId)) {
        selectedLocality = selectedValues.firstWhere((answer) => answer["id"] == question.questionId)["item"] ?? [];
      }

      List placesList = [];
      return StatefulBuilder(builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabelTextInputField(
              labelText: 'Search your location',
              inputController: controller,
              hintText: "Search here...",
              validator: (value) {
                if (selectedLocality.isEmpty) {
                  return "Please Add your Preffered Location";
                }
                return null;
              },
              onChanged: (value) {
                // if (selectedLocality.length < 5) {
                getPlaces(value).then((places) {
                  final descriptions = places.predictions?.map((prediction) => prediction.description) ?? [];
                  setState(() {
                    placesList = descriptions.toList();
                  });
                });
                // }
              },
            ),
            if (placesList.isNotEmpty) ...[
              Container(
                height: 200,
                decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0.8), borderRadius: BorderRadius.circular(8)),
                margin: const EdgeInsets.symmetric(horizontal: 7),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: placesList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: AppText(
                        fontsize: 13,
                        text: placesList[index],
                        textColor: Colors.black,
                      ),
                      onTap: () {
                        if (selectedLocality.length >= 5) {
                          customSnackBar(context: context, text: "You can add maximum 5 Localities");
                          controller.clear();
                          setState(() {
                            placesList = [];
                          });
                          return;
                        }
                        final str = placesList[index];
                        try {
                          List<String> words = str.split(' ');
                          if (words.length >= 3) {
                            String lastThreeWords = words.sublist(words.length - 3).join(' ');
                            String remainingWords = words.sublist(0, words.length - 3).join(' ');
                            List<String> lastThreeWordsList = lastThreeWords.split(' ');
                            if (lastThreeWordsList.isNotEmpty) {
                              lastThreeWordsList.removeLast();
                              lastThreeWords = lastThreeWordsList.join(' ');
                            }
                            final cityName = lastThreeWordsList[0].endsWith(',') ? lastThreeWordsList[0].replaceFirst(RegExp(r',\s*$'), '') : lastThreeWordsList[0];
                            final stateName = lastThreeWordsList[1].endsWith(',') ? lastThreeWordsList[1].replaceFirst(RegExp(r',\s*$'), '') : lastThreeWordsList[1];
                            controller.text = str;
                            if (selectedLocality.length < 5) {
                              selectedLocality.add(LocalityNames(city: cityName, locality: remainingWords, fullAddress: str, state: stateName));
                            }
                            notify.add({"id": question.questionId, "item": selectedLocality});
                            setState(() {
                              placesList = [];
                            });
                            controller.clear();
                          } else {
                            setState(() {
                              placesList = [];
                            });
                            customSnackBar(context: context, text: 'Choose a proper address');
                          }
                        } catch (e) {
                          setState(() {
                            placesList = [];
                          });
                        }
                      },
                    );
                  },
                ),
              ),
            ],
            selectedLocality.isNotEmpty
                ? Wrap(
                    children: selectedLocality.map((locality) {
                      return Padding(
                        padding: const EdgeInsets.all(4),
                        child: Chip(
                          backgroundColor: AppColor.secondary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          label: AppText(
                            text: locality.fullAddress!,
                            fontsize: 14,
                          ),
                          onDeleted: () {
                            setState(() {
                              selectedLocality.remove(locality);
                            });
                          },
                        ),
                      );
                    }).toList(),
                  )
                : const SizedBox()
          ],
        );
      });
    }
    return StatefulBuilder(
      builder: (context, setState) {
        final isPriceField = question.questionId == 46 || question.questionId == 48 || question.questionId == 50;
        final isDigitsOnly = question.questionTitle.contains('Mobile') || question.questionTitle.contains('Property Area') || question.questionId == 22;
        final isvalidationtrue = question.questionTitle.contains('First') ||
            question.questionTitle.contains('Mobile') ||
            question.questionTitle == 'Rent' ||
            question.questionTitle == 'Listing Price' ||
            question.questionTitle.contains('Property Area');

        final isEmail = question.questionTitle.contains("Email");
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabelTextInputField(
              onlyDigits: isDigitsOnly,
              keyboardType: isPriceField || isDigitsOnly ? TextInputType.number : TextInputType.name,
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
            isPriceField
                ? Container(margin: const EdgeInsets.all(7), child: AppText(text: textResult.toUpperCase(), textColor: AppColor.grey, fontsize: 16))
                : const SizedBox.shrink(),
            // const SizedBox(
            //   height: 6,
            // ),
          ],
        );
      },
    );
  } else if (question.questionOptionType == "Assign") {
    try {
      var assignedusers = [];
      List<String> userids = [];
      if (isEdit) {
        if (selectedValues.any((answer) => answer["id"] == question.questionId)) {
          assignedusers = selectedValues.firstWhere((answer) => answer["id"] == question.questionId)["item"];
        }
        for (var user in assignedusers) {
          if (user is User) {
            userids.add(user.userId);
          } else {
            userids.add(user.userid!);
          }
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
    String? selectedvalue;
    if (selectedValues.any((answer) => answer["id"] == question.questionId)) {
      defaultValue = selectedValues.firstWhere((answer) => answer["id"] == question.questionId)["item"];
    }
    final isvalidationtrue = question.questionId == 14;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 7),
      child: StatefulBuilder(builder: (context, setState) {
        return CustomDropdownFormField<String>(
          label: question.questionTitle,
          value: defaultValue ?? selectedvalue,
          isMandatory: isvalidationtrue,
          items: question.questionOption,
          onChanged: (value) {
            setState(() {
              selectedvalue = value;
            });
            notify.add({"id": question.questionId, "item": value});
          },
          validator: isvalidationtrue ? (p0) => validateForNormalFeild(value: p0, props: question.questionTitle) : null,
        );
      }),
    );
  } else if (question.questionOptionType == 'map') {
    // List? defaultValue;

    // if (selectedValues.any((answer) => answer["id"] == question.questionId)) {
    //   defaultValue = selectedValues.firstWhere((answer) => answer["id"] == question.questionId)["item"] ?? "";
    // }
    // final state = getDataById(selectedValues, 26);
    // final city = getDataById(selectedValues, 27);
    // final address1 = getDataById(selectedValues, 28);
    // final address2 = getDataById(selectedValues, 29);
    // final locality = getDataById(selectedValues, 54);

    // return CustomGoogleMap(
    //   isEdit: isEdit,
    //   latLng: isEdit ? LatLng(defaultValue![0], defaultValue[1]) : null,
    //   selectedValues: selectedValues,
    //   onLatLngSelected: (latLng) {
    //     notify.add({
    //       "id": question.questionId,
    //       "item": [latLng.latitude, latLng.longitude]
    //     });
    //   },
    //   cityName: city,
    //   stateName: state,
    //   address1: address1,
    //   address2: address2,
    //   locality: locality,
    // );
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
    if (question.questionId == 32) {
      RangeValues buyRangeValues = const RangeValues(500000, 50000000);
      RangeValues rentRangeValues = const RangeValues(0, 1000000);
      RangeValues defaultBuyRangeValues = stateValue ?? buyRangeValues;
      RangeValues defaultRentRangeValues = stateValue ?? rentRangeValues;
      if (selectedValues.isNotEmpty && !selectedValues.any((element) => element["id"] == 32)) {
        if (isRentSelected) {
          stateValue = const RangeValues(0, 1000000);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            notify.add({"id": 32, "item": stateValue});
          });
        } else if (!isRentSelected) {
          stateValue = const RangeValues(500000, 50000000);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            notify.add({"id": 32, "item": stateValue});
          });
        }
      }
      if (isRentSelected) {
        // double divisionValue = 5000;
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
                  divisions: defaultRentRangeValues.start > 100000 ? (1000000 - 0) ~/ 10000 : (1000000 - 0) ~/ 1000,
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
        // double divisionValue = 50000;
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
                  min: 500000,
                  max: 500000000,
                  labels: RangeLabels(
                    formatValue(defaultBuyRangeValues.start),
                    formatValue(defaultBuyRangeValues.end),
                  ),
                  divisions: defaultBuyRangeValues.start >= 10000000 ? ((500000000 - 500000) / 5000000).round() : ((500000000 - 500000) / 500000).round(),
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
    if (selectedValues.isNotEmpty && !selectedValues.any((element) => element["id"] == 24) && !isEdit) {
      if (question.questionId == 24) {
        stateValue = const RangeValues(100, 10000);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notify.add({"id": 24, "item": stateValue});
        });
      }
    }
    final selectedOption = ref.read(selectedOptionNotifier);
    // double divisionValue = 50;

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            CustomText(
              title: selectedOption == 'Acre'
                  ? 'Area: ${formatValueForAcre(stateValue?.start ?? defaultAreaRangeValues.start)} - ${formatValueForAcre(stateValue?.end ?? defaultAreaRangeValues.end)}'
                  : 'Area: ${formatValueforOnlyNumbers(stateValue?.start ?? defaultAreaRangeValues.start)} - ${formatValueforOnlyNumbers(stateValue?.end ?? defaultAreaRangeValues.end)}',
              size: 14,
            ),
            RangeSlider(
              values: stateValue ?? defaultAreaRangeValues,
              min: areaRange.start,
              max: areaRange.end,
              labels: selectedOption == 'Acre'
                  ? RangeLabels(
                      formatValueForAcre(stateValue?.start ?? defaultAreaRangeValues.start),
                      formatValueForAcre(stateValue?.end ?? defaultAreaRangeValues.end),
                    )
                  : RangeLabels(
                      formatValueforOnlyNumbers(stateValue?.start ?? defaultAreaRangeValues.start),
                      formatValueforOnlyNumbers(stateValue?.end ?? defaultAreaRangeValues.end),
                    ),
              divisions: selectedOption == 'Acre' ? (areaRange.end - areaRange.start) ~/ 0.25 : (areaRange.end - areaRange.start) ~/ 50,
              onChanged: (RangeValues newVal) {
                setState(() {
                  // defaultAreaRangeValues = newVal;
                  ref.read(defaultAreaRangeValuesNotifier.notifier).setRange(newVal);
                });
                notify.add({"id": question.questionId, "item": defaultAreaRangeValues});
              },
            ),
          ],
        );
      },
    );
  }

  return const SizedBox.shrink();
}
