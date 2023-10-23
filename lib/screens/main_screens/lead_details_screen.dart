// ignore_for_file: invalid_use_of_protected_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yes_broker/Customs/text_utility.dart';

import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/firebase/detailsModels/lead_details.dart';
import 'package:yes_broker/pages/add_lead.dart';

import 'package:yes_broker/riverpodstate/all_selected_ansers_provider.dart';
import 'package:yes_broker/widgets/assigned_circular_images.dart';
import '../../constants/functions/convertStringTorange/convert_string_to_range.dart';
import '../../constants/functions/workitems_detail_methods.dart';
import '../../customs/custom_text.dart';
import '../../constants/utils/colors.dart';
import '../../constants/utils/constants.dart';
import '../../riverpodstate/common_index_state.dart';
import '../../riverpodstate/selected_workitem.dart';
import '../../widgets/workItemDetail/assignment_widget.dart';
import '../../widgets/workItemDetail/contact_information.dart';
import '../../widgets/workItemDetail/inventory_details_header.dart';
import '../../widgets/workItemDetail/tab_bar_widget.dart';
import '../../widgets/workItemDetail/tab_views/activity_tab_view.dart';
import '../../widgets/workItemDetail/tab_views/details_tab_view.dart';
import '../../widgets/workItemDetail/tab_views/todo_tab_view.dart';

class LeadDetailsScreen extends ConsumerStatefulWidget {
  final String leadId;
  const LeadDetailsScreen({super.key, this.leadId = ''});

  @override
  LeadDetailsScreenState createState() => LeadDetailsScreenState();
}

class LeadDetailsScreenState extends ConsumerState<LeadDetailsScreen> with TickerProviderStateMixin {
  late TabController tabviewController;
  late Stream<QuerySnapshot<Map<String, dynamic>>> leadDetails;
  PlatformFile? selectedImageName;
  List<PlatformFile> pickedDocuments = [];
  List<String> selectedDocsName = [];

