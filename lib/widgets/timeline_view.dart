// ignore_for_file: invalid_use_of_protected_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'package:yes_broker/Customs/custom_chip.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/Customs/loader.dart';
import 'package:yes_broker/constants/firebase/detailsModels/activity_details.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/riverpodstate/selected_workitem.dart';
import 'package:yes_broker/widgets/app/dropdown_menu.dart';
import 'package:yes_broker/widgets/timeline_item.dart';

import '../Customs/responsive.dart';
import '../constants/firebase/Hive/hive_methods.dart';
import '../constants/firebase/userModel/user_info.dart';

class CustomTimeLineView extends ConsumerStatefulWidget {
  final bool fromHome;
  final bool isScrollable;
  final List<dynamic>? itemIds;

  const CustomTimeLineView({
    this.itemIds = const [],
    super.key,
    this.isScrollable = true,
    this.fromHome = false,
  });

  @override
  CustomTimeLineViewState createState() => CustomTimeLineViewState();
}

class CustomTimeLineViewState extends ConsumerState<CustomTimeLineView> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> activityDetails;
  String selectedDay = 'All Time';
  String seleteduserName = "";
  String selectedUserid = "";
  List<User> allUsersList = [];

  void getdataFromLocalStorage() async {
    List<User> retrievedUsers = await UserListPreferences.getUserList();
    if (mounted) {
      setState(() {
        allUsersList = retrievedUsers;
      });
    }
  }

  User getNamesMatchWithid(id) {
    final User userArr = allUsersList.firstWhere((element) => id == element.userId);
    return userArr;
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1)).then((value) => {getdataFromLocalStorage()});
    super.initState();
    setactivity();
  }

  void setactivity() {
    final workitemId = ref.read(selectedWorkItemId);
    activityDetails = widget.fromHome
        ? FirebaseFirestore.instance.collection('activityDetails').snapshots(includeMetadataChanges: true)
        : FirebaseFirestore.instance.collection('activityDetails').where('itemid', isEqualTo: workitemId).snapshots(includeMetadataChanges: true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: !widget.fromHome
          ? null
          : BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomDropDown(
                initialValue: selectedDay,
                onSelected: (value) {
                  setState(() {
                    print(value);
                    selectedDay = value;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(left: Responsive.isDesktop(context) ? 10.0 : 0),
                  child: CustomChip(
                    paddingVertical: 3,
                    paddingHorizontal: 0,
                    avatar: Row(
                      children: [
                        if (selectedDay.isNotEmpty && selectedDay != 'All Time')
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.only(right: 4),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColor.primary,
                            ),
                          ),
                        const Icon(
                          Icons.calendar_view_week_outlined,
                          weight: 1000,
                          size: 18,
                        ),
                      ],
                    ),
                    label: CustomText(
                      title: selectedDay,
                      size: 10,
                    ),
                  ),
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'All Time',
                    height: 30,
                    child: CustomText(
                      title: 'All Time',
                      size: 12,
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'This Week',
                    height: 30,
                    child: CustomText(
                      title: 'This Week',
                      size: 12,
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'This Day',
                    height: 30,
                    child: CustomText(
                      title: 'This Day',
                      size: 12,
                    ),
                  ),
                ],
              ),
              CustomDropDown(
                initialValue: seleteduserName,

                onSelected: (value) {
                  if (value == 'All') {
                    setState(() {
                      selectedUserid = '';
                    });
                  } else {
                    setState(() {
                      selectedUserid = value;
                      seleteduserName = getNamesMatchWithid(selectedUserid).userfirstname;
                    });
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(right: Responsive.isDesktop(context) ? 5.0 : 0),
                  child: CustomChip(
                    paddingVertical: 3,
                    label: Row(
                      children: [
                        Row(
                          children: [
                            if (selectedUserid.isNotEmpty)
                              Container(
                                width: 6,
                                height: 6,
                                margin: const EdgeInsets.only(right: 4),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColor.primary,
                                ),
                              ),
                            const CustomText(
                              title: 'Filter By',
                              size: 10,
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.arrow_downward_outlined,
                          weight: 1000,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                itemBuilder: (BuildContext context) {
                  List<PopupMenuEntry<String>> menuItems = [
                    const PopupMenuItem<String>(
                      value: 'All',
                      height: 30,
                      child: CustomText(
                        title: 'All',
                        size: 12,
                      ),
                    ),
                    const PopupMenuDivider(),
                  ];

                  menuItems.addAll(allUsersList.map((e) {
                    return PopupMenuItem<String>(
                      value: e.userId.toString(),
                      height: 30,
                      child: CustomText(
                        title: e.userfirstname.toString(),
                        size: 12,
                      ),
                    );
                  }));

                  return menuItems;
                },
                // itemBuilder: (context) => allUsersList
                //     .map(
                //       (e) => popupMenuItemKamStyling(
                //         e.userfirstname.toString(),
                //         e.userId.toString(),
                //       ),
                //     )
                //     .toList(),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder(
            stream: activityDetails,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              }
              if (snapshot.hasData) {
                final datalist = snapshot.data?.docs;
                List<ActivityDetails> activities = datalist!.map((e) => ActivityDetails.fromSnapshot(e)).toList();
                if (widget.fromHome) {
                  activities = activities.where((activity) => widget.itemIds!.contains(activity.itemid)).toList();
                }
                if (selectedUserid.isNotEmpty) {
                  activities = activities.where((element) => selectedUserid == element.userid).toList();
                }
                if (selectedDay.isNotEmpty) {
                  DateTime today = DateTime.now();

                  if (selectedDay == 'This Week') {
                    activities = activities.where((element) {
                      return DateTime.now().difference(element.createdate!.toDate()).inDays < 7;
                    }).toList();
                  } else if (selectedDay == 'This Day') {
                    activities = activities.where((element) {
                      DateTime activityDate = element.createdate!.toDate(); // Assuming the date is in string format
                      return activityDate.year == today.year && activityDate.month == today.month && activityDate.day == today.day;
                    }).toList();
                  }
                }

                activities.sort((a, b) => b.createdate!.compareTo(a.createdate!));
                if (activities.isNotEmpty) {
                  if (widget.fromHome) {
                    return Expanded(
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                        }),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: activities.length,
                          // physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return TimelineTile(
                              isFirst: index == 0 ? true : false,
                              indicatorStyle: const IndicatorStyle(
                                color: AppColor.primary,
                                height: 8,
                                width: 8,
                                padding: EdgeInsets.only(
                                  left: 15,
                                ),
                              ),
                              beforeLineStyle: const LineStyle(
                                color: AppColor.primary,
                                thickness: 2,
                              ),
                              alignment: TimelineAlign.start,
                              endChild: TimeLineItem(
                                index: index,
                                activitiesList: activities,
                                fromHome: widget.fromHome,
                                allUsersList: allUsersList,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  } else {
                    return SizedBox(
                      height: 300,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                        }),
                        child: ListView.builder(
                          shrinkWrap: true,
                          // physics: const NeverScrollableScrollPhysics(),
                          itemCount: activities.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: !Responsive.isDesktop(context) && activities.length - 1 == index ? const EdgeInsets.only(bottom: 20) : const EdgeInsets.all(0),
                              child: TimelineTile(
                                isFirst: index == 0 ? true : false,
                                indicatorStyle: const IndicatorStyle(
                                  color: AppColor.primary,
                                  height: 8,
                                  width: 8,
                                  padding: EdgeInsets.only(
                                    left: 15,
                                  ),
                                ),
                                beforeLineStyle: const LineStyle(
                                  color: AppColor.primary,
                                  thickness: 2,
                                ),
                                alignment: TimelineAlign.start,
                                endChild: TimeLineItem(
                                  index: index,
                                  activitiesList: activities,
                                  fromHome: widget.fromHome,
                                  allUsersList: allUsersList,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }
                } else {
                  return const Padding(
                    padding: EdgeInsets.only(top: 40.0),
                    child: Center(
                      child: CustomText(title: 'No Activities to show!'),
                    ),
                  );
                }
              }
              return Container(
                decoration: const BoxDecoration(color: Colors.amber),
                child: const Text(
                  "data",
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
