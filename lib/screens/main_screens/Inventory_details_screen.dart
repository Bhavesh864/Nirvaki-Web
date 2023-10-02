import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/firebase/detailsModels/inventory_details.dart';
import 'package:yes_broker/constants/functions/datetime/date_time.dart';
import 'package:yes_broker/pages/add_inventory.dart';
import 'package:yes_broker/riverpodstate/all_selected_ansers_provider.dart';

import '../../Customs/custom_text.dart';
import '../../constants/functions/convertStringTorange/convert_number_to_string.dart';
import '../../constants/functions/workitems_detail_methods.dart';
import '../../constants/utils/colors.dart';
import '../../constants/utils/constants.dart';
import '../../riverpodstate/common_index_state.dart';
import '../../riverpodstate/selected_workitem.dart';
import '../../widgets/workItemDetail/assignment_widget.dart';
import '../../widgets/workItemDetail/contact_information.dart';
import '../../widgets/workItemDetail/inventory_details_header.dart';
import '../../widgets/workItemDetail/mapview_widget.dart';
import '../../widgets/workItemDetail/tab_bar_widget.dart';
import '../../widgets/workItemDetail/tab_views/activity_tab_view.dart';
import '../../widgets/workItemDetail/tab_views/details_tab_view.dart';
import '../../widgets/workItemDetail/tab_views/todo_tab_view.dart';

class InventoryDetailsScreen extends ConsumerStatefulWidget {
  final String? inventoryId;

  const InventoryDetailsScreen({
    super.key,
    this.inventoryId,
  });

  @override
  InventoryDetailsScreenState createState() => InventoryDetailsScreenState();
}

class InventoryDetailsScreenState extends ConsumerState<InventoryDetailsScreen> with TickerProviderStateMixin {
  late TabController tabviewController;
  late Stream<QuerySnapshot<Map<String, dynamic>>> inventoryDetails;
  int currentSelectedTab = 0;

