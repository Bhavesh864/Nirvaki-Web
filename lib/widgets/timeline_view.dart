// ignore_for_file: invalid_use_of_protected_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'package:yes_broker/Customs/custom_chip.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/Customs/loader.dart';
import 'package:yes_broker/constants/firebase/detailsModels/activity_details.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/riverpodstate/selected_workitem.dart';
import 'package:yes_broker/widgets/timeline_item.dart';

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

  @override
  void initState() {
    super.initState();
    setactivity();
  }

  void setactivity() {
    final workitemId = ref.read(selectedWorkItemId);
    activityDetails = widget.fromHome
        ? FirebaseFirestore.instance.collection('activityDetails').snapshots()
        : FirebaseFirestore.instance.collection('activityDetails').where('itemid', isEqualTo: workitemId).snapshots();
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
              Padding(
                padding: EdgeInsets.only(left: Responsive.isDesktop(context) ? 10.0 : 0),
                child: const CustomChip(
                  paddingVertical: 3,
                  paddingHorizontal: 0,
                  avatar: Icon(
                    Icons.calendar_view_week_outlined,
                    weight: 1000,
                    size: 18,
                  ),
                  label: CustomText(
                    title: 'This Week',
                    size: 10,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: Responsive.isDesktop(context) ? 5.0 : 0),
                child: const CustomChip(
                  paddingVertical: 3,
                  label: Row(
                    children: [
                      CustomText(
                        title: 'Filter By',
                        size: 10,
                      ),
                      Icon(
                        Icons.arrow_downward_outlined,
                        weight: 1000,
                        size: 18,
                      ),
                    ],
                  ),
                ),
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
                activities.sort((a, b) => b.createdate!.compareTo(a.createdate!));
                if (activities.isNotEmpty) {
                  if (widget.fromHome) {
                    return Expanded(
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
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
                        behavior: const ScrollBehavior().copyWith(overscroll: false),
                        child: ListView.builder(
                          shrinkWrap: true,
                          // physics: const NeverScrollableScrollPhysics(),
                          itemCount: activities.length,
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
