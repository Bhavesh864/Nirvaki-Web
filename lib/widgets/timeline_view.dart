// ignore_for_file: invalid_use_of_protected_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'package:yes_broker/Customs/custom_chip.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/Customs/loader.dart';
import 'package:yes_broker/constants/firebase/detailsModels/activity_details.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/riverpodstate/selected_workitem.dart';
import 'package:yes_broker/widgets/timeline_item.dart';
import '../riverpodstate/user_data.dart';

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
  @override
  Widget build(BuildContext context) {
    final workitemId = ref.watch(selectedWorkItemId);
    final User? user = ref.watch(userDataProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
      decoration: !widget.fromHome
          ? null
          : BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomChip(
                paddingVertical: 8,
                paddingHorizontal: 0,
                avatar: Icon(Icons.calendar_view_week_outlined),
                label: CustomText(
                  title: 'This Week',
                  size: 10,
                ),
              ),
              CustomChip(
                paddingVertical: 8,
                label: Row(
                  children: [
                    CustomText(
                      title: 'Filter By',
                      size: 10,
                    ),
                    Icon(Icons.arrow_downward_outlined),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder(
            stream: widget.fromHome
                ? FirebaseFirestore.instance.collection('activityDetails').where("brokerid", isEqualTo: user?.brokerId ?? "").snapshots()
                : FirebaseFirestore.instance.collection('activityDetails').where('itemid', isEqualTo: workitemId).snapshots(),
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
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  } else {
                    return ScrollConfiguration(
                      behavior: const ScrollBehavior().copyWith(overscroll: false),
                      child: ListView.builder(
                        shrinkWrap: true,
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
                            ),
                          );
                        },
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
                child: const Text("data"),
              );
            },
          ),
        ],
      ),
    );
  }
}
