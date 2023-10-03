import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/customs/loader.dart';

import 'package:yes_broker/widgets/calendar_view.dart';
import 'package:yes_broker/widgets/timeline_view.dart';
import 'package:yes_broker/widgets/workitems/empty_work_item_list.dart';
import 'package:yes_broker/widgets/workitems/workitems_list.dart';

import '../../constants/app_constant.dart';
import '../../constants/firebase/userModel/user_info.dart';
import '../../constants/functions/filterdataAccordingRole/data_according_role.dart';
import '../../riverpodstate/user_data.dart';
import '../../widgets/app/speed_dial_button.dart';
import '../../widgets/chat_modal_view.dart';
import 'chat_list_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> cardDetails;
  bool isUserLoaded = false;
  List<User> userList = [];

  @override
  void initState() {
    super.initState();
    getUserData();
    setCardDetails();
  }

  void setCardDetails() {
    cardDetails = FirebaseFirestore.instance.collection('cardDetails').orderBy("createdate", descending: true).snapshots();
  }

  getUserData() async {
    final User? user = await User.getUser(AppConst.getAccessToken());
    ref.read(userDataProvider.notifier).storeUserData(user!);
    AppConst.setRole(user.role);
  }

  showChatDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return const ChatDialogBox();
      },
    );
  }

  getDetails(User currentuser) async {
    final List<User> user = await User.getUserAllRelatedToBrokerId(currentuser);
    if (userList.isEmpty) {
      userList = user;
      setState(() {});
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
            if (user == null) return const Loader();
            if (!isUserLoaded) {
              getDetails(user);
              isUserLoaded = true;
            }
            final filterItem = filterCardsAccordingToRole(snapshot: snapshot, ref: ref, userList: userList, currentUser: user);

            final List<CardDetails> todoItems = filterItem!
                .map((doc) => CardDetails.fromSnapshot(doc))
                .where((item) => item.cardType != "IN" && item.cardType != "LD" && item.status != "Closed")
                .toList();

            todoItems.sort((a, b) {
              final DateTime dueDateA = DateTime.parse("20${a.duedate!.replaceAll('-', '')}");
              final DateTime dueDateB = DateTime.parse("20${b.duedate!.replaceAll('-', '')}");
              return dueDateB.compareTo(dueDateA);
            });

            final List<CardDetails> workItems =
                filterItem.map((doc) => CardDetails.fromSnapshot(doc)).where((item) => item.cardType == "IN" || item.cardType == "LD").toList();
            bool isDataEmpty = workItems.isEmpty && todoItems.isEmpty;
            return Row(
              children: [
                if (isDataEmpty) ...[
                  Expanded(
                    flex: size.width > 1340 ? 5 : 6,
                    child: const EmptyWorkItemList(),
                  ),
                ] else ...[
                  Expanded(
                    flex: size.width > 1340 ? 3 : 5,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: WorkItemsList(
                        title: "To do",
                        getCardDetails: todoItems,
                      ),
                    ),
                  ),
                  size.width > 1200
                      ? Expanded(
                          flex: size.width > 1340 ? 3 : 5,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: WorkItemsList(
                              title: "Work Items",
                              getCardDetails: workItems,
                            ),
                          ),
                        )
                      : Container(),
                ],
                size.width >= 850
                    ? Expanded(
                        flex: size.width > 1340 ? 4 : 6,
                        child: Column(
                          children: [
                            const Expanded(
                              flex: 2,
                              child: CustomCalendarView(),
                            ),
                            Expanded(
                              flex: 4,
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: AppColor.secondary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                                      child: CustomText(
                                        title: 'Timeline',
                                        fontWeight: FontWeight.w600,
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
                      )
                    : const SizedBox.shrink(),
              ],
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



// List<LeadQuestions> screensList = [
//   LeadQuestions(
//     type: "Commercial",
//     screens: [
//       Screen(
//         questions: [
//           Question(
//             questionId: 1,
//             questionOptionType: "chip",
//             questionTitle: "Which Property Category does this Lead Fall under ?",
//             questionOption: ["Residential", "Commercial"],
//           ),
//         ],
//         isActive: true,
//         previousScreenId: "",
//         screenId: "S1",
//         nextScreenId: "S2",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 2,
//             questionOptionType: "chip",
//             questionTitle: "What Category does this Lead belong to?",
//             questionOption: ["Rent", "Buy"],
//           ),
//         ],
//         isActive: true,
//         previousScreenId: "S1",
//         screenId: "S2",
//         nextScreenId: "S3",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 4,
//             questionOptionType: "chip",
//             questionTitle: "From where did you source this inventory?",
//             questionOption: ["99Acers", "Magic Bricks", "Makaan", "Housing.com", "Social Media", "Data Calling", "Broker", "Other"],
//           ),
//         ],
//         isActive: true,
//         previousScreenId: "S2",
//         screenId: "S3",
//         nextScreenId: "S4",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 5,
//             questionOptionType: "textfield",
//             questionTitle: "First Name",
//             questionOption: "",
//           ),
//           Question(
//             questionId: 6,
//             questionOptionType: "textfield",
//             questionTitle: "Last Name",
//             questionOption: "",
//           ),
//           Question(
//             questionId: 7,
//             questionOptionType: "textfield",
//             questionTitle: "Mobile",
//             questionOption: "",
//           ),
//           Question(
//             questionId: 8,
//             questionOptionType: "textfield",
//             questionTitle: "Whatsapp Number",
//             questionOption: "",
//           ),
//           Question(
//             questionId: 9,
//             questionOptionType: "textfield",
//             questionTitle: "Email",
//             questionOption: "",
//           ),
//           Question(
//             questionId: 10,
//             questionOptionType: "textfield",
//             questionTitle: "Company Name",
//             questionOption: "",
//           ),
//         ],
//         title: "Customer Details",
//         isActive: true,
//         previousScreenId: "S3",
//         screenId: "S4",
//         nextScreenId: "S5",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 11,
//             questionOptionType: "chip",
//             questionTitle: "Type of Commercial Property?",
//             questionOption: [
//               "Land",
//               "Constructed Property",
//               "Under Construction",
//             ],
//           ),
//         ],
//         isActive: true,
//         previousScreenId: "S4",
//         screenId: "S5",
//         nextScreenId: "S6",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 38,
//             questionOptionType: "chip",
//             questionTitle: "Type of Land?",
//             questionOption: [
//               "Shop Cum Office",
//               "Mall",
//               "Shopping Complex",
//               "Office",
//               "School",
//               "Warehouse",
//             ],
//           ),
//         ],
//         isActive: true,
//         previousScreenId: "S5",
//         screenId: "S6",
//         nextScreenId: "S7",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 38,
//             questionOptionType: "chip",
//             questionTitle: "Which Type of Property you want to list?",
//             questionOption: [
//               "Office",
//               "Retail",
//               "Industrial",
//               "Hospitality",
//               "Healthcare",
//               "Institutional",
//               "School",
//               "Warehouse",
//             ],
//           ),
//         ],
//         isActive: true,
//         previousScreenId: "S6",
//         screenId: "S7",
//         nextScreenId: "S8",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 39,
//             questionOptionType: "chip",
//             questionTitle: "Type of Office?",
//             questionOption: [
//               "Furnished",
//               "Baresell",
//               "Co-working",
//             ],
//           ),
//         ],
//         isActive: true,
//         previousScreenId: "S7",
//         screenId: "S8",
//         nextScreenId: "S9",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 40,
//             questionOptionType: "chip",
//             questionTitle: "Type of Retail?",
//             questionOption: ["Shop", "Showroom", "SCO"],
//           ),
//         ],
//         isActive: true,
//         previousScreenId: "S8",
//         screenId: "S9",
//         nextScreenId: "S10",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 41,
//             questionOptionType: "chip",
//             questionTitle: "Type of Hospitality?",
//             questionOption: [
//               "Hotel",
//               "Resort",
//               "Guest House",
//             ],
//           ),
//         ],
//         isActive: true,
//         previousScreenId: "S9",
//         screenId: "S10",
//         nextScreenId: "S11",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 42,
//             questionOptionType: "chip",
//             questionTitle: "Type of HealthCare?",
//             questionOption: [
//               "Hospital",
//               "Clinic",
//             ],
//           ),
//         ],
//         isActive: true,
//         previousScreenId: "S10",
//         screenId: "S11",
//         nextScreenId: "S12",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 43,
//             questionOptionType: "dropdown",
//             questionTitle: "Number of beds approved?",
//             questionOption: [
//               "10-50",
//               "51-100",
//               "101-150",
//               "151-200",
//             ],
//           ),
//         ],
//         isActive: true,
//         title: "Number of beds approved?",
//         previousScreenId: "S11",
//         screenId: "S12",
//         nextScreenId: "S13",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 44,
//             questionOptionType: "chip",
//             questionTitle: "Type of School Approved?",
//             questionOption: ["Play School", "Primary School", "High School", "Secondary School"],
//           ),
//         ],
//         isActive: true,
//         previousScreenId: "S12",
//         screenId: "S13",
//         nextScreenId: "S14",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 45,
//             questionOptionType: "textfield",
//             questionTitle: "Number of Rooms Constructed?",
//             questionOption: "",
//           ),
//         ],
//         title: "Number of Rooms Constructed?",
//         isActive: true,
//         previousScreenId: "S13",
//         screenId: "S14",
//         nextScreenId: "S15",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 13,
//             questionOptionType: "chip",
//             questionTitle: "What Is the transaction type?",
//             questionOption: ["Retail", "New Booking"],
//           ),
//         ],
//         isActive: true,
//         previousScreenId: "S14",
//         screenId: "S15",
//         nextScreenId: "S16",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 18,
//             questionOptionType: "dropdown",
//             questionTitle: "Is there a boundary wall around the plot?",
//             questionOption: ["Yes", "No"],
//           ),
//           Question(
//             questionId: 19,
//             questionOptionType: "smallchip",
//             questionTitle: "No of open Sides?",
//             questionOption: ["1", "2", "3", "4"],
//           ),
//         ],
//         isActive: true,
//         previousScreenId: "S15",
//         screenId: "S16",
//         nextScreenId: "S17",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 20,
//             questionOptionType: "chip",
//             questionTitle: "Expected time possession ?",
//             questionOption: ["Within 3 months", "Within 6 months", "Within 1 Year", "Within 2 Year", "Within 3 Year"],
//           ),
//         ],
//         isActive: true,
//         previousScreenId: "S16",
//         screenId: "S17",
//         nextScreenId: "S18",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 23,
//             questionOptionType: "smallchip",
//             questionTitle: "Property Area",
//             questionOption: ["Sq ft", "Sq yard", "Acre"],
//           ),
//           Question(
//             questionId: 24,
//             questionOptionType: "textfield",
//             questionTitle: "Property Area",
//             questionOption: "",
//           ),
//         ],
//         isActive: true,
//         previousScreenId: "S17",
//         screenId: "S18",
//         nextScreenId: "S19",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 32,
//             questionOptionType: "textfield",
//             questionTitle: "Budget range",
//             questionOption: "",
//           ),
//         ],
//         isActive: true,
//         title: "What is the customers budget range?",
//         previousScreenId: "S18",
//         screenId: "S19",
//         nextScreenId: "S120",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 26,
//             questionOptionType: "dropdown",
//             questionTitle: "State",
//             questionOption: ["Rajasthan"],
//           ),
//           Question(
//             questionId: 27,
//             questionOptionType: "dropdown",
//             questionTitle: "City",
//             questionOption: ["Bikaner"],
//           ),
//           Question(
//             questionId: 54,
//             questionOptionType: "dropdown",
//             questionTitle: "Locality",
//             questionOption: ["Pawan-puri", "vallabh garden"],
//           ),
//           Question(
//             questionId: 28,
//             questionOptionType: "textfield",
//             questionTitle: "Address Line 1",
//             questionOption: "",
//           ),
//           Question(
//             questionId: 29,
//             questionOptionType: "textfield",
//             questionTitle: "Address Line 2",
//             questionOption: "",
//           ),
//           Question(
//             questionId: 30,
//             questionOptionType: "dropdown",
//             questionTitle: "Preferred Floor",
//             questionOption: ["Lower floor", "Middle floor", "Higher floor", "No preference"],
//           ),
//         ],
//         title: "Property Address",
//         isActive: true,
//         previousScreenId: "S19",
//         screenId: "S20",
//         nextScreenId: "S21",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 31,
//             questionOptionType: "map",
//             questionTitle: "Pin Property on Map",
//             questionOption: "",
//           ),
//         ],
//         isActive: true,
//         previousScreenId: "S20",
//         screenId: "S21",
//         nextScreenId: "S22",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 34,
//             questionOptionType: "chip",
//             questionTitle: "Preferred Property Direction",
//             questionOption: ["East", "West", "North", "South", "North East", "North West", "South East", "South West"],
//           ),
//         ],
//         isActive: true,
//         previousScreenId: "S21",
//         screenId: "S22",
//         nextScreenId: "S23",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 46,
//             questionOptionType: "textfield",
//             questionTitle: "Width Of Road",
//             questionOption: "",
//           ),
//           Question(
//             questionId: 38,
//             questionOptionType: "smallchip",
//             questionTitle: "",
//             questionOption: ["Mtr", "Ft"],
//           ),
//         ],
//         isActive: true,
//         title: "Width of road in front?",
//         previousScreenId: "S22",
//         screenId: "S23",
//         nextScreenId: "S24",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 35,
//             questionOptionType: "textarea",
//             questionTitle: "Add Note Or comment",
//             questionOption: "Add Note Or comment",
//           ),
//         ],
//         isActive: true,
//         previousScreenId: "S23",
//         screenId: "S24",
//         nextScreenId: "S25",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 36,
//             questionOptionType: "Assign",
//             questionTitle: "Assign to",
//             questionOption: "",
//           ),
//         ],
//         isActive: true,
//         title: "Assign to",
//         previousScreenId: "S24",
//         screenId: "S25",
//         nextScreenId: "",
//       ),
//     ],
//   ),
// ];
