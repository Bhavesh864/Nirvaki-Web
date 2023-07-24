import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:yes_broker/constants/firebase/questionModels/inventory_question.dart';
import 'package:yes_broker/controllers/all_selected_ansers_provider.dart';
import 'package:yes_broker/widgets/inventory/assign_user.dart';
import 'package:yes_broker/google_maps.dart';
import 'package:yes_broker/widgets/inventory/inventory_photos.dart';
import '../../Customs/custom_fields.dart';
import '../../Customs/custom_text.dart';
import '../../Customs/dropdown_field.dart';
import '../../Customs/label_text_field.dart';
import '../../widgets/card/questions card/chip_button.dart';

import '../utils/colors.dart';

Widget buildQuestionWidget(Question question, List<Screen> screensDataList, int currentScreenIndex, AllChipSelectedAnwers notify, Function nextQuestion) {
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
    File? selectedImage;
    void setImage(File image) {
      selectedImage = image;
    }

    Uint8List? webImage;
    void setWebImage(Uint8List image) {
      webImage = image;
    }

    return Wrap(
      children: [
        ImagePickerContainer(onImageSelected: setImage, webImageSelected: setWebImage),
        const SizedBox(height: 20),
        if (selectedImage != null) Image.file(selectedImage!, height: 200, width: 200)
      ],
    );
    // getDataById(state,  )
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
