import 'package:flutter/material.dart';

import '../../Customs/custom_fields.dart';
import '../../Customs/custom_text.dart';
import '../../Customs/dropdown_field.dart';
import '../../Customs/label_text_field.dart';
import '../../widgets/card/questions card/chip_button.dart';
import '../firebase/questions.dart';
import '../utils/colors.dart';

Widget buildQuestionWidget(
  Question question,
  screens,
  int currentIndex,
  selectedOption,
  PageController pageController,
) {
  if (question.questionOptionType == 'textfield') {
    TextEditingController controller = TextEditingController();
    bool isChecked = true;
    if (question.questionTitle == 'Whatsapp Number') {
      return StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
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
                  inputController: controller,
                  labelText: question.questionTitle,
                )
            ],
          );
        },
      );
    }
    return LabelTextInputField(
      inputController: controller,
      labelText: question.questionTitle,
    );
  } else if (question.questionOptionType == 'chip') {
    return Column(
      children: [
        for (var option in question.questionOption)
          StatefulBuilder(builder: (context, setState) {
            return ChipButton(
              text: option,
              onSelect: () {
                // print(option);
                if (currentIndex < screens.length - 1) {
                  setState(() {
                    currentIndex++; // Increment the current index
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  });
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
                        },
                        labelColor: selectedOptions.contains(item)
                            ? Colors.white
                            : Colors.black,
                      ),
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
                      selected: selectedOption ==
                          option, // Check if the current item is selected
                      onSelected: (selectedItem) {
                        setState(() {
                          if (selectedOption == option) {
                            // If the current option is already selected, unselect it
                            selectedOption = '';
                          } else {
                            // Otherwise, select the current option
                            selectedOption = option;
                          }
                        });
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
  }

  return const SizedBox
      .shrink(); // Return an empty widget if the question type is not supported
}
