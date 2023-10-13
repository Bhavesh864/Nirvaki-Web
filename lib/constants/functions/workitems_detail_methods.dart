import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/Customs/label_text_field.dart';
import 'package:yes_broker/constants/firebase/calenderModel/calender_model.dart';
import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/firebase/detailsModels/inventory_details.dart' as inventory;
import 'package:yes_broker/constants/firebase/detailsModels/lead_details.dart' as lead;
import 'package:yes_broker/constants/firebase/random_uid.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import '../../Customs/custom_text.dart';
import '../../customs/custom_fields.dart';
import '../../customs/dropdown_field.dart';
import '../../widgets/card/questions card/chip_button.dart';
import '../firebase/detailsModels/todo_details.dart';
import '../utils/colors.dart';
import '../validation/basic_validation.dart';
import 'calendar/calendar_functions.dart';

void showImageSliderCarousel(List<String> imageUrls, int initialIndex, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: const EdgeInsets.all(0),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                animateToClosest: true,
                autoPlayCurve: Curves.linear,
                pauseAutoPlayOnManualNavigate: true,
                pauseAutoPlayOnTouch: true,
                pauseAutoPlayInFiniteScroll: true,
                height: Responsive.isMobile(context) ? null : 550,
                initialPage: initialIndex,
                enlargeCenterPage: true,
                viewportFraction: Responsive.isMobile(context) ? 0.7 : 0.55,
                enableInfiniteScroll: false,
              ),
              items: imageUrls.map(
                (url) {
                  return Builder(
                    builder: (BuildContext context) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.network(
                          url,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  );
                },
              ).toList(),
            ),
            Positioned(
              top: -5,
              right: 10,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

void uploadAttachmentsToFirebaseStorage(
  PlatformFile fileToUpload,
  String id,
  String docname,
  Function updateState,
  String titleName,
  Function(bool) setIsUploading,
) async {
  final uniqueKey = DateTime.now().microsecondsSinceEpoch.toString();

  Reference referenceRoot = FirebaseStorage.instance.ref();
  Reference referenceDirImages = referenceRoot.child('attachments');

  Reference referenceImagesToUpload = referenceDirImages.child(uniqueKey);

  try {
    if (kIsWeb) {
      await referenceImagesToUpload.putData(fileToUpload.bytes!);
    } else {
      await referenceImagesToUpload.putFile(File(fileToUpload.path!));
    }
    final downloadUrl = await referenceImagesToUpload.getDownloadURL();
    print('downloadurl.-------$downloadUrl');
    setIsUploading(false);
    print('false kr do -----');

    if (id.contains(ItemCategory.isInventory)) {
      inventory.Attachments attachments = inventory.Attachments(
        id: generateUid(),
        createdby: AppConst.getAccessToken(),
        createddate: Timestamp.now(),
        path: downloadUrl,
        title: titleName == '' ? docname : titleName,
        type: docname,
      );
      await inventory.InventoryDetails.addAttachmentToItems(itemid: id, newAttachment: attachments).then((value) => updateState());
    } else if (id.contains(ItemCategory.isLead)) {
      lead.Attachments attachments = lead.Attachments(
        id: generateUid(),
        createdby: AppConst.getAccessToken(),
        createddate: Timestamp.now(),
        path: downloadUrl,
        title: titleName == '' ? docname : titleName,
        type: docname,
      );

      await lead.LeadDetails.addAttachmentToItems(itemid: id, newAttachment: attachments).then((value) => updateState());
    } else if (id.contains(ItemCategory.isTodo)) {
      Attachments attachments = Attachments(
        id: generateUid(),
        createdby: AppConst.getAccessToken(),
        createddate: Timestamp.now(),
        path: downloadUrl,
        title: titleName == '' ? docname : titleName,
        type: docname,
      );
      await TodoDetails.addAttachmentToItems(itemid: id, newAttachment: attachments).then((value) => updateState());
    }
    // InventoryDetails.deleteAttachment(itemId: id, attachmentIdToDelete: "1");
  } catch (e) {
    print(e);
  }
}

void showUploadDocumentModal(
  BuildContext context,
  Function updateState,
  List<String> selectedDocName,
  PlatformFile? selectedFile,
  List<PlatformFile> pickedDocuments,
  Function onPressed,
  String id,
  Function(bool) setIsUploading,
) {
  String docName = '';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      final TextEditingController titleController = TextEditingController();
      return StatefulBuilder(
        builder: (context, innerSetState) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Dialog(
              insetPadding: const EdgeInsets.all(15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Container(
                padding: const EdgeInsets.all(15),
                height: docName == 'Other' ? 400 : 300,
                width: Responsive.isMobile(context) ? width : 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Upload New Document',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          iconSize: 20,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    DropDownField(
                      title: 'Document Type',
                      defaultValues: "",
                      optionsList: const ['Adhaar card', 'Agreement', 'Insurance', 'Other'],
                      onchanged: (value) {
                        docName = value.toString();
                        innerSetState(
                          () {},
                        );
                      },
                    ),
                    if (docName == 'Other') ...[
                      const Padding(
                        padding: EdgeInsets.only(top: 3.0),
                        child: CustomText(
                          title: 'Title',
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: TextField(
                          controller: titleController,
                          decoration: const InputDecoration(hintText: 'Enter title'),
                        ),
                      ),
                    ],
                    CustomButton(
                      textAlign: TextAlign.left,
                      isAttachments: true,
                      text: selectedFile == null ? 'Upload Document' : selectedFile!.name.toString(),
                      rightIcon: Icons.publish_outlined,
                      buttonColor: AppColor.secondary,
                      textColor: Colors.black,
                      righticonColor: Colors.black,
                      titleLeft: true,
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles();
                        if (result != null) {
                          innerSetState(() {
                            pickedDocuments.addAll(result.files);
                            selectedFile = result.files[0];
                          });
                        }
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CustomButton(
                      text: 'Done',
                      onPressed: () {
                        if (docName != '' && selectedFile != null) {
                          selectedDocName.add(docName);
                          setIsUploading(true);
                          print('true kr do -----');

                          uploadAttachmentsToFirebaseStorage(
                            selectedFile!,
                            id,
                            docName,
                            updateState,
                            titleController.text,
                            setIsUploading,
                          );
                          onPressed();
                          selectedFile = null;
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

void showConfirmDeleteAttachment(BuildContext context, Function onPressYes) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          height: 230,
          width: 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Are you sure you want to delete it',
                      style: TextStyle(fontSize: Responsive.isMobile(context) ? 22 : 26, fontWeight: FontWeight.bold),
                    ),
                  ),
                  InkWell(
                    child: const Icon(
                      Icons.close,
                      size: 22,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              // const SizedBox(
              //   height: 20,
              // ),
              const Spacer(),
              ChipButton(
                text: 'Yes',
                onSelect: () {
                  onPressYes();
                  Navigator.of(context).pop();
                },
              ),
              ChipButton(
                text: 'No',
                onSelect: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showOwnerDetailsAndAssignToBottomSheet(BuildContext context, String title, Widget innerContent) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
    ),
    builder: (BuildContext context) {
      return Container(
        constraints: BoxConstraints(minHeight: 400),
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 20,
                    color: AppColor.primary,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            innerContent,
          ],
        ),
      );
    },
  );
}

void showAddCalendarModal({
  required BuildContext context,
  required bool isEdit,
  required WidgetRef ref,
  CalendarModel? calendarModel,
}) {
  final formkey = GlobalKey<FormState>();
  DateTime pickedDate = DateTime.now();

  TextEditingController descriptionController = TextEditingController(text: isEdit ? calendarModel?.calenderDescription : '');
  TextEditingController titleController = TextEditingController(text: isEdit ? calendarModel?.calenderTitle : '');
  TextEditingController dateController = TextEditingController(text: isEdit ? calendarModel?.dueDate : '');
  TextEditingController timeController = TextEditingController(text: isEdit ? calendarModel?.time : '');

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, innerSetState) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Dialog(
            insetPadding: const EdgeInsets.all(15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(15),
                // height: 550,
                width: Responsive.isMobile(context) ? width : 650,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(),
                          CustomText(
                            softWrap: true,
                            textAlign: TextAlign.center,
                            size: Responsive.isMobile(context) ? 20 : 30,
                            title: 'Add Calendar Item',
                            fontWeight: FontWeight.bold,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(
                              Icons.close,
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      LabelTextInputField(
                        labelText: 'Title',
                        isMandatory: true,
                        labelFontWeight: FontWeight.w600,
                        inputController: titleController,
                        validator: (value) => validateForNormalFeild(props: "Title", value: value),
                      ),
                      if (Responsive.isMobile(context)) ...[
                        Wrap(
                          children: [
                            GestureDetector(
                              onTap: () {
                                pickFromDateTime(
                                  pickDate: true,
                                  pickedDate: pickedDate,
                                  context: context,
                                  dateController: dateController,
                                  timeController: timeController,
                                );
                              },
                              child: LabelTextInputField(
                                labelText: 'Date',
                                isMandatory: true,
                                labelFontWeight: FontWeight.w600,
                                inputController: dateController,
                                isDatePicker: true,
                                validator: (value) => validateForNormalFeild(props: "Title", value: value),
                                hintText: 'DD/MM/YYYY',
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            GestureDetector(
                              onTap: () {
                                pickFromDateTime(
                                  pickDate: false,
                                  pickedDate: pickedDate,
                                  context: context,
                                  dateController: dateController,
                                  timeController: timeController,
                                );
                              },
                              child: LabelTextInputField(
                                labelText: 'Time',
                                isMandatory: true,
                                isDatePicker: true,
                                labelFontWeight: FontWeight.w600,
                                inputController: timeController,
                                rightIcon: Icons.schedule,
                                validator: (value) => validateForNormalFeild(props: "Title", value: value),
                                hintText: 'Select Time',
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  pickFromDateTime(
                                    pickDate: true,
                                    pickedDate: pickedDate,
                                    context: context,
                                    dateController: dateController,
                                    timeController: timeController,
                                  );
                                },
                                child: LabelTextInputField(
                                  labelText: 'Date',
                                  labelFontWeight: FontWeight.w600,
                                  isMandatory: true,
                                  inputController: dateController,
                                  isDatePicker: true,
                                  validator: (value) => validateForNormalFeild(props: "Title", value: value),
                                  hintText: 'DD/MM/YYYY',
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  pickFromDateTime(
                                    pickDate: false,
                                    pickedDate: pickedDate,
                                    context: context,
                                    dateController: dateController,
                                    timeController: timeController,
                                  );
                                },
                                child: LabelTextInputField(
                                  labelText: 'Time',
                                  isMandatory: true,
                                  isDatePicker: true,
                                  labelFontWeight: FontWeight.w600,
                                  inputController: timeController,
                                  rightIcon: Icons.schedule,
                                  validator: (value) => validateForNormalFeild(props: "Title", value: value),
                                  hintText: 'Select Time',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      LabelTextAreaField(
                        labelText: 'Details',
                        onChanged: (p0) {
                          // descriptionController.itext = p0;
                        },
                        inputController: descriptionController,
                        validator: (value) => validateForNormalFeild(props: "Details", value: value),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (isEdit)
                            if (Responsive.isMobile(context)) ...[
                              GestureDetector(
                                onTap: () {
                                  onDeleteTask(
                                    context: context,
                                    dateController: dateController,
                                    timeController: timeController,
                                    titleController: titleController,
                                    descriptionController: descriptionController,
                                    calendarModel: calendarModel!,
                                  );
                                  Navigator.of(context).pop();
                                },
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 25,
                                ),
                              ),
                            ] else ...[
                              CustomButton(
                                buttonColor: Colors.red,
                                text: 'Delete',
                                onPressed: () {
                                  onDeleteTask(
                                    context: context,
                                    dateController: dateController,
                                    timeController: timeController,
                                    titleController: titleController,
                                    descriptionController: descriptionController,
                                    calendarModel: calendarModel!,
                                  );
                                  Navigator.of(context).pop();
                                },
                                width: 80,
                                height: 39,
                              ),
                            ],
                          const SizedBox(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: CustomButton(
                              buttonColor: AppColor.primary,
                              text: isEdit ? 'Update' : 'Save',
                              onPressed: () {
                                if (isEdit) {
                                  if (formkey.currentState!.validate()) {
                                    onUpdateTask(
                                      context: context,
                                      dateController: dateController,
                                      timeController: timeController,
                                      titleController: titleController,
                                      descriptionController: descriptionController,
                                      calendarModel: calendarModel!,
                                    );
                                    Navigator.of(context).pop();
                                  }
                                } else {
                                  if (formkey.currentState!.validate()) {
                                    onAddTask(
                                      ref: ref,
                                      context: context,
                                      dateController: dateController,
                                      timeController: timeController,
                                      titleController: titleController,
                                      descriptionController: descriptionController,
                                    );
                                    Navigator.of(context).pop();
                                  }
                                }
                              },
                              width: 85,
                              height: 39,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
    },
  );
}