  @override
  void initState() {
    super.initState();
    final currentIndex = ref.read(detailsPageIndexTabProvider);
    tabviewController = TabController(length: 3, vsync: this, initialIndex: currentIndex);
    final workItemId = ref.read(selectedWorkItemId);
    if (workItemId.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(selectedWorkItemId.notifier).addItemId(widget.leadId);
      });
    }
    leadDetails = FirebaseFirestore.instance.collection('leadDetails').where('leadId', isEqualTo: workItemId.isEmpty ? widget.leadId : workItemId).snapshots();
    AppConst.setPublicView(false);
  }

  @override
  Widget build(BuildContext context) {
    final notify = ref.read(myArrayProvider.notifier);
    final currentSelectedTab = ref.watch(detailsPageIndexTabProvider);

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
      body: StreamBuilder(
          stream: leadDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (snapshot.hasData) {
              final dataList = snapshot.data!.docs;

              List<LeadDetails> leadlist = dataList.map((doc) => LeadDetails.fromSnapshot(doc)).toList();

              for (var data in leadlist) {
                Future.delayed(const Duration(milliseconds: 500)).then((value) => setLeadEditData(notify, data));
                return GestureDetector(
                  onTap: () {
                    if (!kIsWeb) FocusManager.instance.primaryFocus?.unfocus();
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
                              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                                      setCurrentIndex: (p0) {
                                        ref.read(detailsPageIndexTabProvider.notifier).update((state) => 0);
                                        tabviewController.animateTo(0);
                                      },
                                      id: data.leadId!,
                                      inventoryDetails: data,
                                      title: data.leadTitle!,
                                      category: data.leadcategory!,
                                      type: data.leadType!,
                                      propertyCategory: data.propertycategory!,
                                      status: data.leadStatus!,
                                      price: "${data.propertypricerange?.arearangestart}-${data.propertypricerange?.arearangeend}",
                                    ),
                                    if (Responsive.isMobile(context))
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Wrap(
                                          runSpacing: 10,
                                          crossAxisAlignment: WrapCrossAlignment.center,
                                          alignment: WrapAlignment.spaceBetween,
                                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            HeaderChips(
                                              id: data.leadId!,
                                              category: data.leadcategory!,
                                              type: data.leadType!,
                                              propertyCategory: data.propertycategory!,
                                              status: data.leadStatus!,
                                              inventoryDetails: data,
                                            ),
                                            CustomText(
                                              size: 14,
                                              softWrap: true,
                                              textAlign: TextAlign.start,
                                              title: data.propertypricerange?.arearangestart != null
                                                  ? '${data.propertypricerange?.arearangestart} - ${data.propertypricerange?.arearangeend}'
                                                  : '',
                                              color: AppColor.primary,
                                            ),
                                          ],
                                        ),
                                      ),
                                    // ListTile(
                                    //   contentPadding: const EdgeInsets.all(0),
                                    //   leading: const Icon(
                                    //     Icons.location_on_outlined,
                                    //     size: 20,
                                    //     color: Colors.black,
                                    //   ),
                                    //   minLeadingWidth: 2,
                                    //   horizontalTitleGap: 8,
                                    //   titleAlignment: ListTileTitleAlignment.center,
                                    //   title: CustomText(
                                    //     title: '${data.preferredlocality!.state},${data.preferredlocality!.city},${data.preferredlocality!.addressline1}',
                                    //     size: 12,
                                    //     fontWeight: FontWeight.w400,
                                    //     color: const Color(0xFFA8A8A8),
                                    //   ),
                                    // ),
                                    if (Responsive.isMobile(context))
                                      Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    showOwnerDetailsAndAssignToBottomSheet(
                                                      context,
                                                      'Owner Details',
                                                      ContactInformation(customerinfo: data.customerinfo!),
                                                    );
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: AppColor.primary,
                                                    // minimumSize: const Size(100, 20),
                                                    padding: const EdgeInsets.all(8),
                                                  ),
                                                  child: const Text(
                                                    'Owner Details',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                      letterSpacing: 0.3,
                                                    ),
                                                  ),
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
                                                          id: data.leadId!,
                                                          assignto: data.assignedto!,
                                                          imageUrlCreatedBy: data.createdby!.userimage == null || data.createdby!.userimage!.isEmpty
                                                              ? noImg
                                                              : data.createdby!.userimage!,
                                                          createdBy: '${data.createdby!.userfirstname!} ${data.createdby!.userlastname!}',
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
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.calendar_month_outlined,
                                                  size: 20,
                                                  color: Colors.black,
                                                ),
                                                const SizedBox(width: 5),
                                                CustomText(
                                                  title: DateFormat('d MMM y').format(data.createdate!.toDate()),
                                                  size: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xFFA8A8A8),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    // if (Responsive.isMobile(context))
                                    //   Padding(
                                    //     padding: const EdgeInsets.only(top: 12.0),
                                    //     child: CustomText(
                                    //       title: data.propertypricerange?.arearangestart != null
                                    //           ? '${data.propertypricerange?.arearangestart} ${data.propertypricerange?.arearangeend}'
                                    //           : '50k/month',
                                    //       color: AppColor.primary,
                                    //     ),
                                    //   ),
                                    if (!AppConst.getPublicView())
                                      TabBarWidget(
                                        tabviewController: tabviewController,
                                        onTabChanged: (e) {
                                          ref.read(detailsPageIndexTabProvider.notifier).update((state) => e);
                                        },
                                      ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    if (currentSelectedTab == 0)
                                      DetailsTabView(
                                        id: data.leadId!,
                                        isLeadView: true,
                                        data: data,
                                        updateData: () {
                                          setState(() {});
                                        },
                                      ),
                                    if (currentSelectedTab == 1) ActivityTabView(details: data),
                                    if (currentSelectedTab == 2) TodoTabView(id: data.leadId!),
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
                          width: Responsive.isTablet(context) ? 300 : 340,
                          // flex: 1,
                          child: SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ContactInformation(
                                    customerinfo: data.customerinfo!,
                                  ),
                                  // if (Responsive.isDesktop(context))
                                  AssignmentWidget(
                                    id: data.leadId!,
                                    assignto: data.assignedto!,
                                    imageUrlCreatedBy: data.createdby!.userimage == null || data.createdby!.userimage!.isEmpty ? noImg : data.createdby!.userimage!,
                                    createdBy: '${data.createdby!.userfirstname!} ${data.createdby!.userlastname!}',
                                    data: data,
                                  ),
                                  if (Responsive.isDesktop(context)) ...[
                                    const AppText(
                                      text: "Preffered Locality",
                                      fontsize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: data.preferredlocality?.listofLocality?.map(
                                            (e) {
                                              return Container(
                                                margin: const EdgeInsets.only(bottom: 7),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.location_on_outlined,
                                                      size: 16,
                                                      color: Colors.black,
                                                    ),
                                                    Container(
                                                      margin: const EdgeInsets.only(left: 4),
                                                      width: 300,
                                                      child: AppText(
                                                        text: e.fullAddress.toString(),
                                                        softwrap: true,
                                                        fontsize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ).toList() ??
                                          [],
                                    )
                                  ],
                                  //   MapViewWidget(
                                  //     latLng: LatLng(data.preferredlocation![0], data.preferredlocation![1]),
                                  //     state: data.preferredlocality!.state!,
                                  //     city: data.preferredlocality!.city!,
                                  //     addressline1: data.preferredlocality?.addressline1,
                                  //     addressline2: data.preferredlocality?.addressline2,
                                  //     locality: data.preferredlocality!.locality!,
                                  //   ),
                                ],
                              ),
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
    );
  }

  void setLeadEditData(AllChipSelectedAnwers notify, LeadDetails data) {
    try {
      return notify.addAllvalues([
        {"id": 1, "item": data.propertycategory},
        {"id": 2, "item": data.leadcategory},
        {"id": 4, "item": data.leadsource},
        {"id": 5, "item": data.customerinfo?.firstname},
        {"id": 6, "item": data.customerinfo?.lastname},
        {"id": 7, "item": data.customerinfo?.mobile},
        {"id": 8, "item": data.customerinfo?.whatsapp},
        {"id": 9, "item": data.customerinfo?.email},
        {"id": 10, "item": data.customerinfo?.companyname},
        {"id": 11, "item": data.propertykind},
        {"id": 12, "item": data.villatype},
        {"id": 13, "item": data.transactiontype},
        {"id": 14, "item": data.roomconfig?.bedroom},
        {"id": 15, "item": data.roomconfig?.additionalroom},
        {"id": 16, "item": data.roomconfig?.bathroom},
        {"id": 17, "item": data.roomconfig?.balconies},
        {"id": 18, "item": data.plotdetails?.boundarywall},
        {"id": 19, "item": data.plotdetails?.opensides},
        {"id": 20, "item": data.possessiondate},
        {"id": 21, "item": data.amenities},
        {"id": 22, "item": data.reservedparking?.covered},
        {"id": 23, "item": data.propertyarea?.unit},
        {"id": 24, "item": convertStringRangeToRangeValues(startValue: data.propertyarearange!.arearangestart!, endValue: data.propertyarearange!.arearangeend!)},
        {"id": 25, "item": data.propertyarea?.carpetarea},
        {"id": 26, "item": data.preferredlocality?.state},
        {"id": 27, "item": data.preferredlocality?.city},
        {"id": 28, "item": data.preferredlocality?.addressline1},
        {"id": 29, "item": data.preferredlocality?.addressline2},
        {"id": 30, "item": data.preferredlocality?.prefferedfloornumber},
        {"id": 31, "item": data.preferredlocation},
        {"id": 32, "item": convertStringRangeToRangeValues(startValue: data.propertypricerange!.arearangestart!, endValue: data.propertypricerange!.arearangeend!)},
        {"id": 33, "item": data.propertypricerange?.unit},
        {"id": 34, "item": data.preferredpropertyfacing},
        {"id": 35, "item": data.comments},
        {"id": 36, "item": data.assignedto},
        {"id": 37, "item": data.availability},
        {"id": 38, "item": data.commericialtype},
        {"id": 39, "item": data.typeofoffice},
        {"id": 40, "item": data.typeofretail},
        {"id": 41, "item": data.typeofhospitality},
        {"id": 42, "item": data.typeofhealthcare},
        {"id": 43, "item": data.approvedbeds},
        {"id": 44, "item": data.typeofschool},
        {"id": 45, "item": data.hospitalrooms},
        {"id": 46, "item": data.preferredroadwidth},
        {"id": 47, "item": data.preferredroadwidthAreaUnit},
        {"id": 100, "item": data.attachments},
        {"id": 101, "item": data.leadId},
        {"id": 54, "item": data.preferredlocality?.locality},
        {"id": 55, "item": data.furnishedStatus},
        {"id": 56, "item": data.preferredlocality?.listofLocality},
      ]);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
