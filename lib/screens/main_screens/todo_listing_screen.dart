import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/functions/navigation/navigation_functions.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/riverpodstate/user_data.dart';
import 'package:yes_broker/widgets/todo/todo_filter_view.dart';
import '../../Customs/custom_text.dart';
import '../../Customs/loader.dart';
import '../../chat/controller/chat_controller.dart';
import '../../constants/app_constant.dart';
import '../../constants/firebase/Hive/hive_methods.dart';
import '../../constants/firebase/userModel/user_info.dart';
import '../../constants/functions/filterdataAccordingRole/data_according_role.dart';
import '../../constants/methods/string_methods.dart';
import '../../constants/utils/constants.dart';
import '../../routes/routes.dart';
import '../../widgets/calendar_view.dart';
import '../../widgets/card/custom_card.dart';
import '../../widgets/table_view/table_view_widgets.dart';
import '../../widgets/timeline_view.dart';
import '../../widgets/top_search_bar.dart';
import '../../widgets/workitems/workitem_filter_view.dart';

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
    super.initState();
    final token = UserHiveMethods.getdata("token");
    if (token != null) {
      AppConst.setAccessToken(token);
      getUserData(token);
    }
    ref.read(chatControllerProvider).setUserState(true);
    setCardDetails();
  }

  getUserData(token) async {
    if (mounted) {
      final User? user = await User.getUser(token);
      if (user != null) {
        ref.read(userDataProvider.notifier).storeUserData(user);
        AppConst.setRole(user.role);
        UserHiveMethods.addData(key: "brokerId", data: user.brokerId);
        final List<User> userList = await User.getAllUsers(user);
        UserListPreferences.saveUserList(userList);
      }
    }
  }

  void setCardDetails() {
    final brokerid = UserHiveMethods.getdata("brokerId");
    if (brokerid != null) {
      cardDetails = FirebaseFirestore.instance.collection('cardDetails').where("brokerid", isEqualTo: brokerid).snapshots(includeMetadataChanges: true);
    } else {
      cardDetails = FirebaseFirestore.instance.collection('cardDetails').orderBy("createdate", descending: true).snapshots(includeMetadataChanges: true);
    }
  }

  void getDetails(User currentuser) async {
    if (mounted) {
      final List<User> user = await User.getUserAllRelatedToBrokerId(currentuser);
      if (mounted) {
        setState(() {
          userList = user;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userDataProvider);
    final size = MediaQuery.of(context).size;
    final showClosed = ref.watch(showClosedTodoItemsProvider);
    return Container(
      color: Colors.white,
      child: StreamBuilder(
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
              final filterItem = filterCardsAccordingToRole(snapshot: snapshot, ref: ref, userList: userList, currentUser: user);
              final List<CardDetails> todoItemsList =
                  filterItem!.map((doc) => CardDetails.fromSnapshot(doc)).where((item) => item.cardType != "IN" && item.cardType != "LD").toList();

              int compareDueDates(CardDetails a, CardDetails b) {
                DateTime aDueDate = DateFormat('dd-MM-yy').parse(a.duedate!);
                DateTime bDueDate = DateFormat('dd-MM-yy').parse(b.duedate!);
                return aDueDate.compareTo(bDueDate);
              }

              todoItemsList.sort(compareDueDates);

              List<CardDetails> filterTodoList = todoItemsList.where((item) {
                if (searchController.text.isEmpty) {
                  return true;
                } else {
                  final searchText = searchController.text.toLowerCase();
                  final fullName = "${item.customerinfo?.firstname} ${item.customerinfo?.lastname}".toLowerCase();
                  final title = item.cardTitle!.toLowerCase();
                  final mobileNumber = '${item.customerinfo?.mobile?.toLowerCase()}';
                  return fullName.contains(searchText) || title.contains(searchText) || mobileNumber.contains(searchText);
                  // return title.contains(searchText);
                }
              }).toList();

              filterTodoList = filterTodoList.where((item) {
                final bool isStatusMatch = selectedFilters.isEmpty || selectedFilters.contains(item.status!.toLowerCase());
                final bool isLinkItemTypeMatch = selectedFilters.isEmpty || selectedFilters.contains(item.linkedItemType == 'IN' ? 'inventory' : 'lead');
                final bool isTodoTypeMatch = selectedFilters.isEmpty || selectedFilters.contains(item.cardType!.toLowerCase());

                return isStatusMatch || isLinkItemTypeMatch || isTodoTypeMatch;
              }).toList();

              status = filterTodoList;

              if (!showClosed) {
                filterTodoList = filterTodoList.where((item) => item.status != 'Closed').toList();
              } else {
                filterTodoList.sort((a, b) {
                  if (a.status == 'Closed' && b.status != 'Closed') {
                    return 1; // 'Closed' items go to the end
                  } else if (a.status != 'Closed' && b.status == 'Closed') {
                    return -1; // 'Closed' items go to the end
                  } else if (a.status == 'Inventory' && b.status == 'Lead') {
                    return -1; // 'Inventory' goes before 'Lead'
                  } else if (a.status == 'Lead' && b.status == 'Inventory') {
                    return 1; // 'Inventory' goes before 'Lead'
                  }
                  return 0; // Maintain the existing order for other items
                });
              }

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
                            if (width! > 850)
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
                                      if (Responsive.isMobile(context) || width! < 850) ...[
                                        Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 6),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  margin: const EdgeInsets.only(left: 10, bottom: 6),
                                                  color: Colors.white,
                                                  child: AppText(
                                                    letterspacing: 0.4,
                                                    text: "Welcome, ${capitalizeFirstLetter(user.userfirstname)}",
                                                    fontWeight: FontWeight.w600,
                                                    fontsize: 16,
                                                  )),
                                              const CustomCalendarView(),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              // WorkItemsList(
                                              //   title: 'To do',
                                              //   getCardDetails: filterTodoList,
                                              // ),
                                              // ======================= Dashboard timeline ======================
                                              Container(
                                                padding: const EdgeInsets.only(bottom: 8),
                                                decoration: BoxDecoration(
                                                  color: AppColor.secondary,
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.only(left: 15, top: 15, bottom: 15),
                                                      child: CustomText(
                                                        title: 'Timeline',
                                                        fontWeight: FontWeight.w600,
                                                        size: 15,
                                                      ),
                                                    ),
                                                    Container(
                                                      height: size.height * 0.5,
                                                      // width: 300,
                                                      color: Colors.white,
                                                      margin: const EdgeInsets.symmetric(horizontal: 10),
                                                      child: CustomTimeLineView(
                                                        itemIds: filterItem.map((card) => card["workitemId"]).toList(),
                                                        fromHome: true,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ] else ...[
                                        if (showTableView) ...[
                                          filterTodoList.isNotEmpty
                                              ? Container(
                                                  margin: const EdgeInsets.symmetric(horizontal: 30),
                                                  child: LayoutBuilder(builder: (context, constraints) {
                                                    final availableWidth = constraints.maxWidth;
                                                    return Table(
                                                      columnWidths: {
                                                        0: FixedColumnWidth(availableWidth * 0.25),
                                                        1: FixedColumnWidth(availableWidth * 0.10),
                                                        2: FixedColumnWidth(availableWidth * 0.15),
                                                        3: FixedColumnWidth(availableWidth * 0.15),
                                                        4: FixedColumnWidth(availableWidth * 0.20),
                                                        5: FixedColumnWidth(availableWidth * 0.1),
                                                      },
                                                      border: const TableBorder(
                                                        bottom: BorderSide(color: Color(0xFFCED4DA), width: 1.5),
                                                        horizontalInside: BorderSide(color: Color(0xFFCED4DA), width: 1.5),
                                                      ),
                                                      children: [
                                                        buildTableHeader(isTodo: true),
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
                                                      mainAxisExtent: 165,
                                                    ),
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
                          const VerticalDivider(
                            indent: 20,
                            width: 20,
                            endIndent: 20,
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
          }),
    );
  }
}

// String getGreeting() {
//   final now = DateTime.now();
//   final currentTime = now.hour;

//   String greeting;

//   if (currentTime >= 5 && currentTime < 12) {
//     greeting = 'Good morning';
//   } else if (currentTime >= 12 && currentTime < 17) {
//     greeting = 'Good afternoon';
//   } else {
//     greeting = 'Good evening';
//   }

//   return greeting;
// }