  @override
  void initState() {
    super.initState();
    final currentIndex = ref.read(detailsPageIndexTabProvider);
    currentSelectedTab = currentIndex;
    tabviewController = TabController(length: 3, vsync: this, initialIndex: currentIndex);
    final workItemId = ref.read(selectedWorkItemId);
    inventoryDetails = FirebaseFirestore.instance.collection('inventoryDetails').where('InventoryId', isEqualTo: workItemId == '' ? widget.inventoryId : workItemId).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final notify = ref.read(myArrayProvider.notifier);
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
      body: StreamBuilder(
        stream: inventoryDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasData) {
            final dataList = snapshot.data!.docs;
            List<InventoryDetails> inventoryList = dataList.map((doc) => InventoryDetails.fromSnapshot(doc)).toList();

            for (var data in inventoryList) {
              Future.delayed(const Duration(milliseconds: 500)).then((value) => {
                    setEditData(notify, data),
                  });
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
                                id: data.inventoryId!,
                                title: data.inventoryTitle!,
                                category: data.inventorycategory!,
                                type: data.inventoryType!,
                                propertyCategory: data.propertycategory!,
                                status: data.inventoryStatus!,
                                price: data.inventorycategory == "Rent"
                                    ? convertToCroresAndLakhs(data.propertyrent!.rentamount!)
                                    : convertToCroresAndLakhs(data.propertyprice!.price!),
                                inventoryDetails: data,
                              ),
                              if (Responsive.isMobile(context))
                                Padding(
                                  padding: const EdgeInsets.only(top: 15, bottom: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      HeaderChips(
                                          inventoryDetails: data,
                                          category: data.inventorycategory!,
                                          type: data.inventoryType!,
                                          propertyCategory: data.propertycategory!,
                                          status: data.inventoryStatus!,
                                          id: data.inventoryId!),
                                      SizedBox(
                                        width: 120,
                                        child: CustomText(
                                          size: 14,
                                          softWrap: true,
                                          textAlign: TextAlign.center,
                                          title: data.propertyprice?.price != null ? '${data.propertyprice!.price}${data.propertyprice!.unit}' : '50k/month',
                                          color: AppColor.primary,
                                        ),
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
                              //     title: '${data.propertyaddress!.city},${data.propertyaddress!.state}',
                              //     size: 12,
                              //     fontWeight: FontWeight.w400,
                              //     color: const Color(0xFFA8A8A8),
                              //   ),
                              // ),
                              if (Responsive.isMobile(context)) ...[
                                const SizedBox(height: 18),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        // CustomButton(
                                        //   text: 'Owner Details',
                                        //   onPressed: () {
                                        //     showOwnerDetailsAndAssignToBottomSheet(
                                        //       context,
                                        //       'Owner Details',
                                        //       ContactInformation(customerinfo: data.customerinfo!),
                                        //     );
                                        //   },
                                        //   height: 35,
                                        //   width: 135,
                                        // ),
                                        ElevatedButton(
                                          onPressed: () {
                                            showOwnerDetailsAndAssignToBottomSheet(
                                              context,
                                              'Owner Details',
                                              ContactInformation(customerinfo: data.customerinfo!),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColor.primary, // Set the button's background color
                                            // minimumSize: const Size(100, 20),
                                            padding: const EdgeInsets.all(8), // Set the button's size
                                          ),
                                          child: const Text(
                                            'Owner Details',
                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
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
                                                id: data.inventoryId!,
                                                assignto: data.assignedto!,
                                                imageUrlCreatedBy: data.createdby!.userimage == null || data.createdby!.userimage!.isEmpty ? noImg : data.createdby!.userimage!,
                                                createdBy: data.createdby!.userfirstname! + data.createdby!.userlastname!,
                                              ),
                                            );
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: data.assignedto!.asMap().entries.map((entry) {
                                              final index = entry.key;
                                              final user = entry.value;
                                              return Transform.translate(
                                                offset: Offset(index * -8.0, 0),
                                                child: Container(
                                                  width: 24,
                                                  height: 24,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.white),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        user.image!.isEmpty ? noImg : user.image!,
                                                      ),
                                                      fit: BoxFit.fill,
                                                    ),
                                                    borderRadius: BorderRadius.circular(40),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        )
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
                              ],
                              // if (Responsive.isMobile(context))
                              //   Padding(
                              //     padding: const EdgeInsets.only(top: 12.0),
                              //     child: CustomText(
                              //       title: data.propertyprice?.price != null ? '${data.propertyprice!.price}${data.propertyprice!.unit}' : '50k/month',
                              //       color: AppColor.primary,
                              //     ),
                              //   ),
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
                                ),
                              if (currentSelectedTab == 1) ActivityTabView(details: data),
                              if (currentSelectedTab == 2) TodoTabView(id: data.inventoryId!),
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
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              ContactInformation(
                                customerinfo: data.customerinfo!,
                              ),
                              if (Responsive.isDesktop(context))
                                AssignmentWidget(
                                  id: data.inventoryId!,
                                  assignto: data.assignedto!,
                                  imageUrlCreatedBy: data.createdby!.userimage == null || data.createdby!.userimage!.isEmpty ? noImg : data.createdby!.userimage!,
                                  createdBy: '${data.createdby!.userfirstname!} ${data.createdby!.userlastname!}',
                                  data: data,
                                ),
                              if (Responsive.isDesktop(context))
                                MapViewWidget(
                                  state: data.propertyaddress!.state!,
                                  city: data.propertyaddress!.city!,
                                  addressline1: data.propertyaddress!.addressline1!,
                                  addressline2: data.propertyaddress?.addressline2,
                                  locality: data.propertyaddress!.locality!,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }
          }
          return const SizedBox();
        },
      ),
    );
  }

  void setEditData(AllChipSelectedAnwers notify, InventoryDetails data) {
    try {
      return notify.addAllvalues([
        {"id": 1, "item": data.propertycategory},
        {"id": 2, "item": data.inventorycategory},
        {"id": 4, "item": data.inventorysource},
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
        {"id": 24, "item": data.propertyarea?.superarea},
        {"id": 25, "item": data.propertyarea?.carpetarea},
        {"id": 26, "item": data.propertyaddress?.state},
        {"id": 27, "item": data.propertyaddress?.city},
        {"id": 28, "item": data.propertyaddress?.addressline1},
        {"id": 29, "item": data.propertyaddress?.addressline2},
        {"id": 30, "item": data.propertyaddress?.floornumber},
        {"id": 31, "item": data.propertylocation},
        {"id": 32, "item": data.propertyfacing},
        {"id": 33, "item": data.propertyphotos},
        {"id": 34, "item": data.propertyvideo},
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
        {"id": 46, "item": data.propertyprice?.price},
        {"id": 47, "item": data.propertyprice?.unit},
        {"id": 48, "item": data.propertyrent?.rentamount},
        {"id": 49, "item": data.propertyrent?.rentunit},
        {"id": 50, "item": data.propertyrent?.securityamount},
        {"id": 51, "item": data.propertyrent?.securityunit},
        {"id": 52, "item": data.propertyrent?.lockinperiod},
        {"id": 53, "item": data.commercialphotos},
        {"id": 54, "item": data.propertyaddress?.locality},
        {"id": 55, "item": data.furnishedStatus},
        {"id": 100, "item": data.attachments},
        {"id": 101, "item": data.inventoryId},
      ]);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
