import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:yes_broker/constants/firebase/questionModels/inventory_question.dart';
import 'package:yes_broker/controllers/all_selected_ansers_provider.dart';
import 'package:yes_broker/widgets/inventory/inventory_photos.dart';
import 'package:yes_broker/google_maps.dart';
import '../../Customs/custom_fields.dart';
import '../../Customs/custom_text.dart';
import '../../Customs/dropdown_field.dart';
import '../../Customs/label_text_field.dart';
import '../../widgets/card/questions card/chip_button.dart';

import '../utils/colors.dart';

Widget buildQuestionWidget(
  Question question,
  List<Screen> screensDataList,
  int currentScreenIndex,
  AllChipSelectedAnwers notify,
  Function nextQuestion,
) {
  if (question.questionOptionType == 'chip') {
    return Column(
      children: [
        for (var option in question.questionOption)
          StatefulBuilder(builder: (context, setState) {
            return ChipButton(
              text: option,
              onSelect: () {
                if (currentScreenIndex < screensDataList.length - 1) {
                  notify.add({"id": question.questionId, "item": option});
                  nextQuestion(screensDataList: screensDataList);
                } else {
                  // Handle reaching the last question or any other action
                }
              },
            );
          }),
      ],
    );
  } else if (question.questionOptionType == 'smallchip') {
    String selectedOption = question.questionOption.isNotEmpty ? question.questionOption[0] : '';
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
    List<String> selectedOptions = question.questionOption.isNotEmpty ? [question.questionOption[0]] : [];
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
        );
      },
    );
  } else if (question.questionOptionType == 'textfield') {
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
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter ${question.questionTitle}";
        }
        return null;
      },
    );
  } else if (question.questionOptionType == "Assign") {
    List<String> users = ['Bhavesh', 'Manish', 'Jitender', 'Rahul', 'Bhavya', "Bhavna"];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 8, right: 8, left: 2, bottom: 3),
          child: CustomText(
            title: 'Assign to',
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.left,
          ),
        ),
        SizedBox(
          height: 45,
          child: Autocomplete(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<String>.empty();
              }

              final String searchText = textEditingValue.text.toLowerCase();

              return users.where((userName) {
                final String optionLowerCase = userName.toLowerCase();
                return optionLowerCase.contains(searchText);
              });
            },
            fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
              return TextField(
                controller: textEditingController,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: '@',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                // onChanged: (e) {
                //   onFieldSubmitted();
                // },
              );
            },
            optionsViewBuilder: (context, onSelected, options) {
              const itemHeight = 56.0; // Height of each option ListTile
              final itemCount = options.length;
              final dropdownHeight = itemHeight * itemCount;

              return SingleChildScrollView(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 400,
                    height: dropdownHeight,
                    child: Material(
                      elevation: 4,
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: itemCount,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          final option = options.elementAt(index);
                          return GestureDetector(
                            onTap: () {
                              onSelected(option);
                            },
                            child: ListTile(
                              title: Text(option),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
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
    // File? selectedImage;
    // void setImage(File image) {
    //   selectedImage = image;
    // }

    // Uint8List? webImage;
    // void setWebImage(Uint8List image) {
    //   webImage = image;
    // }

    // return Wrap(
    //   children: [
    //     ImagePickerContainer(onImageSelected: setImage, webImageSelected: setWebImage),
    //     const SizedBox(height: 20),
    //     if (selectedImage != null) Image.file(selectedImage!, height: 200, width: 200)
    //   ],
    // );
    // // getDataById(state,  )
    // File? selectedImage;
    // Uint8List webImage;
    // void setImage(File image) {
    //   selectedImage = image;
    // }

    // void setWebImage(Uint8List image) async {
    //   webImage = image;
    // }

    // return Wrap(
    //   children: [
    //     ImagePickerContainer(onImageSelected: setImage, webImageSelected: setWebImage),
    // const SizedBox(height: 20),
    //     if (selectedImage != null) Image.file(selectedImage!, height: 200, width: 200)
    //   ],
    // );
  } else if (question.questionOptionType == 'video') {
    //  File? selectedVideo;
    // void pickVideo() async {
    //   final pickedFile = await ImagePicker().getVideo(source: ImageSource.gallery);
    //   if (pickedFile != null) {
    //     setState(() {
    //       selectedVideo = File(pickedFile.path);
    //     });
    //   }
    // }

    // return Wrap(
    //   children: [
    //     ElevatedButton(
    //       onPressed: pickVideo,
    //       child: Text('Pick a video'),
    //     ),
    //     if (selectedVideo != null)
    //       SizedBox(
    //         height: 200,
    //         width: 200,
    //         child: VideoPlayer(FileVideoPlayerController(selectedVideo!)),
    //       ),
    //   ],
    // );
    // }
    // File? selectedImage;
    // Uint8List webImage;
    // void setImage(File image) {
    //   selectedImage = image;
    // }

    // void setWebImage(Uint8List image) async {
    //   webImage = image;
    // }

    // return Wrap(
    //   children: [
    //     ImagePickerContainer(onImageSelected: setImage, webImageSelected: setWebImage),
    //   ],
    // );
  }

  return const SizedBox.shrink();
}
