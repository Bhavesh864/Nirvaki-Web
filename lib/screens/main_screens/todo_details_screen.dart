// ignore_for_file: invalid_use_of_protected_member, avoid_web_libraries_in_flutter
import 'dart:async';
// import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/Customs/snackbar.dart';
import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/firebase/detailsModels/todo_details.dart';
import 'package:yes_broker/constants/firebase/send_notification.dart';
import 'package:yes_broker/constants/functions/datetime/date_time.dart';
import 'package:yes_broker/constants/functions/navigation/navigation_functions.dart';
import 'package:yes_broker/customs/text_utility.dart';
import 'package:yes_broker/riverpodstate/user_data.dart';
import 'package:yes_broker/widgets/app/dropdown_menu.dart';
import 'package:yes_broker/widgets/assigned_circular_images.dart';
import '../../Customs/custom_chip.dart';
import '../../Customs/custom_text.dart';
import '../../constants/firebase/detailsModels/card_details.dart';
import '../../constants/firebase/userModel/user_info.dart';
import '../../constants/functions/workitems_detail_methods.dart';
import '../../constants/utils/colors.dart';
import '../../constants/utils/constants.dart';
import '../../riverpodstate/selected_workitem.dart';
import '../../widgets/app/nav_bar.dart';
import '../../widgets/workItemDetail/assignment_widget.dart';
import '../../widgets/workItemDetail/tab_views/activity_tab_view.dart';
import '../../widgets/workItemDetail/tab_views/details_tab_view.dart';

class TodoDetailsScreen extends ConsumerStatefulWidget {
  final String todoId;
  const TodoDetailsScreen({super.key, this.todoId = ''});

  @override
  TodoDetailsScreenState createState() => TodoDetailsScreenState();
}

class TodoDetailsScreenState extends ConsumerState<TodoDetailsScreen> with TickerProviderStateMixin {
  FocusNode firstFocusNode = FocusNode();
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
    final workItemId = ref.read(selectedWorkItemId);

