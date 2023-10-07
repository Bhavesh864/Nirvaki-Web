// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
import '../../Customs/snackbar.dart';
import '../../customs/custom_fields.dart';
import '../../customs/custom_text.dart';
import '../../customs/dropdown_field.dart';
import '../../customs/label_text_field.dart';
import '../../pages/Auth/signup/company_details.dart';
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
  if (isPlotSelected) {
    selectedValues.removeWhere((element) => element["id"] == 14);
  }
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
    if (selectedValues.isNotEmpty && !selectedValues.any((element) => element["id"] == 23)) {
      selectedOption = "Sq ft";
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notify.add({"id": 23, "item": selectedOption});
      });
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
                            selectedOption = option;
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
              // CustomText(
              //   fontWeight: FontWeight.w500,
              //   size: 16,
              //   title: question.questionTitle,
              // ),
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
    // if (question.questionId == 27) {
    //   controller.text = selectedValues.isNotEmpty ? selectedValues.firstWhere((element) => element["id"] == 27)["item"] : "";
    // }
    if (question.questionId == 8) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              if (question.questionId == 8)
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
              isMandatory: true,
              validator: (value) => !isEdit ? validateForNormalFeild(value: value, props: "Search Location") : null,
              onChanged: (value) {
                getPlaces(value).then((places) {
                  final descriptions = places.data?.predictions?.map((prediction) => prediction.description) ?? [];
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
                            // address1controller.text = str;
                            // address2controller.text = str;
                            notify.add({"id": 26, "item": stateName});
                            notify.add({"id": 27, "item": cityName});
                            notify.add({"id": 54, "item": remainingWords});
                            // notify.add({"id": 26, "item": str});
                            // notify.add({"id": 26, "item": str});
                            // notify.add({"id": 26, "item": lastThreeWordsList[1]});
                            // notify.add({"id": 56, "item": str});
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
                            // controller.text = "";
                            // controller.text = "";
                          });
                          // controller.text = "";
                          // controller.text = "";
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
              validator: (value) => validateForNormalFeild(value: value, props: "State"),
              labelText: "State",
            ),
            LabelTextInputField(
              onChanged: (newvalue) {
                notify.add({"id": 27, "item": newvalue.trim()});
              },
              inputController: citycontroller,
              isMandatory: true,
              labelText: "City",
              validator: (value) => validateForNormalFeild(value: value, props: "City"),
            ),
            LabelTextInputField(
              onChanged: (newvalue) {
                notify.add({"id": 54, "item": newvalue.trim()});
              },
              inputController: localitycontroller,
              isMandatory: true,
              labelText: "Locality",
              validator: (value) => validateForNormalFeild(value: value, props: "Locality"),
            ),
            LabelTextInputField(
              onChanged: (newvalue) {
                notify.add({"id": 28, "item": newvalue.trim()});
              },
              inputController: address1controller,
              isMandatory: true,
              labelText: "Address1",
            ),
            LabelTextInputField(
              onChanged: (newvalue) {
                notify.add({"id": 29, "item": newvalue.trim()});
              },
              inputController: address2controller,
              isMandatory: true,
              labelText: "Address2",
            ),
          ],
        );
      });
    }
    return StatefulBuilder(
      builder: (context, setState) {
        final isPriceField = question.questionId == 46 || question.questionId == 48 || question.questionId == 50;
        final isVideoField = question.questionId == 34;

        final isDigitsOnly = question.questionTitle.contains('Mobile') ||
            question.questionTitle == 'Rent' ||
            question.questionTitle == 'Listing Price' ||
            question.questionTitle.contains('Floor Number') ||
            question.questionTitle.contains('Property Area') ||
            question.questionId == 22;

        final isvalidationtrue = question.questionTitle.contains('First') ||
            question.questionTitle.contains('Property Area') ||
            question.questionTitle.contains('Mobile') ||
            question.questionTitle == 'Rent' ||
            question.questionTitle == 'Listing Price';
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
            isVideoField
                ? Container(
                    margin: const EdgeInsets.symmetric(horizontal: 7),
                    child: AppText(
                      text: '(Enter youtube link of the video)',
                      textColor: Colors.grey.shade500,
                      fontsize: 14,
                    ),
                  )
                : const SizedBox.shrink(),
            isPriceField
                ? Container(
                    margin: const EdgeInsets.all(7),
                    child: AppText(
                      text: textResult.toUpperCase(),
                      textColor: AppColor.grey,
                      fontsize: 16,
                    ),
                  )
                : const SizedBox.shrink(),
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
    if (selectedValues.any((answer) => answer["id"] == question.questionId)) {
      defaultValue = selectedValues.firstWhere((answer) => answer["id"] == question.questionId)["item"] ?? "";
    }
    bool isSetBedroomvalue = selectedValues.isNotEmpty && question.questionTitle.contains("Bedroom") && !selectedValues.any((element) => element["id"] == 14);

    if (isSetBedroomvalue) {
      defaultValue = "1";
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notify.add({"id": 14, "item": defaultValue});
      });
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
    List<double> defaultValue = [];
    if (selectedValues.any((answer) => answer["id"] == question.questionId)) {
      defaultValue = selectedValues.firstWhere((answer) => answer["id"] == question.questionId)["item"] ?? "";
    }
    print('alsdkjfalsdjf ---${defaultValue}');

    final state = getDataById(selectedValues, 26);
    final city = getDataById(selectedValues, 27);
    final address1 = getDataById(selectedValues, 28);
    final address2 = getDataById(selectedValues, 29);
    final locality = getDataById(selectedValues, 54);

    return CustomGoogleMap(
      isEdit: isEdit,
      latLng: LatLng(defaultValue[0], defaultValue[1]),
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

LatLng convertListToLatLng(List<double> doubles) {
  if (doubles.length < 2) {
    throw ArgumentError("List must contain at least two doubles (latitude and longitude).");
  }
  double latitude = doubles[0];
  double longitude = doubles[1];

  return LatLng(latitude, longitude);
}
