// ignore_for_file: invalid_use_of_protected_member
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/constants/functions/filterdataAccordingRole/data_according_role.dart';
import 'package:yes_broker/constants/functions/navigation/navigation_functions.dart';
import 'package:yes_broker/constants/user_role.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/riverpodstate/user_data.dart';
import 'package:yes_broker/routes/routes.dart';
import 'package:yes_broker/widgets/top_search_bar.dart';
import 'package:yes_broker/widgets/workitems/workitem_filter_view.dart';
import '../../constants/app_constant.dart';
import '../../constants/firebase/detailsModels/card_details.dart';
import '../../constants/firebase/userModel/user_info.dart';
import '../../constants/utils/constants.dart';
import '../../widgets/card/custom_card.dart';
import '../../widgets/table_view/table_view_widgets.dart';

class InventoryListingScreen extends ConsumerStatefulWidget {
  const InventoryListingScreen({super.key});

  @override
  InventoryListingScreenState createState() => InventoryListingScreenState();
}

class InventoryListingScreenState extends ConsumerState<InventoryListingScreen> {
  bool isFilterOpen = false;
  bool showTableView = false;
  List<User> usersids = [];

  List<String> selectedFilters = [];
  final TextEditingController searchController = TextEditingController();
  RangeValues rateRange = const RangeValues(0, 0);

  late Stream<QuerySnapshot<Map<String, dynamic>>> cardDetails;
  List<CardDetails>? status;

  @override
  void initState() {
    super.initState();
    setCardDetails();
  }

  void setCardDetails() {
    cardDetails = FirebaseFirestore.instance.collection('cardDetails').orderBy("createdate", descending: true).snapshots();
  }

  getDetails(User currentuser) async {
    final List<User> userList = await User.getUserAllRelatedToBrokerId(currentuser, currentuser.userId);
    if (usersids.isEmpty) {
      usersids = userList;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: cardDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (snapshot.hasData) {
          final filterItem = filterCardsAccordingToRole(snapshot: snapshot, ref: ref);
          final List<CardDetails> inventoryList = filterItem!.map((doc) => CardDetails.fromSnapshot(doc)).where((item) => item.cardType == "IN").toList();
          List<CardDetails> filteredInventoryList = inventoryList.where((item) {
            if (searchController.text.isEmpty) {
              return true;
            } else {
              final searchText = searchController.text.toLowerCase();
              final fullName = "${item.customerinfo!.firstname} ${item.customerinfo!.lastname}".toLowerCase();
              final title = item.cardTitle!.toLowerCase();
              final mobileNumber = item.customerinfo!.mobile!.toLowerCase();

              return fullName.contains(searchText) || title.contains(searchText) || mobileNumber.contains(searchText);
            }
          }).toList();

          filteredInventoryList = filteredInventoryList.where((item) {
            final bool isBedRoomMatch = selectedFilters.isEmpty || selectedFilters.contains('${item.roomconfig!.bedroom!}BHK');
            // final double itemRateStart = double.parse(item.propertypricerange!.arearangestart!);

            // final bool isRateInRange = itemRateStart >= rateRange.start;

            return isBedRoomMatch;
          }).toList();

          status = filteredInventoryList;

          final tableRowList = filteredInventoryList.map((e) {
            return buildWorkItemRowTile(
              e,
              filteredInventoryList.indexOf(e),
              status,
              id: e.workitemId,
              ref: ref,
              context: context,
            );
          });

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TopSerachBar(
                          onChanged: (value) {
                            setState(() {});
                          },
                          onToggleShowTable: () {
                            setState(() {
                              showTableView = !showTableView;
                            });
                          },
                          showTableView: showTableView,
                          searchController: searchController,
                          title: 'Inventory',
                          isMobile: Responsive.isMobile(context),
                          isFilterOpen: isFilterOpen,
                          onFilterClose: () {
                            setState(() {
                              isFilterOpen = false;
                            });
                          },
                          onFilterOpen: () {
                            if (Responsive.isMobile(context)) {
                              Navigator.of(context).push(AppRoutes.createAnimatedRoute(const WorkItemFilterView(
                                originalCardList: [],
                              )));
                            } else {
                              setState(() {
                                isFilterOpen = true;
                              });
                            }
                          }),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showTableView) ...[
                            filteredInventoryList.isNotEmpty
                                ? Expanded(
                                    flex: 5,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 20),
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          final availableWidth = constraints.maxWidth;
                                          return Table(
                                            columnWidths: {
                                              0: FixedColumnWidth(availableWidth * 0.25),
                                              1: FixedColumnWidth(availableWidth * 0.18),
                                              2: FixedColumnWidth(availableWidth * 0.15),
                                              3: FixedColumnWidth(availableWidth * 0.15),
                                              4: FixedColumnWidth(availableWidth * 0.1),
                                              5: FixedColumnWidth(availableWidth * 0.1),
                                            },
                                            border: TableBorder(
                                              bottom: BorderSide(color: Colors.grey.withOpacity(.5), width: 1.5),
                                              horizontalInside: BorderSide(color: Colors.grey.withOpacity(.5), width: 1.5),
                                            ),
                                            children: [
                                              buildTableHeader(),
                                              ...tableRowList,
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    height: 500,
                                    width: width! * 0.9,
                                    child: const Center(
                                      child: Text(
                                        "No results found.",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                          ] else ...[
                            Expanded(
                              flex: 5,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColor.secondary,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                margin: Responsive.isMobile(context) ? null : const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: filteredInventoryList.isNotEmpty
                                    ? GridView.builder(
                                        shrinkWrap: true,
                                        physics: const ScrollPhysics(),
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: Responsive.isMobile(context)
                                              ? 1
                                              : Responsive.isTablet(context) || isFilterOpen
                                                  ? 2
                                                  : 3,
                                          crossAxisSpacing: 10.0,
                                          mainAxisExtent: 165,
                                        ),
                                        itemCount: filteredInventoryList.length,
                                        itemBuilder: (context, index) {
                                          final id = filteredInventoryList[index].workitemId!;
                                          return GestureDetector(
                                            onTap: () {
                                              navigateBasedOnId(context, id, ref);
                                            },
                                            child: CustomCard(
                                              index: index,
                                              cardDetails: filteredInventoryList,
                                            ),
                                          );
                                        },
                                      )
                                    : const Center(
                                        child: Text(
                                          "No results found.",
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (Responsive.isDesktop(context) && isFilterOpen)
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        width: 1,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      Expanded(
                        child: WorkItemFilterView(
                          closeFilterView: () {
                            setState(() {
                              isFilterOpen = false;
                            });
                          },
                          setFilters: (p0, selectedRange) {
                            setState(() {
                              selectedFilters = p0;
                              rateRange = selectedRange;
                            });
                          },
                          originalCardList: inventoryList,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
