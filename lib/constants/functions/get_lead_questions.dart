// ignore_for_file: invalid_use_of_protected_member
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:number_to_words/number_to_words.dart';
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
import 'package:yes_broker/widgets/questionaries/google_maps.dart';
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(selectedOptionNotifier.notifier).setRange(selectedchipOption);
      });
    }
    if (!isEdit && question.questionId == 23) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // ref.read(selectedOptionNotifier.notifier).setRange(selectedchipOption);
        notify.add({"id": question.questionId, "item": "Sq ft"});
      });
    }

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
                                    if (selectedchipOption != option) {
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
    TextEditingController controller = TextEditingController(text: value.isNotEmpty ? value[0]["item"] : "");
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
      String? statevalue = "";
      String? cityvalue = "";
      String? localityvalue = "";
      String? address1value = "";
      String? address2value = "";
      final existingState = selectedValues.any((element) => element["id"] == 26);
      final existingCity = selectedValues.any((element) => element["id"] == 27);
      final existingLocality = selectedValues.any((element) => element["id"] == 54);
      final existingaddress1 = selectedValues.any((element) => element["id"] == 28);
      final existingaddress2 = selectedValues.any((element) => element["id"] == 29);
      if (existingState) {
        statevalue = selectedValues.firstWhere((element) => element["id"] == 26)["item"];
      }
      if (existingCity) {
        cityvalue = selectedValues.firstWhere((element) => element["id"] == 27)["item"];
      }
      if (existingLocality) {
        localityvalue = selectedValues.firstWhere((element) => element["id"] == 54)["item"];
      }
      if (existingaddress1) {
        address1value = selectedValues.firstWhere((element) => element["id"] == 28)["item"];
      }
      if (existingaddress2) {
        address2value = selectedValues.firstWhere((element) => element["id"] == 29)["item"];
      }
      TextEditingController statecontroller = TextEditingController(text: statevalue);
      TextEditingController citycontroller = TextEditingController(text: cityvalue);
      TextEditingController localitycontroller = TextEditingController(text: localityvalue);
      TextEditingController address1controller = TextEditingController(text: address1value);
      TextEditingController address2controller = TextEditingController(text: address2value);
      List placesList = [];
      return StatefulBuilder(builder: (context, setState) {
        return Column(
          children: [
            LabelTextInputField(
              labelText: 'Search your location',
              inputController: controller,
              hintText: "Search",
              onChanged: (value) {
                getPlaces(value).then((places) {
                  final descriptions = places.predictions?.map((prediction) => prediction.description) ?? [];
                  setState(() {
                    placesList = descriptions.toList();
                  });
                });
              },
            ),
            if (placesList.isNotEmpty)
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
                        final str = placesList[index];
                        notify.add({"id": question.questionId, "item": str});
                        controller.text = str;
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
                            statecontroller.text = stateName;
                            citycontroller.text = cityName;
                            localitycontroller.text = remainingWords;

                            notify.add({"id": 26, "item": stateName});
                            notify.add({"id": 27, "item": cityName});
                            notify.add({"id": 54, "item": remainingWords});

                            setState(() {
                              placesList = [];
                            });
                          } else {
                            setState(() {
                              placesList = [];
                            });
                            // controller.text = "";
                            // controller.text = "";
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
            LabelTextInputField(
                onChanged: (newvalue) {
                  notify.add({"id": 26, "item": newvalue.trim()});
                },
                inputController: statecontroller,
                isMandatory: true,
                labelText: "State",
                validator: (value) => validateForNormalFeild(value: value, props: "State")),
            LabelTextInputField(
                onChanged: (newvalue) {
                  notify.add({"id": 27, "item": newvalue.trim()});
                },
                inputController: citycontroller,
                isMandatory: true,
                labelText: "City",
                validator: (value) => validateForNormalFeild(value: value, props: "City")),
            LabelTextInputField(
                onChanged: (newvalue) {
                  notify.add({"id": 54, "item": newvalue.trim()});
                },
                inputController: localitycontroller,
                isMandatory: true,
                labelText: "Locality",
                validator: (value) => validateForNormalFeild(value: value, props: "Locality")),
            LabelTextInputField(
              onChanged: (newvalue) {
                notify.add({"id": 28, "item": newvalue.trim()});
              },
              inputController: address1controller,
              isMandatory: true,
              labelText: "Address1",
              validator: (value) {
                if (!isChecked && value!.isEmpty) {
                  return "Please enter ${question.questionTitle}";
                }
                return null;
              },
            ),
            LabelTextInputField(
              onChanged: (newvalue) {
                notify.add({"id": 29, "item": newvalue.trim()});
              },
              inputController: address2controller,
              isMandatory: true,
              labelText: "Address2",
              validator: (value) {
                if (!isChecked && value!.isEmpty) {
                  return "Please enter ${question.questionTitle}";
                }
                return null;
              },
            ),
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
    List? defaultValue;

    if (selectedValues.any((answer) => answer["id"] == question.questionId)) {
      defaultValue = selectedValues.firstWhere((answer) => answer["id"] == question.questionId)["item"] ?? "";
    }
    final state = getDataById(selectedValues, 26);
    final city = getDataById(selectedValues, 27);
    final address1 = getDataById(selectedValues, 28);
    final address2 = getDataById(selectedValues, 29);
    final locality = getDataById(selectedValues, 54);

    return CustomGoogleMap(
      isEdit: isEdit,
      latLng: isEdit ? LatLng(defaultValue![0], defaultValue[1]) : null,
      selectedValues: selectedValues,
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
          print("objec-------------t");
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
                  divisions: 10,

                  // divisions: (100000000 - 1000) ~/ divisionValue,
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
                  min: 500000,
                  max: 500000000,
                  labels: RangeLabels(
                    formatValue(defaultBuyRangeValues.start),
                    formatValue(defaultBuyRangeValues.end),
                  ),
                  // divisions: (50000000 - 100000) ~/ divisionValue,
                  divisions: 10,
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
    double divisionValue = 50;
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            CustomText(
              title:
                  'Area: ${formatValueforOnlyNumbers(stateValue?.start ?? defaultAreaRangeValues.start)} - ${formatValueforOnlyNumbers(stateValue?.end ?? defaultAreaRangeValues.end)}',
              size: 14,
            ),
            RangeSlider(
              values: stateValue ?? defaultAreaRangeValues,
              min: areaRange.start,
              max: areaRange.end,
              labels: RangeLabels(
                formatValueforOnlyNumbers(stateValue?.start ?? defaultAreaRangeValues.start),
                formatValueforOnlyNumbers(stateValue?.end ?? defaultAreaRangeValues.end),
              ),
              divisions: 10,
              // divisions: (10000 - 500) ~/ divisionValue,
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
