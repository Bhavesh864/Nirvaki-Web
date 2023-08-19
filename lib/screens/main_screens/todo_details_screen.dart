// ignore_for_file: invalid_use_of_protected_member
import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/Customs/responsive.dart';
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

class TodoDetailsScreen extends ConsumerStatefulWidget {
  final String todoId;
  const TodoDetailsScreen({super.key, this.todoId = ''});

  @override
  TodoDetailsScreenState createState() => TodoDetailsScreenState();
}

class TodoDetailsScreenState extends ConsumerState<TodoDetailsScreen> with TickerProviderStateMixin {
  late TabController tabviewController;
  late Future<TodoDetails?> todoDetails;
  PlatformFile? selectedImageName;
  List<PlatformFile> pickedDocuments = [];
  List<String> selectedDocsName = [];
  String? currentStatus;

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 4, vsync: this);
    // final workItemId = ref.read(selectedWorkItemId.notifier).state;
    // todoDetails = TodoDetails.getTodoDetails(workItemId == '' ? widget.todoId : workItemId);
  }

  @override
  Widget build(BuildContext context) {
    final workItemId = ref.read(selectedWorkItemId.notifier).state;
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
      body: FutureBuilder(
          future: TodoDetails.getTodoDetails(workItemId == '' ? widget.todoId : workItemId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (snapshot.hasData) {
              final data = snapshot.data;

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
                                        child: Text(
                                          data!.todoName!,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
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
                              CustomChip(
                                label: Text(data.dueDate!),
                                avatar: const Icon(
                                  Icons.calendar_month_outlined,
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: CustomText(
                                  title: "Task Description",
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                data.todoDescription!,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
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
                                  SizedBox(
                                    height: 100,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: data.attachments!.length + 1,
                                      itemBuilder: (context, index) {
                                        if (index < data.attachments!.length) {
                                          final attachment = data.attachments![index];
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
                                                top: -13,
                                                right: 0,
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.cancel,
                                                    size: 16,
                                                  ),
                                                  onPressed: () {
                                                    TodoDetails.deleteAttachment(itemId: data.todoId!, attachmentIdToDelete: attachment.id!)
                                                        .then((value) => setState(() {}));
                                                  },
                                                ),
                                              ),
                                            ],
                                          );
                                        } else {
                                          return GestureDetector(
                                            onTap: () async {
                                              showUploadDocumentModal(
                                                context,
                                                () {
                                                  setState(() {});
                                                },
                                                selectedDocsName,
                                                selectedImageName,
                                                pickedDocuments,
                                                () {},
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
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  // const ActivityTabView(),
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
                                // showOwnerDetailsAndAssignToBottomSheet(
                                //   context,
                                //   'Owner Details',
                                //   ContactInformation(customerinfo: data.customerinfo!),
                                // );
                              },
                              height: 40,
                            ),
                            if (Responsive.isDesktop(context))
                              AssignmentWidget(
                                imageUrlAssignTo: data.assignedto![0].image == null || data.assignedto![0].image!.isEmpty ? noImg : data.assignedto![0].image!,
                                imageUrlCreatedBy: data.createdBy == null || data.assignedto!.isEmpty ? noImg : data.assignedto![0].image!,
                                createdBy: '${data.assignedto![0].firstname!} ${data.assignedto![0].lastname!}',
                                assignTo: '${data.assignedto![0].firstname!} ${data.assignedto![0].lastname!}',
                              ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            }
            return Container(
              color: Colors.amber,
            );
          }),
    );
  }
}
