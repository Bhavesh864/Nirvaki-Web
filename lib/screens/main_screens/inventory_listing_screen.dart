import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/routes/routes.dart';
import 'package:yes_broker/widgets/top_search_bar.dart';
import 'package:yes_broker/widgets/workitems/workitem_filter_view.dart';
import '../../constants/firebase/detailsModels/card_details.dart';
import '../../pages/largescreen_dashboard.dart';
import '../../riverpodstate/selected_workitem.dart';
import '../../widgets/card/custom_card.dart';

class InventoryListingScreen extends ConsumerStatefulWidget {
  const InventoryListingScreen({super.key});

  @override
  InventoryListingScreenState createState() => InventoryListingScreenState();
}

class InventoryListingScreenState extends ConsumerState<InventoryListingScreen> {
  bool isFilterOpen = false;

  Future<List<CardDetails>>? future;

  @override
  void initState() {
    future = CardDetails.getCardDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (snapshot.hasData) {
          List<CardDetails> inventoryList = snapshot.data!.where((item) => item.cardType == "IN").toList();

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TopSerachBar(
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
                              Navigator.of(context).push(AppRoutes.createAnimatedRoute(const WorkItemFilterView()));
                            } else {
                              setState(() {
                                isFilterOpen = true;
                              });
                            }
                          }),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Container(
                              // constraints: BoxConstraints(
                              //   minHeight: height! * 0.7,
                              // ),
                              decoration: BoxDecoration(
                                color: AppColor.secondary,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                              margin: Responsive.isMobile(context) ? null : const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: Responsive.isMobile(context)
                                        ? 1
                                        : Responsive.isTablet(context) || isFilterOpen
                                            ? 2
                                            : 3,
                                    // mainAxisSpacing: 5.0, // Spacing between rows
                                    crossAxisSpacing: 10.0,
                                    mainAxisExtent: 160 // Spacing between columns
                                    ),
                                itemCount: inventoryList.length,
                                itemBuilder: (context, index) => GestureDetector(
                                  onTap: () {
                                    final id = inventoryList[index].workitemId;
                                    if (id!.contains('IN')) {
                                      if (Responsive.isMobile(context)) {
                                        Navigator.of(context).pushNamed(AppRoutes.inventoryDetailsScreen, arguments: id);
                                        ref.read(selectedWorkItemId.notifier).addItemId(id);
                                      } else {
                                        ref.read(selectedWorkItemId.notifier).addItemId(id);
                                        ref.read(largeScreenTabsProvider.notifier).update((state) => 7);
                                        context.beamToNamed('/inventory/inventory-details/$id');
                                      }
                                    } else if (id.contains('LD')) {
                                      if (Responsive.isMobile(context)) {
                                        Navigator.of(context).pushNamed(AppRoutes.leadDetailsScreen, arguments: id);
                                        ref.read(selectedWorkItemId.notifier).addItemId(id);
                                      } else {
                                        ref.read(selectedWorkItemId.notifier).addItemId(id);
                                        ref.read(largeScreenTabsProvider.notifier).update((state) => 8);
                                        context.beamToNamed('/lead/lead-details');
                                      }
                                    }
                                  },
                                  child: CustomCard(index: index, cardDetails: inventoryList),
                                ),
                              ),
                            ),
                          ),
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
                        child: WorkItemFilterView(closeFilterView: () {
                          setState(() {
                            isFilterOpen = false;
                          });
                        }),
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


 // decoration: const BoxDecoration(
            //   boxShadow: [
            //     BoxShadow(
            //       color: AppColor.secondary,
            //       spreadRadius: 12,
            //       blurRadius: 4,
            //       offset: Offset(5, 5),
            //     ),
            //   ],
            //   color: Colors.white,
            // ),
            //   child: Row(
            //     children: [
            //       Expanded(
            //         flex: 5,
            //         child: Column(
            //           children: [
            //             TopSerachBar(
            //                 title: 'Inventory',
            //                 isMobile: Responsive.isMobile(context),
            //                 isFilterOpen: isFilterOpen,
            //                 onFilterClose: () {
            //                   setState(() {
            //                     isFilterOpen = false;
            //                   });
            //                 },
            //                 onFilterOpen: () {
            //                   if (Responsive.isMobile(context)) {
            //                     Navigator.of(context).push(AppRoutes.createAnimatedRoute(const WorkItemFilterView()));
            //                   } else {
            //                     setState(() {
            //                       isFilterOpen = true;
            //                     });
            //                   }
            //                 }),
            //             Expanded(
            //               child: Row(
            //                 children: [
            //                   Expanded(
            //                     child: WorkItemsList(
            //                       title: 'Inventory',
            //                       getCardDetails: inventoryList,
            //                       headerShow: false,
            //                     ),
            //                   ),
            //                   !Responsive.isMobile(context)
            //                       ? const Expanded(
            //                           child: TodoListView(
            //                             headerShow: false,
            //                           ),
            //                         )
            //                       : Container(),
            //                   if (size.width > 1200)
            //                     if (!Responsive.isMobile(context) && !isFilterOpen)
            //                       const Expanded(
            //                         child: TodoListView(headerShow: false),
            //                       ),
            //                 ],
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //       Responsive.isDesktop(context) && isFilterOpen
            //           ? Expanded(
            //               flex: 2,
            //               child: Row(
            //                 children: [
            //                   Container(
            //                     margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            //                     width: 1,
            //                     color: Colors.grey.withOpacity(0.5),
            //                   ),
            //                   Expanded(
            //                     child: WorkItemFilterView(closeFilterView: () {
            //                       setState(() {
            //                         isFilterOpen = false;
            //                       });
            //                     }),
            //                   ),
            //                 ],
            //               ),
            //             )
            //           : Container(),
            //     ],
            //   ), 
