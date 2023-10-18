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
import '../../pages/Auth/signup/country_code_modal.dart';
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
  bool isMobileNoEmpty,
  bool iswhatsappMobileNoEmpty,
  bool isChecked,
  Function(bool) isCheckedUpdate,
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
                  print('this is if part =========');

                  notify.add({"id": question.questionId, "item": option});
                } else {
                  // Handle reaching the last question
                  print('this is else part =========');
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
                              if (selectedItem) {
                                selectedOptions.add(item);
                              } else {
                                selectedOptions.remove(item);
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
    // if (question.questionId == 27) {
    //   controller.text = selectedValues.isNotEmpty ? selectedValues.firstWhere((element) => element["id"] == 27)["item"] : "";
    // }
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
                  label: 'Use Same Number For Whatsapp',
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
              validator: (value) => validateForNormalFeild(value: value, props: "State"),
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
              labelText: "Address1",
            ),
            LabelTextInputField(
              onChanged: (newvalue) {
                notify.add({"id": 29, "item": newvalue.trim()});
              },
              inputController: address2controller,
              labelText: "Address2",
            ),
          ],
        );
      });
    }
    return StatefulBuilder(
      builder: (context, setState) {
        final isPriceField = question.questionId == 46 || question.questionId == 48 || question.questionId == 50;
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
      defaultValue = selectedValues.firstWhere((answer) => answer["id"] == question.questionId)["item"] ?? "";
    }
    final isvalidationtrue = question.questionId == 14;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 7),
      child: StatefulBuilder(builder: (context, setState) {
        return CustomDropdownFormField<String>(
          label: question.questionTitle,
          value: defaultValue ?? selectedvalue,
          isMandatory: true,
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
    List<double> defaultValue = [];
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
      latLng: isEdit ? LatLng(defaultValue[0], defaultValue[1]) : null,
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



// login screen m email and password dono hai                         
// logo thoda upper krna hai login m
// on time re-enter password is not same show error when user enter passwrod in signup page
// title add on personal details page and add mandatory textfield sign and set caps title is welcome to brokr
//let us know you better shi kro design dekh  
// whats up number center kro center nhi hai
// alignment shi kro tell us title 
// make mandaotory field sign in company details page
// sign up k baad phela login screen pr jana chaiye 
// first login m loading ho rhi h first tym load shi se hona chaiye
// autospace nhi aana chaiye email autofillup m 
// 