// ignore_for_file: invalid_use_of_protected_member, avoid_web_libraries_in_flutter
import 'dart:async';
// import 'dart:html';

import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/Customs/snackbar.dart';
import 'package:yes_broker/constants/firebase/detailsModels/todo_details.dart';
import '../../Customs/custom_chip.dart';
import '../../Customs/custom_text.dart';
import '../../constants/firebase/detailsModels/card_details.dart';
import '../../constants/functions/workitems_detail_methods.dart';
import '../../constants/utils/colors.dart';
import '../../constants/utils/constants.dart';
import '../../riverpodstate/selected_workitem.dart';
import '../../widgets/app/nav_bar.dart';
import '../../widgets/workItemDetail/assignment_widget.dart';
import '../../widgets/workItemDetail/tab_views/activity_tab_view.dart';

class TodoDetailsScreen extends ConsumerStatefulWidget {
  final String todoId;
  const TodoDetailsScreen({super.key, this.todoId = ''});

  @override
  TodoDetailsScreenState createState() => TodoDetailsScreenState();
}

class TodoDetailsScreenState extends ConsumerState<TodoDetailsScreen> with TickerProviderStateMixin {
  late TabController tabviewController;
  late Stream<QuerySnapshot<Map<String, dynamic>>> todoDetails;
  List<Attachments> firebaseAttachments = [];
  PlatformFile? selectedImageName;
  List<PlatformFile> pickedDocuments = [];
  List<String> selectedDocsName = [];
  String? currentStatus;
  bool isEditingTodoName = false;
  bool iseditingTodoDescription = false;
  TextEditingController todoNameEditingController = TextEditingController();
  TextEditingController todoDescriptionEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 4, vsync: this);
    final workItemId = ref.read(selectedWorkItemId.notifier).state;
    todoDetails = FirebaseFirestore.instance.collection('todoDetails').where('todoId', isEqualTo: workItemId == '' ? widget.todoId : workItemId).snapshots();
  }

  void startEditingTodoName(String todoName) {
    setState(() {
      isEditingTodoName = true;
      todoNameEditingController.text = todoName;
    });
  }

  void cancelEditingTodoName() {
    setState(() {
      isEditingTodoName = false;
      todoNameEditingController.clear();
    });
  }

  void startEditingTodoDescription(String des) {
    setState(() {
      iseditingTodoDescription = true;
      todoDescriptionEditingController.text = des;
    });
  }

  void cancelEditingTodoDescription() {
    setState(() {
      iseditingTodoDescription = false;
      todoDescriptionEditingController.clear();
    });
  }

  void updateDate(itemid) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    ).then(
      (pickedDate) {
        if (pickedDate == null) {
          return;
        }
        DateFormat formatter = DateFormat('dd-MM-yyyy');
        TodoDetails.updateCardDate(id: itemid, duedate: formatter.format(pickedDate));
        CardDetails.updateCardDate(id: itemid, duedate: formatter.format(pickedDate));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Responsive.isMobile(context)
          ? AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                iconSize: 25,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: const CustomText(
                title: 'Todo Details',
                color: Colors.black,
              ),
              foregroundColor: Colors.black,
              toolbarHeight: 50,
            )
          : null,
      body: GestureDetector(
        onTap: () {
          if (isEditingTodoName) {
            cancelEditingTodoName();
          } else if (iseditingTodoDescription) {
            cancelEditingTodoDescription();
          }
        },
        child: StreamBuilder(
            stream: todoDetails,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator.adaptive());
              }
              if (snapshot.hasData) {
                final dataList = snapshot.data!.docs;
                List<TodoDetails> todoList = dataList.map((doc) => TodoDetails.fromSnapshot(doc)).toList();

                for (var data in todoList) {
                  final attachments = data.attachments;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                          child: SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 8.0), // Adjust as needed
                                            child: isEditingTodoName
                                                ? SizedBox(
                                                    height: 35,
                                                    width: data.todoName!.length * 10,
                                                    child: CustomTextInput(controller: todoNameEditingController),
                                                  )
                                                : GestureDetector(
                                                    onTap: () => startEditingTodoName(data.todoName!),
                                                    child: Text(
                                                      data.todoName!,
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                          ),
                                          CustomChip(
                                            color: AppColor.primary.withOpacity(0.1),
                                            label: CustomText(
                                              title: data.todoType!,
                                              size: 10,
                                              color: AppColor.primary,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          if (isEditingTodoName)
                                            ElevatedButton(
                                              onPressed: () {
                                                if (todoNameEditingController.text.isNotEmpty) {
                                                  TodoDetails.updatetodoName(id: data.todoId!, todoName: todoNameEditingController.text)
                                                      .then((value) => cancelEditingTodoName());
                                                  CardDetails.updatecardTitle(id: data.todoId!, cardTitle: todoNameEditingController.text);
                                                } else {
                                                  customSnackBar(context: context, text: "Enter the task name");
                                                }
                                              },
                                              child: const Text("Save"),
                                            ),
                                        ],
                                      ),
                                      PopupMenuButton(
                                        splashRadius: 0,
                                        padding: EdgeInsets.zero,
                                        color: Colors.white.withOpacity(1),
                                        offset: const Offset(10, 40),
                                        itemBuilder: (context) => dropDownStatusDataList.map((e) => popupMenuItem(e.toString())).toList(),
                                        onSelected: (value) {
                                          CardDetails.updateCardStatus(id: data.todoId!, newStatus: value);
                                          TodoDetails.updatecardStatus(id: data.todoId!, newStatus: value);
                                          currentStatus = value;
                                          setState(() {});
                                        },
                                        child: IntrinsicWidth(
                                          child: Chip(
                                            label: Row(
                                              children: [
                                                CustomText(
                                                  title: currentStatus ?? data.todoStatus!,
                                                  color: taskStatusColor(currentStatus ?? data.todoStatus!),
                                                  size: 10,
                                                ),
                                                Icon(
                                                  Icons.expand_more,
                                                  size: 18,
                                                  color: taskStatusColor(currentStatus ?? data.todoStatus!),
                                                ),
                                              ],
                                            ),
                                            backgroundColor: taskStatusColor(currentStatus ?? data.todoStatus!).withOpacity(0.1),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 8.0),
                                    child: CustomText(
                                      title: "Due Date",
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => updateDate(data.todoId),
                                    child: CustomChip(
                                      label: Text(data.dueDate!),
                                      avatar: const Icon(
                                        Icons.calendar_month_outlined,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 8.0),
                                        child: CustomText(
                                          title: "Task Description",
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () => startEditingTodoDescription(data.todoDescription!),
                                        child: const CustomChip(
                                          label: Icon(
                                            Icons.edit_outlined,
                                            size: 14,
                                          ),
                                          // paddingHorizontal: 3,
                                        ),
                                      ),
                                    ],
                                  ),
                                  iseditingTodoDescription
                                      ? SizedBox(
                                          width: 350,
                                          child: Textarea(controller: todoDescriptionEditingController),
                                        )
                                      : Text(
                                          data.todoDescription!,
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
                                        ),
                                  const SizedBox(height: 10),
                                  if (iseditingTodoDescription)
                                    Row(
                                      children: [
                                        TextButton(onPressed: () => cancelEditingTodoDescription(), child: const Text("Cancel")),
                                        const SizedBox(width: 10),
                                        ElevatedButton(
                                          onPressed: () {
                                            if (todoDescriptionEditingController.text.isNotEmpty) {
                                              TodoDetails.updateTodoDescription(id: data.todoId!, todoDescription: todoDescriptionEditingController.text)
                                                  .then((value) => cancelEditingTodoDescription());
                                              CardDetails.updateCardDescription(id: data.todoId!, cardDescription: todoDescriptionEditingController.text);
                                            } else {
                                              customSnackBar(context: context, text: "Enter the Description");
                                            }
                                          },
                                          child: const Text("Save"),
                                        ),
                                      ],
                                    ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 8.0),
                                        child: CustomText(
                                          title: "Attachments",
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      StatefulBuilder(
                                        builder: (context, setState) {
                                          return SizedBox(
                                            height: 100,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: attachments!.length + 1,
                                              itemBuilder: (context, index) {
                                                if (index < attachments.length) {
                                                  final attachment = attachments[index];
                                                  return Stack(
                                                    children: [
                                                      Container(
                                                        height: 99,
                                                        margin: const EdgeInsets.only(right: 15),
                                                        width: 108,
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.grey.withOpacity(0.5)),
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            const Icon(
                                                              Icons.image_outlined,
                                                              size: 40,
                                                            ),
                                                            CustomText(
                                                              title: attachment.title!,
                                                              size: 13,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 0,
                                                        right: 10,
                                                        child: Row(
                                                          children: [
                                                            GestureDetector(
                                                              child: const Icon(
                                                                Icons.download_for_offline,
                                                                size: 18,
                                                              ),
                                                              onTap: () {
                                                                if (kIsWeb) {
                                                                  // AnchorElement anchorElement = AnchorElement(href: attachment.path);
                                                                  // anchorElement.download = 'Attachment file';
                                                                  // anchorElement.click();
                                                                }
                                                              },
                                                            ),
                                                            GestureDetector(
                                                              child: const Icon(
                                                                Icons.cancel,
                                                                size: 18,
                                                              ),
                                                              onTap: () {
                                                                showConfirmDeleteAttachment(context, () {
                                                                  TodoDetails.deleteAttachment(itemId: data.todoId!, attachmentIdToDelete: attachment.id!);
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                } else {
                                                  return GestureDetector(
                                                    onTap: () async {
                                                      showUploadDocumentModal(
                                                        context,
                                                        () {},
                                                        selectedDocsName,
                                                        selectedImageName,
                                                        pickedDocuments,
                                                        () {
                                                          setState(() {});
                                                        },
                                                        data.todoId!,
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 100,
                                                      width: 100,
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.grey.withOpacity(0.5)),
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: const Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Icon(
                                                            Icons.add,
                                                            size: 40,
                                                          ),
                                                          CustomText(
                                                            title: 'Add more',
                                                            size: 8,
                                                            fontWeight: FontWeight.w400,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      const ActivityTabView(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (Responsive.isDesktop(context))
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                          width: 1,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      if (Responsive.isDesktop(context))
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: CustomText(
                                          title: data.linkedWorkItem![0].workItemTitle!,
                                          fontWeight: FontWeight.w600,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                CustomButton(
                                  text: 'View Inventory Details',
                                  onPressed: () {
                                    ref.read(selectedWorkItemId.notifier).addItemId(data.linkedWorkItem![0].workItemId!);
                                    context.beamToNamed('/inventory/inventory-details/${data.linkedWorkItem![0].workItemId}');
                                  },
                                  height: 40,
                                ),
                                if (Responsive.isDesktop(context))
                                  AssignmentWidget(
                                    assignto: data.assignedto!,
                                    id: data.todoId!,
                                    imageUrlCreatedBy: data.createdBy == null || data.assignedto![0].image!.isEmpty ? noImg : data.assignedto![0].image!,
                                    createdBy: '${data.assignedto![0].firstname!} ${data.assignedto![0].lastname!}',
                                  ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                }
              }
              return Container(
                color: Colors.amber,
              );
            }),
      ),
    );
  }
}

class Textarea extends StatelessWidget {
  final TextEditingController controller;
  const Textarea({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: 5,
      controller: controller,
      decoration: InputDecoration(
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
}