import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/functions/navigation/navigation_functions.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/riverpodstate/user_data.dart';
import 'package:yes_broker/widgets/todo/todo_filter_view.dart';
import '../../Customs/loader.dart';
import '../../chat/controller/chat_controller.dart';
import '../../constants/app_constant.dart';
import '../../constants/firebase/Hive/hive_methods.dart';
import '../../constants/firebase/userModel/user_info.dart';
import '../../constants/functions/filterdataAccordingRole/data_according_role.dart';
import '../../constants/utils/constants.dart';
import '../../routes/routes.dart';
import '../../widgets/card/custom_card.dart';
import '../../widgets/table_view/table_view_widgets.dart';
import '../../widgets/top_search_bar.dart';

class MobileTodoScreen extends ConsumerStatefulWidget {
  const MobileTodoScreen({super.key});

  @override
  MobileTodoScreenState createState() => MobileTodoScreenState();
}

class MobileTodoScreenState extends ConsumerState<MobileTodoScreen> {
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
    setCardDetails();
    if (!kIsWeb) {
      ref.read(chatControllerProvider).setUserState(true);
    }
  }

  getUserData(token) async {
    final User? user = await User.getUser(token);
    if (user != null) {
      ref.read(userDataProvider.notifier).storeUserData(user);
      AppConst.setRole(user.role);
      UserHiveMethods.addData(key: "brokerId", data: user.brokerId);
    }
  }

  void setCardDetails() {
    final brokerid = UserHiveMethods.getdata("brokerId");
    cardDetails = FirebaseFirestore.instance.collection('cardDetails').where("cardType", whereNotIn: ["IN", "LD"])
        // .orderBy("createdate", descending: true)
        .snapshots(includeMetadataChanges: true);
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
              final List<CardDetails> todoItemsList = filterItem!.map((doc) => CardDetails.fromSnapshot(doc)).toList();

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
                                setState(() {
                                  // searchController.text = value;
                                });
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
                                  Navigator.of(context).push(
                                    AppRoutes.createAnimatedRoute(
                                      TodoFilterView(
                                        closeFilterView: () {
                                          Navigator.of(context).pop();
                                        },
                                        onApplyFilters: (list) {
                                          selectedFilters = list;
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  );
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
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
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
                                  ]),
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
