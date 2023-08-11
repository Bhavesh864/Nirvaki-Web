import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/widgets/todo/todo_filter_view.dart';
import '../../pages/largescreen_dashboard.dart';
import '../../riverpodstate/selected_workitem.dart';
import '../../routes/routes.dart';
import '../../widgets/calendar_view.dart';
import '../../widgets/card/custom_card.dart';
import '../../widgets/top_search_bar.dart';
import '../../widgets/workitems/workitem_filter_view.dart';
import '../../widgets/workitems/workitems_list.dart';

class TodoListingScreen extends ConsumerStatefulWidget {
  const TodoListingScreen({super.key});

  @override
  TodoListingScreenState createState() => TodoListingScreenState();
}

class TodoListingScreenState extends ConsumerState<TodoListingScreen> {
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
            return const SizedBox(
              // height: height! * 0.7,
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          }
          if (snapshot.hasData) {
            List<CardDetails> todoItemsList = snapshot.data!.where((item) => item.cardType != "IN" && item.cardType != "LD").toList();

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TopSerachBar(
                          title: 'Todo',
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
                          },
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Column(
                                children: [
                                  if (Responsive.isMobile(context)) ...[
                                    SingleChildScrollView(
                                      // physics: const NeverScrollableScrollPhysics(),
                                      child: Column(
                                        children: [
                                          const CustomCalendarView(),
                                          Container(
                                            constraints: const BoxConstraints(),
                                            child: WorkItemsList(
                                              isScrollable: false,
                                              title: 'To do',
                                              getCardDetails: todoItemsList,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ] else ...[
                                    Container(
                                      // constraints: BoxConstraints(
                                      //   minHeight: height! * 0.75,
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
                                            mainAxisExtent: Responsive.isMobile(context) ? 197 : 170 // Spacing between columns
                                            ),
                                        itemCount: todoItemsList.length,
                                        itemBuilder: (context, index) => GestureDetector(
                                          onTap: () {
                                            final id = todoItemsList[index].workitemId;
                                            if (id!.contains('IN')) {
                                              if (Responsive.isMobile(context)) {
                                                Navigator.of(context).pushNamed(AppRoutes.inventoryDetailsScreen, arguments: id);
                                              } else {
                                                ref.read(selectedWorkItemId.notifier).addItemId(id);
                                                ref.read(largeScreenTabsProvider.notifier).update((state) => 7);
                                              }
                                            } else if (id.contains('LD')) {
                                              if (Responsive.isMobile(context)) {
                                                Navigator.of(context).pushNamed(AppRoutes.leadDetailsScreen, arguments: id);
                                              } else {
                                                ref.read(selectedWorkItemId.notifier).addItemId(id);
                                                ref.read(largeScreenTabsProvider.notifier).update((state) => 8);
                                              }
                                            }
                                          },
                                          child: CustomCard(index: index, cardDetails: todoItemsList),
                                        ),
                                      ),
                                    ),
                                  ]
                                ],
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
                          child: TodoFilterView(closeFilterView: () {
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
        });
  }
}



// return Container(
//               decoration: const BoxDecoration(
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppColor.secondary,
//                     spreadRadius: 12,
//                     blurRadius: 4,
//                     offset: Offset(5, 5),
//                   ),
//                 ],
//                 color: Colors.white,
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     flex: 5,
//                     child: Column(
//                       children: [
//                         TopSerachBar(
//                             title: 'Todo',
//                             isMobile: Responsive.isMobile(context),
//                             isFilterOpen: isFilterOpen,
//                             onFilterClose: () {
//                               setState(() {
//                                 isFilterOpen = false;
//                               });
//                             },
//                             onFilterOpen: () {
//                               setState(() {
//                                 isFilterOpen = true;
//                               });
//                             }),
//                         Expanded(
//                           // height: height! * 0.74,
//                           child: Row(
//                             children: [
//                               !Responsive.isMobile(context)
//                                   ? Expanded(
//                                       child: WorkItemsList(
//                                         title: 'To do',
//                                         headerShow: false,
//                                         getCardDetails: todoItems,
//                                       ),
//                                     )
//                                   : Expanded(
//                                       child: SingleChildScrollView(
//                                         // physics: const NeverScrollableScrollPhysics(),
//                                         child: Column(
//                                           children: [
//                                             const CustomCalendarView(),
//                                             Container(
//                                               constraints: const BoxConstraints(),
//                                               child: WorkItemsList(
//                                                 isScrollable: false,
//                                                 title: 'To do',
//                                                 getCardDetails: todoItems,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                               !Responsive.isMobile(context)
//                                   ? const Expanded(
//                                       child: TodoListView(
//                                         headerShow: false,
//                                       ),
//                                     )
//                                   : Container(),
//                               if (size.width > 1200)
//                                 if (!Responsive.isMobile(context) && !isFilterOpen)
//                                   const Expanded(
//                                     child: TodoListView(
//                                       headerShow: false,
//                                     ),
//                                   )
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Responsive.isDesktop(context) && isFilterOpen
//                       ? Expanded(
//                           flex: 2,
//                           child: Row(
//                             children: [
//                               Container(
//                                 margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
//                                 width: 1,
//                                 color: Colors.grey.withOpacity(0.5),
//                               ),
//                               Expanded(
//                                 child: TodoFilterView(
//                                   closeFilterView: () {
//                                     setState(() {
//                                       isFilterOpen = false;
//                                     });
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                       : Container(),
//                 ],
//               ),
//             );