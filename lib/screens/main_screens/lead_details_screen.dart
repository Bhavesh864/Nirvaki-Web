// ignore_for_file: invalid_use_of_protected_member

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/firebase/detailsModels/lead_details.dart';
import '../../Customs/custom_text.dart';
import '../../constants/utils/colors.dart';
import '../../constants/utils/constants.dart';
import '../../riverpodstate/selected_workitem.dart';
import '../../widgets/workItemDetail/assignment_widget.dart';
import '../../widgets/workItemDetail/contact_information.dart';
import '../../widgets/workItemDetail/inventory_details_header.dart';
import '../../widgets/workItemDetail/mapview_widget.dart';
import '../../widgets/workItemDetail/tab_bar_widget.dart';
import '../../widgets/workItemDetail/tab_views/activity_tab_view.dart';
import '../../widgets/workItemDetail/tab_views/details_tab_view.dart';

class LeadDetailsScreen extends ConsumerStatefulWidget {
  const LeadDetailsScreen({super.key});

  @override
  LeadDetailsScreenState createState() => LeadDetailsScreenState();
}

class LeadDetailsScreenState extends ConsumerState<LeadDetailsScreen> with TickerProviderStateMixin {
  late TabController tabviewController;
  late Future<LeadDetails?> leadDetails;
  PlatformFile? selectedImageName;
  List<PlatformFile> pickedDocuments = [];
  List<String> selectedDocsName = [];
  int currentSelectedTab = 0;

  void showOwnerDetailsAndAssignToBottomSheet(BuildContext context, String title, Widget innerContent) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (BuildContext context) {
        return Container(
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

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 4, vsync: this);
    // final workItemId = ref.read(selectedWorkItemId.notifier).state;
    // leadDetails = LeadDetails.getLeadDetails(workItemId);
  }

  @override
  Widget build(BuildContext context) {
    final workItemId = Responsive.isMobile(context) ? ModalRoute.of(context)!.settings.arguments : ref.watch(selectedWorkItemId.notifier).state;
    leadDetails = LeadDetails.getLeadDetails(workItemId);

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
                title: 'Lead Details',
                color: Colors.black,
              ),
              foregroundColor: Colors.black,
              toolbarHeight: 50,
            )
          : null,
      body: FutureBuilder(
          future: leadDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (snapshot.hasData) {
              final data = snapshot.data;
              return Container(
                decoration: !Responsive.isMobile(context)
                    ? const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.secondary,
                            spreadRadius: 12,
                            blurRadius: 4,
                            offset: Offset(5, 5),
                          ),
                        ],
                        color: Colors.white,
                      )
                    : null,
                child: Row(
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
                                  title: data!.leadTitle!,
                                  category: data.leadcategory!,
                                  type: data.leadType!,
                                  propertyCategory: data.propertycategory!,
                                  status: data.leadStatus!,
                                  price: data.propertypricerange?.arearangestart,
                                  unit: data.propertypricerange?.unit,
                                ),
                                if (Responsive.isMobile(context))
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: HeaderChips(
                                      category: data.leadcategory!,
                                      type: data.leadType!,
                                      propertyCategory: data.propertycategory!,
                                      status: data.leadStatus!,
                                    ),
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
                                    title: '${data.preferredlocality!.state},${data.preferredlocality!.city},${data.preferredlocality!.addressline1}',
                                    size: 12,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFFA8A8A8),
                                  ),
                                ),
                                if (Responsive.isMobile(context))
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
                                if (Responsive.isMobile(context))
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
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: CustomText(
                                        title: data.propertypricerange?.arearangestart != null
                                            ? '${data.propertypricerange!.arearangestart}${data.propertypricerange!.unit}'
                                            : '50k/month',
                                        color: AppColor.primary,
                                      ),
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
                                    isLeadView: true,
                                    data: data,
                                    pickedDocuments: pickedDocuments,
                                    selectedDocsName: selectedDocsName,
                                    selectedImageName: selectedImageName,
                                  ),
                                if (currentSelectedTab == 1) const ActivityTabView(),
                                // if (currentSelectedTab == 2)  TodoTabView(data),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (Responsive.isDesktop(context)) ...[
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        width: 1,
                        color: Colors.grey.withOpacity(0.5),
                      ),
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
                                  state: data.preferredlocality!.state!,
                                  city: data.preferredlocality!.city!,
                                  addressline1: data.preferredlocality!.addressline1!,
                                  addressline2: data.preferredlocality?.addressline2,
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
            return Container(
              color: Colors.amber,
            );
          }),
    );
  }
}
