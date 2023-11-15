import 'dart:async';
import 'dart:ui';
import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/customs/loader.dart';
import 'package:yes_broker/widgets/calendar_view.dart';
import 'package:yes_broker/widgets/timeline_view.dart';
import 'package:yes_broker/widgets/workitems/empty_work_item_list.dart';
import 'package:yes_broker/widgets/workitems/workitems_list.dart';
import '../../Customs/responsive.dart';
import '../../Customs/text_utility.dart';
import '../../chat/controller/chat_controller.dart';
import '../../constants/app_constant.dart';
import '../../constants/firebase/Hive/hive_methods.dart';
import '../../constants/firebase/userModel/user_info.dart';
import '../../constants/functions/filterdataAccordingRole/data_according_role.dart';
import '../../constants/methods/string_methods.dart';
import '../../riverpodstate/chat/message_selection_state.dart';
import '../../riverpodstate/user_data.dart';
import '../../widgets/app/speed_dial_button.dart';
import '../../widgets/chat_modal_view.dart';
import '../account_screens/common_screen.dart';
import 'chat_screens/chat_list_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  DocumentSnapshot? lastDocument;
  List<CardDetails> carddetailsssss = [];
  bool isMoreData = true;
  late Stream<QuerySnapshot<Map<String, dynamic>>> cardDetails;
  final scrollercontroller = ScrollController();
  bool isUserLoaded = false;
  List<User> userList = [];
  int currentPage = 1; // Add this variable for tracking the current page
  int pageSize = 20;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Beamer.of(context).currentBeamLocation.state.routeInformation.location != '/profile') {
        ref.read(selectedProfileItemProvider.notifier).setSelectedItem(null);
      }
    });
    final token = UserHiveMethods.getdata("token");
    if (token != null) {
      getUserData(token);
      AppConst.setAccessToken(token);
    }
    if (kIsWeb) {
      ref.read(chatControllerProvider).setUserState(true);
    }
    // paginateData();

    // scrollercontroller.addListener(() {
    //   if (scrollercontroller.position.pixels == scrollercontroller.position.maxScrollExtent) {
    //     paginateData();
    //   }
    // });
    setCardDetails();
  }

  bool loading = false;
  late Stream<QuerySnapshot<Map<String, dynamic>>> querySnapshot;
  // void paginateData() async {
  //   if (isMoreData) {
  //     setState(() {
  //       loading = true;
  //     });
  //     if (lastDocument == null) {
  //       querySnapshot = FirebaseFirestore.instance.collection('cardDetails').limit(15).snapshots();
  //     } else {
  //       querySnapshot = FirebaseFirestore.instance.collection('cardDetails').limit(15).startAfterDocument(lastDocument!).snapshots();
  //     }
  //     await querySnapshot.forEach((element) {
  //       lastDocument = element.docs.last;
  //     });

  //     carddetailsssss.addAll(document.docs.map((e) => CardDetails.fromSnapshot(e)).toList());
  //     // lastDocument = querySnapshot.last;
  //     // carddetailsssss.addAll(querySnapshot.docs.map((e) => CardDetails.fromSnapshot(e)).toList());
  //     // loading = false;
  //     // print("carddetailsssss.length  ${carddetailsssss.length}");
  //     // setState(() {});
  //     // if (querySnapshot.docs.length < 15) {
  //     //   isMoreData = false;
  //     // } else {
  //     //   print("no more data");
  //     // }
  //   }
  //   if (scrollercontroller.position.pixels == scrollercontroller.position.maxScrollExtent) {
  //     print("call");
  //   } else {
  //     print("dontcall");
  //   }
  //   // setCardDetails();
  // }

  // void paginateData() async {
  //   if (isMoreData && !loading) {
  //     setState(() {
  //       loading = true;
  //     });

  //     Query query;

  //     if (lastDocument == null) {
  //       query = FirebaseFirestore.instance.collection('cardDetails').limit(15);
  //     } else {
  //       query = FirebaseFirestore.instance.collection('cardDetails').limit(15).startAfterDocument(lastDocument!);
  //     }

  //     try {
  //       QuerySnapshot querySnapshot = await query.get();
  //       if (querySnapshot.docs.isNotEmpty) {
  //         lastDocument = querySnapshot.docs.last;
  //         carddetailsssss.addAll(querySnapshot.docs.map((e) => CardDetails.fromSnapshot(e)).toList());
  //       } else {
  //         isMoreData = false; // No more data to load
  //       }
  //     } catch (e) {
  //       print("Error loading data: $e");
  //     } finally {
  //       setState(() {
  //         loading = false;
  //       });
  //     }
  //   }
  // }

  void setCardDetails() async {
    final brokerid = UserHiveMethods.getdata("brokerId");
    if (brokerid != null) {
      cardDetails = FirebaseFirestore.instance
          .collection('cardDetails')
          .where("brokerid", isEqualTo: brokerid)
          // .where("Status", isNotEqualTo: "Closed")
          .snapshots(includeMetadataChanges: true);
    } else {
      cardDetails = FirebaseFirestore.instance
          .collection('cardDetails')
          // .where("brokerid", isEqualTo: brokerid)
          .orderBy("createdate", descending: true)
          .snapshots(includeMetadataChanges: true);
    }
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

  showChatDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
          child: const ChatDialogBox(),
        );
      },
    );
  }

  getDetails(User currentuser) async {
    final List<User> user = await User.getUserAllRelatedToBrokerId(currentuser);
    if (userList.isEmpty) {
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder(
        stream: cardDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          if (snapshot.hasData) {
            // final source = (snapshot.data!.metadata.isFromCache) ? "local cache" : "server";
            // print("Data fetched from $source}");
            if (user == null) return const Loader();
            if (!isUserLoaded) {
              getDetails(user);
              isUserLoaded = true;
            }
            final filterItem = filterCardsAccordingToRole(snapshot: snapshot, ref: ref, userList: userList, currentUser: user);
            final List<CardDetails> todoItems =
                filterItem!.map((doc) => CardDetails.fromSnapshot(doc)).where((item) => item.cardType != "IN" && item.cardType != "LD").toList();
            int compareDueDates(CardDetails a, CardDetails b) {
              DateTime aDueDate = DateFormat('dd-MM-yy').parse(a.duedate!);
              DateTime bDueDate = DateFormat('dd-MM-yy').parse(b.duedate!);
              return aDueDate.compareTo(bDueDate);
            }

            todoItems.sort(compareDueDates);
            final List<CardDetails> workItems =
                filterItem.map((doc) => CardDetails.fromSnapshot(doc)).where((item) => item.cardType == "IN" || item.cardType == "LD").toList();
            workItems.sort((a, b) => b.createdate!.compareTo(a.createdate!));
            bool isDataEmpty = workItems.isEmpty && todoItems.isEmpty;
            return Container(
              margin: const EdgeInsets.only(top: 10, left: 8),
              child: Row(
                children: [
                  if (isDataEmpty) ...[
                    Expanded(
                      flex: size.width > 1340 ? 5 : 6,
                      child: const EmptyWorkItemList(),
                    ),
                  ] else ...[
                    size.width > 1200
                        ? Expanded(
                            flex: size.width > 1340 ? 3 : 5,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: WorkItemsList(
                                title: "To do",
                                getCardDetails: todoItems.where((item) => item.status != 'Closed').toList(),
                                scrollercontroller: scrollercontroller,
                              ),
                            ),
                          )
                        : Container(),
                    if (!Responsive.isMobile(context))
                      Expanded(
                        flex: size.width > 1340 ? 3 : 5,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: WorkItemsList(
                            title: "Work Items",
                            getCardDetails: workItems,
                            scrollercontroller: scrollercontroller,
                          ),
                        ),
                      )
                  ],
                  // size.width >= 850
                  //     ?
                  Expanded(
                    flex: size.width > 1340 ? 4 : 6,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (Responsive.isMobile(context))
                            Container(
                                margin: const EdgeInsets.only(left: 10, bottom: 6),
                                color: Colors.white,
                                child: AppText(
                                  letterspacing: 0.4,
                                  text: "Welcome, ${capitalizeFirstLetter(user.userfirstname)}",
                                  fontWeight: FontWeight.w600,
                                  fontsize: 16,
                                )),
                          Expanded(
                            flex: Responsive.isMobile(context) ? 0 : 3,
                            child: const CustomCalendarView(),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(
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
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 10),
                                      child: CustomTimeLineView(
                                        itemIds: filterItem.map((card) => card["workitemId"]).toList(),
                                        fromHome: true,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // : const SizedBox.shrink(),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: !AppConst.getPublicView()
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CustomSpeedDialButton(),
                const SizedBox(
                  height: 10,
                ),
                StreamBuilder(
                  stream: mergeChatContactsAndGroups(ref),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final chatItems = snapshot.data!;

                      final unseenChatItems = chatItems.where((chatItem) {
                        final isSender = chatItem.lastMessageSenderId == AppConst.getAccessToken();
                        return !isSender && !chatItem.lastMessageIsSeen;
                      }).toList();

                      final badgeCount = unseenChatItems.length;

                      return Stack(
                        alignment: Alignment.topRight,
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: AppColor.primary,
                            child: IconButton(
                              icon: const Icon(
                                Icons.chat_outlined,
                                color: Colors.white,
                                size: 24,
                              ),
                              onPressed: () {
                                showChatDialog();
                              },
                            ),
                          ),
                          if (badgeCount > 0)
                            Positioned(
                              top: -5,
                              left: 0,
                              child: Container(
                                padding: const EdgeInsets.all(7),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: Text(
                                  badgeCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    } else {
                      return CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColor.primary,
                        child: IconButton(
                          icon: const Icon(
                            Icons.chat_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () {
                            showChatDialog();
                            ref.read(selectedMessageProvider.notifier).setToEmpty();
                          },
                        ),
                      );
                    }
                  },
                ),
              ],
            )
          : null,
    );
  }
}
