import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/functions/navigation/navigation_functions.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/riverpodstate/user_data.dart';
import 'package:yes_broker/widgets/todo/todo_filter_view.dart';
import '../../Customs/loader.dart';
import '../../constants/firebase/userModel/user_info.dart';
import '../../constants/functions/filterdataAccordingRole/data_according_role.dart';
import '../../constants/utils/constants.dart';
import '../../routes/routes.dart';
import '../../widgets/calendar_view.dart';
import '../../widgets/card/custom_card.dart';
import '../../widgets/table_view/table_view_widgets.dart';
import '../../widgets/top_search_bar.dart';
import '../../widgets/workitems/workitem_filter_view.dart';
import '../../widgets/workitems/workitems_list.dart';

class TodoListingScreen extends ConsumerStatefulWidget {
  const TodoListingScreen({super.key});

  @override
  TodoListingScreenState createState() => TodoListingScreenState();
}

class TodoListingScreenState extends ConsumerState<TodoListingScreen> {
  List<String> selectedFilters = [];
  final TextEditingController searchController = TextEditingController();
  bool isFilterOpen = false;
  bool showTableView = false;
  late Stream<QuerySnapshot<Map<String, dynamic>>> cardDetails;
  List<User> userList = [];
  List<CardDetails>? status;
  bool isUserLoaded = false;
  @override
  void initState() {
    setCardDetails();
    super.initState();
  }

  void setCardDetails() {
    cardDetails = FirebaseFirestore.instance.collection('cardDetails').orderBy("createdate", descending: true).snapshots();
  }

  void getDetails(User currentuser) async {
    final List<User> user = await User.getUserAllRelatedToBrokerId(currentuser);
    setState(() {
      userList = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userDataProvider);
    return StreamBuilder(
        stream: cardDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasData) {
            if (user == null) return const Loader();
            if (!isUserLoaded) {
              getDetails(user);
              isUserLoaded = true;
            }
            // final filterItem = filterCardsAccordingToRole(snapshot: snapshot, ref: ref, setState: setState);
            final filterItem = filterCardsAccordingToRole(snapshot: snapshot, ref: ref, userList: userList, currentUser: user);
            final List<CardDetails> todoItemsList =
                filterItem!.map((doc) => CardDetails.fromSnapshot(doc)).where((item) => item.cardType != "IN" && item.cardType != "LD").toList();
            List<CardDetails> filterTodoList = todoItemsList.where((item) {
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

            filterTodoList = filterTodoList.where((item) {
              final bool isStatusMatch = selectedFilters.isEmpty || selectedFilters.contains(item.status!.toLowerCase());
              final bool isLinkItemTypeMatch = selectedFilters.isEmpty || selectedFilters.contains(item.linkedItemType == 'IN' ? 'inventory' : 'lead');
              final bool isTodoTypeMatch = selectedFilters.isEmpty || selectedFilters.contains(item.cardType!.toLowerCase());

              return isStatusMatch || isLinkItemTypeMatch || isTodoTypeMatch;
            }).toList();

            status = filterTodoList;

            final tableRowList = filterTodoList.map((e) {
              return buildWorkItemRowTile(
                e,
                filterTodoList.indexOf(e),
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
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(overscroll: false),
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
                                Navigator.of(context).push(AppRoutes.createAnimatedRoute(const WorkItemFilterView(
                                  originalCardList: [],
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
                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    if (Responsive.isMobile(context)) ...[
                                      Column(
                                        children: [
                                          const CustomCalendarView(),
                                          WorkItemsList(
                                            title: 'To do',
                                            getCardDetails: filterTodoList,
                                          ),
                                        ],
                                      ),
                                    ] else ...[
                                      if (showTableView) ...[
                                        filterTodoList.isNotEmpty
                                            ? Container(
                                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                                child: LayoutBuilder(builder: (context, constraints) {
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
                                                }),
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
                                        Container(
                                          decoration: BoxDecoration(
                                            color: AppColor.secondary,
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                          margin: Responsive.isMobile(context) ? null : const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          child: filterTodoList.isNotEmpty
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
                                                      mainAxisExtent: 150),
                                                  itemCount: filterTodoList.length,
                                                  itemBuilder: (context, index) => GestureDetector(
                                                    onTap: () {
                                                      final id = filterTodoList[index].workitemId;
                                                      navigateBasedOnId(context, id!, ref);
                                                    },
                                                    child: CustomCard(index: index, cardDetails: filterTodoList),
                                                  ),
                                                )
                                              : const Center(
                                                  child: Text(
                                                    "No results found.",
                                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                        ),
                                      ]
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
                          child: TodoFilterView(
                            closeFilterView: () {
                              setState(() {
                                isFilterOpen = false;
                              });
                            },
                            onApplyFilters: (list) {
                              selectedFilters = list;
                              setState(() {});
                            },
                          ),
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
