// ignore_for_file: invalid_use_of_protected_member
import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/firebase/detailsModels/inventory_details.dart';
import '../../Customs/custom_text.dart';
import '../../Customs/small_custom_profile_image.dart';
import '../../constants/functions/workitems_detail_methods.dart';
import '../../constants/utils/colors.dart';
import '../../constants/utils/constants.dart';
import '../../riverpodstate/selected_workitem.dart';
import '../../widgets/workItemDetail/inventory_details_header.dart';
import '../../widgets/workItemDetail/assignment_widget.dart';
import '../../widgets/workItemDetail/contact_information.dart';
import '../../widgets/workItemDetail/mapview_widget.dart';
import '../../widgets/workItemDetail/tab_bar_widget.dart';
import '../../widgets/workItemDetail/tab_views/activity_tab_view.dart';
import '../../widgets/workItemDetail/tab_views/details_tab_view.dart';
import '../../widgets/workItemDetail/tab_views/todo_tab_view.dart';

class InventoryDetailsScreen extends ConsumerStatefulWidget {
  final String inventoryId;
  const InventoryDetailsScreen({super.key, this.inventoryId = ''});

  @override
  InventoryDetailsScreenState createState() => InventoryDetailsScreenState();
}

class InventoryDetailsScreenState extends ConsumerState<InventoryDetailsScreen> with TickerProviderStateMixin {
  late TabController tabviewController;
  late Future<InventoryDetails?> inventoryDetails;
  PlatformFile? selectedImageName;
  List<PlatformFile> pickedDocuments = [];
  List<String> selectedDocsName = [];
  int currentSelectedTab = 0;

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 4, vsync: this);
    final workItemId = ref.read(selectedWorkItemId.notifier).state;
    inventoryDetails = InventoryDetails.getInventoryDetails(workItemId == '' ? widget.inventoryId : workItemId);
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
                title: 'Inventory Details',
                color: Colors.black,
              ),
              foregroundColor: Colors.black,
              toolbarHeight: 50,
            )
          : null,
      body: FutureBuilder(
          future: inventoryDetails,
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
                              InventoryDetailsHeader(
                                setState: () {
                                  setState(() {});
                                },
                                id: data!.inventoryId!,
                                title: data.inventoryTitle!,
                                category: data.inventorycategory!,
                                type: data.inventoryType!,
                                propertyCategory: data.propertycategory!,
                                status: data.inventoryStatus!,
                                price: data.propertyprice?.price,
                                unit: data.propertyprice?.unit,
                              ),
                              if (Responsive.isMobile(context))
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: HeaderChips(
                                      category: data.inventorycategory!,
                                      type: data.inventoryType!,
                                      propertyCategory: data.propertycategory!,
                                      status: data.inventoryStatus!,
                                      id: data.inventoryId!),
                                ),
                              ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                leading: const Icon(
                                  Icons.location_on_outlined,
                                  size: 20,
                                  color: Colors.black,
                                ),
                                minLeadingWidth: 2,
                                horizontalTitleGap: 8,
                                titleAlignment: ListTileTitleAlignment.center,
                                title: CustomText(
                                  title: '${data.propertyaddress!.state},${data.propertyaddress!.city},${data.propertyaddress!.addressline1}',
                                  size: 12,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFFA8A8A8),
                                ),
                              ),
                              if (Responsive.isMobile(context))
                                Row(
                                  children: [
                                    CustomButton(
                                      text: 'View Owner Detail',
                                      onPressed: () {
                                        showOwnerDetailsAndAssignToBottomSheet(
                                          context,
                                          'Owner Details',
                                          ContactInformation(customerinfo: data.customerinfo!),
                                        );
                                      },
                                      height: 40,
                                      width: 180,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showOwnerDetailsAndAssignToBottomSheet(
                                          context,
                                          'Assignment',
                                          AssignmentWidget(
                                            imageUrlAssignTo: data.assignedto![0].image == null || data.assignedto![0].image!.isEmpty ? noImg : data.assignedto![0].image!,
                                            imageUrlCreatedBy: data.createdby!.userimage == null || data.createdby!.userimage!.isEmpty ? noImg : data.createdby!.userimage!,
                                            createdBy: data.createdby!.userfirstname! + data.createdby!.userlastname!,
                                            assignTo: data.assignedto![0].firstname! + data.assignedto![0].firstname!,
                                          ),
                                        );
                                      },
                                      child: SmallCustomCircularImage(
                                        width: 30,
                                        height: 30,
                                        imageUrl: data.assignedto![0].image!,
                                      ),
                                    ),
                                  ],
                                ),
                              if (Responsive.isMobile(context))
                                Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: CustomText(
                                    title: data.propertyprice?.price != null ? '${data.propertyprice!.price}${data.propertyprice!.unit}' : '50k/month',
                                    color: AppColor.primary,
                                  ),
                                ),
                              if (!AppConst.getPublicView())
                                TabBarWidget(
                                  tabviewController: tabviewController,
                                  onTabChanged: (e) {
                                    setState(() {
                                      currentSelectedTab = e;
                                    });
                                  },
                                ),
                              const SizedBox(
                                height: 30,
                              ),
                              if (currentSelectedTab == 0)
                                DetailsTabView(
                                  id: data.inventoryId!,
                                  data: data,
                                  pickedFilesList: pickedDocuments,
                                  selectedDocNameList: selectedDocsName,
                                  selectedFileName: selectedImageName,
                                ),
                              if (currentSelectedTab == 1) const ActivityTabView(),
                              if (currentSelectedTab == 2) const TodoTabView(),
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
                            ContactInformation(
                              customerinfo: data.customerinfo!,
                            ),
                            if (Responsive.isDesktop(context))
                              AssignmentWidget(
                                imageUrlAssignTo: data.assignedto![0].image == null || data.assignedto![0].image!.isEmpty ? noImg : data.assignedto![0].image!,
                                imageUrlCreatedBy: data.createdby!.userimage == null || data.createdby!.userimage!.isEmpty ? noImg : data.createdby!.userimage!,
                                createdBy: '${data.createdby!.userfirstname!} ${data.createdby!.userlastname!}',
                                assignTo: '${data.assignedto![0].firstname!} ${data.assignedto![0].lastname!}',
                              ),
                            if (Responsive.isDesktop(context))
                              MapViewWidget(
                                state: data.propertyaddress!.state!,
                                city: data.propertyaddress!.city!,
                                addressline1: data.propertyaddress!.addressline1!,
                                addressline2: data.propertyaddress?.addressline2,
                              ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            }
            return const SizedBox();
          }),
    );
  }
}
