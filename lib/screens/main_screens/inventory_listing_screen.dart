// ignore_for_file: invalid_use_of_protected_member
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/constants/functions/filterdataAccordingRole/data_according_role.dart';
import 'package:yes_broker/constants/functions/navigation/navigation_functions.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/routes/routes.dart';
import 'package:yes_broker/widgets/top_search_bar.dart';
import 'package:yes_broker/widgets/workitems/workitem_filter_view.dart';
import '../../Customs/loader.dart';
import '../../constants/firebase/Hive/hive_methods.dart';
import '../../constants/firebase/detailsModels/card_details.dart';
import '../../constants/firebase/userModel/user_info.dart';
import '../../constants/utils/constants.dart';
import '../../riverpodstate/common_index_state.dart';
import '../../riverpodstate/user_data.dart';
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
  List<User> userList = [];
  bool isUserLoaded = false;

  @override
  void initState() {
    super.initState();
    setCardDetails();
  }

  void setCardDetails() {
    final brokerid = UserHiveMethods.getdata("brokerId");
    cardDetails = FirebaseFirestore.instance.collection('cardDetails').where("brokerid", isEqualTo: brokerid).snapshots(includeMetadataChanges: true);
  }

  getDetails(User currentuser) async {
    final List<User> userList = await User.getUserAllRelatedToBrokerId(currentuser);
    if (usersids.isEmpty) {
      if (mounted) {
        setState(() {
          usersids = userList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userDataProvider);
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColor.secondary,
            spreadRadius: 12,
            blurRadius: 4,
            offset: Offset(5, 5),
          ),
        ],
        color: Colors.white,
      ),
      child: StreamBuilder(
        stream: cardDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          if (snapshot.hasData) {
            if (user == null) return const Loader();
            if (!isUserLoaded) {
              getDetails(user);
              isUserLoaded = true;
            }
            final filterItem = filterCardsAccordingToRole(snapshot: snapshot, ref: ref, userList: userList, currentUser: user);
            final List<CardDetails> inventoryList = filterItem!.map((doc) => CardDetails.fromSnapshot(doc)).where((item) => item.cardType == "IN").toList();
            inventoryList.sort((a, b) => b.createdate!.compareTo(a.createdate!));
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
            if (selectedFilters.isNotEmpty) {
              filteredInventoryList = filteredInventoryList.where((item) {
                if (!item.cardTitle!.contains('Plot') && item.cardTitle!.contains("Residential")) {
                  final bool isBedRoomMatch = selectedFilters.isEmpty || selectedFilters.contains('${item.roomconfig!.bedroom!}BHK');
                  final bool has5BHKFilter = selectedFilters.contains('5BHK +');
                  final int numberOfBedrooms = int.parse(item.roomconfig!.bedroom!);

                  if (has5BHKFilter) {
                    return numberOfBedrooms >= 5; // Show items with 5 or more bedrooms
                  }
                  return isBedRoomMatch;
                } else {
                  return false;
                }
                // final double itemRateStart = double.parse(item.propertypricerange!.arearangestart!);

                // final bool isRateInRange = itemRateStart >= rateRange.start;
                // print('${item.roomconfig!.bedroom}BHK');
              }).toList();
            }

            status = filteredInventoryList;

            final tableRowList = filteredInventoryList.map(
              (e) {
                return buildWorkItemRowTile(
                  e,
                  filteredInventoryList.indexOf(e),
                  status,
                  id: e.workitemId,
                  ref: ref,
                  context: context,
                );
              },
            );

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
                          isFilterOpen: isFilterOpen,
                          onFilterClose: () {
                            setState(() {
                              isFilterOpen = false;
                            });
                          },
                          onFilterOpen: () {
                            if (Responsive.isMobile(context)) {
                              Navigator.of(context).push(AppRoutes.createAnimatedRoute(WorkItemFilterView(
                                closeFilterView: () {
                                  Navigator.of(context).pop();
                                },
                                setFilters: (p0, selectedRange) {
                                  setState(() {
                                    selectedFilters = p0;
                                    // rateRange = selectedRange;
                                  });
                                },
                                originalCardList: inventoryList,
                              )));
                            } else {
                              setState(() {
                                isFilterOpen = true;
                              });
                            }
                          },
                        ),
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
                                                2: FixedColumnWidth(availableWidth * 0.10),
                                                3: FixedColumnWidth(availableWidth * 0.20),
                                                4: FixedColumnWidth(availableWidth * 0.15),
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
                                  margin: Responsive.isMobile(context)
                                      ? const EdgeInsets.symmetric(horizontal: 0, vertical: 5)
                                      : const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                                                ref.read(detailsPageIndexTabProvider.notifier).update(
                                                      (state) => 0,
                                                    );
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
                                // rateRange = selectedRange;
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
      ),
    );
  }
}