    if (workItemId.isEmpty || !workItemId.contains('TD')) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(selectedWorkItemId.notifier).addItemId(widget.todoId);
      });
    }
    // todoArray = [];
    todoDetails = FirebaseFirestore.instance.collection('todoDetails').where('todoId', isEqualTo: workItemId.isEmpty ? widget.todoId : workItemId).snapshots();
    // for (var i = 0; i < todoDetails; i++) {
    //   ele = todoDetails[i];
    //   userDeatil = FirebaseFirestore.instance.collection(where id =  ele.userId)
    //  {
    //   ele
    //   ele.assignto = {
    //     userDetail
    //   }
    //  }
    // }
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

  void updateDate(itemid, initialDate) {
    showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: initialDate,
      lastDate: DateTime(initialDate.year + 1),
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

  void updateTime(itemid, time) {
    TimeOfDay initialTime = const TimeOfDay(hour: 0, minute: 0);

    try {
      initialTime = TimeOfDay.fromDateTime(DateFormat('hh:mm a').parse(time));
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing time: $e');
      }
    }

    showTimePicker(
      context: context,
      initialTime: initialTime,
    ).then(
      (time) {
        if (time == null) {
          return;
        }
        DateTime now = DateTime.now();

        DateTime formattedDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          time.hour,
          time.minute,
        );

        TodoDetails.updateCardTime(id: itemid, dueTime: DateFormat('hh:mm a').format(formattedDateTime));
        CardDetails.updateCardTime(id: itemid, dueTime: DateFormat('hh:mm a').format(formattedDateTime));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = ref.read(userDataProvider);
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
          if (!kIsWeb) FocusManager.instance.primaryFocus?.unfocus();
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
                  return GestureDetector(
                    onTap: () {
                      if (isEditingTodoName) {
                        TodoDetails.updatetodoName(id: data.todoId!, todoName: todoNameEditingController.text.trim()).then((value) => setState(() {
                              isEditingTodoName = false;
                              todoNameEditingController.clear();
                            }));
                        CardDetails.updatecardTitle(id: data.todoId!, cardTitle: todoNameEditingController.text.trim());
                        cancelEditingTodoName();
                      } else if (iseditingTodoDescription) {
                        cancelEditingTodoDescription();
                      }
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                            child: GestureDetector(
                              onTap: () {
                                if (!kIsWeb) FocusManager.instance.primaryFocus?.unfocus();
                              },
                              child: SingleChildScrollView(
                                child: Container(
                                  padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Wrap(
                                        runSpacing: 10,
                                        // mainAxisAlignment: MainAxisAlignment.start,
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          isEditingTodoName
                                              ? SizedBox(
                                                  // height: 35,
                                                  width: kIsWeb ? 300 : 190,
                                                  child: CustomTextInput(
                                                    autofocus: true,
                                                    controller: todoNameEditingController,
                                                    onFieldSubmitted: (newValue) {
                                                      if (newValue.isNotEmpty) {
                                                        TodoDetails.updatetodoName(id: data.todoId!, todoName: newValue).then((value) => setState(() {
                                                              isEditingTodoName = false;
                                                              todoNameEditingController.clear();
                                                            }));
                                                        CardDetails.updatecardTitle(id: data.todoId!, cardTitle: newValue);
                                                      } else {
                                                        customSnackBar(context: context, text: "Enter the task name");
                                                      }
                                                    },
                                                  ),
                                                )
                                              : GestureDetector(
                                                  onTap: () {
                                                    startEditingTodoName(data.todoName!);
                                                  },
                                                  child: Text(
                                                    data.todoName!.trim(),
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: CustomChip(
                                              paddingVertical: 6,
                                              color: AppColor.primary.withOpacity(0.1),
                                              label: CustomText(
                                                title: data.todoType!,
                                                size: 10,
                                                color: AppColor.primary,
                                              ),
                                            ),
                                          ),
                                          CustomStatusDropDown(
                                            status: currentStatus ?? data.todoStatus!,
                                            itemBuilder: (context) => todoDropDownList.map((e) => popupMenuItem(e.toString())).toList(),
                                            onSelected: (value) {
                                              CardDetails.updateCardStatus(id: data.todoId!, newStatus: value);
                                              TodoDetails.updatecardStatus(id: data.todoId!, newStatus: value);
                                              currentStatus = value;
                                              setState(() {});
                                              notifyToUser(
                                                  currentuserdata: user!,
                                                  itemid: data.todoId!,
                                                  assignedto: data.assignedto,
                                                  content: "${data.todoId} Todo status changed to $value",
                                                  title: "Todo status changed");
                                            },
                                          ),
                                        ],
                                      ),
                                      if (Responsive.isMobile(context)) ...[
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            checkNotNUllItem(data.linkedWorkItem?[0].workItemTitle)
                                                // ? CustomButton(
                                                //     text: data.linkedWorkItem![0].workItemId!.contains('LD') ? 'View Lead Detail' : 'View Inventory Detail',
                                                //     onPressed: () {
                                                //       navigateBasedOnId(context, data.linkedWorkItem![0].workItemId!, ref);
                                                //     },
                                                //     height: 40,
                                                //   )
                                                ? ElevatedButton(
                                                    onPressed: () {
                                                      navigateBasedOnId(context, data.linkedWorkItem![0].workItemId!, ref);
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: AppColor.primary,
                                                      // minimumSize: const Size(100, 20),
                                                      padding: const EdgeInsets.all(8),
                                                    ),
                                                    child: Text(
                                                      data.linkedWorkItem![0].workItemId!.contains('LD') ? 'View Lead Detail' : 'View Inventory Detail',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w600,
                                                        letterSpacing: 0.3,
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox.shrink(),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            GestureDetector(
                                                onTap: () {
                                                  showOwnerDetailsAndAssignToBottomSheet(
                                                    context,
                                                    'Assignment',
                                                    AssignmentWidget(
                                                      assignto: data.assignedto!,
                                                      id: data.todoId!,
                                                      imageUrlCreatedBy:
                                                          data.createdby!.userimage == null || data.createdby!.userimage!.isEmpty ? noImg : data.createdby!.userimage!,
                                                      createdBy: data.createdby!.userid!,
                                                      data: data,
                                                    ),
                                                  );
                                                },
                                                child: AssignedCircularImages(
                                                  cardData: data,
                                                  heightOfCircles: 28,
                                                  widthOfCircles: 28,
                                                )),
                                          ],
                                        ),
                                      ],
                                      if (Responsive.isMobile(context)) ...[
                                        const Divider(
                                          height: 30,
                                        ),
                                      ] else ...[
                                        const SizedBox(
                                          height: 30,
                                        ),
                                      ],
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 8.0),
                                        child: CustomText(
                                          title: "Due Date",
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () => updateDate(
                                              data.todoId,
                                              DateFormat('dd-MM-yy').parse(data.dueDate!),
                                            ),
                                            child: CustomChip(
                                              paddingVertical: 6,
                                              label: Text(
                                                DateFormat('dd MMM yyyy').format(
                                                  DateFormat('dd-MM-yy').parse(data.dueDate!),
                                                ),
                                              ),
                                              avatar: const Icon(
                                                Icons.calendar_month_outlined,
                                              ),
                                            ),
                                          ),
                                          if (checkNotNUllItem(data.dueTime))
                                            GestureDetector(
                                              onTap: () => updateTime(data.todoId, data.dueTime!),
                                              child: CustomChip(
                                                paddingVertical: 6,
                                                label: Text(data.dueTime!),
                                                avatar: const Icon(
                                                  Icons.schedule,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      if (Responsive.isMobile(context)) ...[
                                        const Divider(
                                          height: 30,
                                        ),
                                      ] else ...[
                                        const SizedBox(
                                          height: 30,
                                        ),
                                      ],
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
                                              paddingVertical: 6,
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
                                              data.todoDescription!.trim(),
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
                                      if (Responsive.isMobile(context)) ...[
                                        const Divider(
                                          height: 30,
                                        ),
                                      ] else ...[
                                        const SizedBox(
                                          height: 30,
                                        ),
                                      ],
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
                                              return Wrap(
                                                runSpacing: 20,
                                                children: [
                                                  SizedBox(
                                                    height: 120,
                                                    child: ListView.builder(
                                                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                                                      shrinkWrap: true,
                                                      scrollDirection: Axis.horizontal,
                                                      itemCount: attachments!.length,
                                                      itemBuilder: (context, index) {
                                                        // if (index < attachments.length) {
                                                        final attachment = attachments[index];
                                                        return Stack(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                showDialog(
                                                                  context: context,
                                                                  builder: (context) {
                                                                    return AttachmentPreviewDialog(
                                                                      attachmentPath: attachment.path!,
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              child: Container(
                                                                height: 99,
                                                                margin: const EdgeInsets.only(right: 15, top: 5),
                                                                width: 108,
                                                                clipBehavior: Clip.none,
                                                                alignment: Alignment.center,
                                                                padding: const EdgeInsets.symmetric(vertical: 10),
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(color: Colors.grey.withOpacity(0.5)),
                                                                  borderRadius: BorderRadius.circular(10),
                                                                ),
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    const Icon(
                                                                      Icons.image_outlined,
                                                                      size: 40,
                                                                    ),
                                                                    Column(
                                                                      children: [
                                                                        CustomText(
                                                                          title: attachment.title!,
                                                                          size: 13,
                                                                          fontWeight: FontWeight.w400,
                                                                        ),
                                                                        CustomText(
                                                                          title: 'Added ${formatMessageDate(attachment.createddate!.toDate())}',
                                                                          size: 8,
                                                                          color: Colors.grey,
                                                                          fontWeight: FontWeight.w400,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top: 0,
                                                              right: 10,
                                                              child: Row(
                                                                children: [
                                                                  InkWell(
                                                                    child: const Icon(
                                                                      Icons.download_for_offline,
                                                                      size: 18,
                                                                    ),
                                                                    onTap: () {
                                                                      // if (kIsWeb) {
                                                                      //   AnchorElement anchorElement = AnchorElement(href: attachment.path);
                                                                      //   anchorElement.download = 'Attachment file';
                                                                      //   anchorElement.click();
                                                                      // }
                                                                    },
                                                                  ),
                                                                  InkWell(
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
                                                        // } else {

                                                        // },
                                                      },
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      showUploadDocumentModal(
                                                        context,
                                                        () {},
                                                        selectedImageName,
                                                        () {
                                                          setState(() {});
                                                        },
                                                        data.todoId!,
                                                        (b) {},
                                                      );
                                                    },
                                                    borderRadius: BorderRadius.circular(10),
                                                    child: Container(
                                                      height: 100,
                                                      width: 100,
                                                      margin: const EdgeInsets.only(top: 4),
                                                      alignment: Alignment.center,
                                                      padding: const EdgeInsets.symmetric(vertical: 15),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.grey.withOpacity(0.5)),
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: const Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Icon(
                                                            Icons.add,
                                                            size: 40,
                                                          ),
                                                          CustomText(
                                                            title: 'ADD MORE',
                                                            size: 10,
                                                            fontWeight: FontWeight.w400,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                          if (Responsive.isMobile(context)) ...[
                                            const Divider(
                                              height: 30,
                                            ),
                                          ] else ...[
                                            const SizedBox(
                                              height: 30,
                                            ),
                                          ],
                                          ActivityTabView(details: data),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (!Responsive.isMobile(context)) ...[
                          const VerticalDivider(
                            indent: 15,
                            width: 30,
                          ),
                          SizedBox(
                            // flex: 1,
                            width: 350,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  checkNotNUllItem(data.linkedWorkItem?[0].workItemTitle)
                                      ? Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0, right: 4),
                                          child: AppText(
                                            overflow: TextOverflow.ellipsis,
                                            text: data.linkedWorkItem![0].workItemTitle!,
                                            fontWeight: FontWeight.w600,
                                            fontsize: 20,
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                  checkNotNUllItem(data.linkedWorkItem?[0].workItemTitle)
                                      ? CustomButton(
                                          text: data.linkedWorkItem![0].workItemId!.contains('LD') ? 'View Lead Details' : 'View Inventory Details',
                                          onPressed: () {
                                            navigateBasedOnId(context, data.linkedWorkItem![0].workItemId!, ref);
                                          },
                                          height: 40,
                                        )
                                      : const SizedBox.shrink(),
                                  if (Responsive.isDesktop(context))
                                    AssignmentWidget(
                                      assignto: data.assignedto!,
                                      id: data.todoId!,
                                      imageUrlCreatedBy: data.createdby!.userimage == null || data.createdby!.userimage!.isEmpty ? noImg : data.createdby!.userimage!,
                                      createdBy: data.createdby!.userid!,
                                      data: data,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
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

void customDeleteBox(BuildContext context, void Function() onConfirmPress, String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: AppText(
          text: title,
          fontsize: 20,
          fontWeight: FontWeight.w500,
        ),
        content: AppText(
          text: content,
          fontWeight: FontWeight.w600,
          fontsize: 16,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const AppText(
              text: 'Cancel',
              fontWeight: FontWeight.w500,
              fontsize: 16,
              textColor: AppColor.primary,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirmPress();
            },
            child: const AppText(
              text: 'Delete',
              fontWeight: FontWeight.w500,
              fontsize: 16,
              textColor: AppColor.primary,
            ),
          ),
        ],
      );
    },
  );
}
