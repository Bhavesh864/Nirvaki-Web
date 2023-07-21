import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:yes_broker/constants/firebase/questionModels/inventory_question.dart';

import 'package:yes_broker/controllers/all_selected_ansers_provider.dart';
import 'package:yes_broker/widgets/inventory/inventory_photos.dart';

import 'package:yes_broker/google_maps.dart';
import 'package:yes_broker/widgets/inventory/search_user_textfield.dart';
import '../../Customs/custom_fields.dart';
import '../../Customs/custom_text.dart';
import '../../Customs/dropdown_field.dart';
import '../../Customs/label_text_field.dart';
import '../../widgets/card/questions card/chip_button.dart';

import '../utils/colors.dart';

Widget buildQuestionWidget(
  Question question,
  List<Screen> screens,
  int currentIndex,
  selectedOption,
  PageController pageController,
  AllChipSelectedAnwers notify,
  Function nextQuestion,
) {
  if (question.questionOptionType == 'textfield') {
    TextEditingController controller = TextEditingController();
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
                    notify.add({"id": question.questionId, "item": newvalue});
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
        notify.add({"id": question.questionId, "item": newvalue});
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter ${question.questionTitle}";
        }
        return null;
      },
    );
  } else if (question.questionOptionType == 'chip') {
    return Column(
      children: [
        for (var option in question.questionOption)
          StatefulBuilder(builder: (context, setState) {
            return ChipButton(
              text: option,
              onSelect: () {
                if (currentIndex < screens.length - 1) {
                  notify.add({"id": question.questionId, "item": option});
                  nextQuestion(screens: screens);
                } else {
                  // Handle reaching the last question or any other action
                }
              },
            );
          }),
      ],
    );
  } else if (question.questionOptionType == 'dropdown') {
    return DropDownField(
      title: question.questionTitle,
      optionsList: question.questionOption,
      onchanged: (Object e) {
        notify.add({"id": question.questionId, "item": e});
      },
    );
  } else if (question.questionOptionType == 'multichip') {
    List<String> selectedOptions = [];
    List items = question.questionOption;
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
  } else if (question.questionOptionType == 'smallchip') {
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
  } else if (question.questionOptionType == 'textarea') {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: 5,
      onChanged: (newvalue) {
        notify.add({"id": question.questionId, "item": newvalue});
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
    );
  } else if (question.questionOptionType == 'map') {
    return CustomGoogleMap(
      onLatLngSelected: (latLng) {
        notify.add({
          "id": question.questionId,
          "item": [latLng.latitude, latLng.longitude]
        });
      },
    );
  } else if (question.questionOptionType == 'photo') {
    // getDataById(state,  )
    File? selectedImage;
    Uint8List webImage;
    void setImage(File image) {
      selectedImage = image;
    }

    void setWebImage(Uint8List image) async {
      webImage = image;
    }

    return Wrap(
      children: [
        ImagePickerContainer(
            onImageSelected: setImage, webImageSelected: setWebImage),
        const SizedBox(height: 20),
        if (selectedImage != null)
          Image.file(selectedImage!, height: 200, width: 200)
      ],
    );
  }

  return const SizedBox.shrink();
}
