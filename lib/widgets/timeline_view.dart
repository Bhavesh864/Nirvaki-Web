// ignore_for_file: invalid_use_of_protected_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'package:yes_broker/Customs/custom_chip.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/constants/firebase/detailsModels/activity_details.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/riverpodstate/selected_workitem.dart';
import 'package:yes_broker/widgets/timeline_item.dart';

class CustomTimeLineView extends ConsumerWidget {
  final bool fromHome;
  final bool isScrollable;
  const CustomTimeLineView({
    super.key,
    this.isScrollable = true,
    this.fromHome = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workitemId = ref.read(selectedWorkItemId.notifier).state;

    print(workitemId);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
      // margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
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
                paddingHorizontal: 0,
                avatar: Icon(Icons.calendar_view_week_outlined),
                label: CustomText(
                  title: 'This Week',
                  size: 10,
                ),
              ),
              CustomChip(
                label: Row(
                  children: [
                    CustomText(
                      title: 'This Week',
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
            stream: fromHome
                ? FirebaseFirestore.instance
                    .collection('activityDetails')
                    .snapshots()
                : FirebaseFirestore.instance
                    .collection('activityDetails')
                    .where('itemid', isEqualTo: workitemId)
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }
              if (snapshot.hasData) {
                final dataList = snapshot.data!.docs;
                List<ActivityDetails> activities = dataList
                    .map((e) => ActivityDetails.fromSnapshot(e))
                    .toList();
                activities
                    .sort((a, b) => b.createdate!.compareTo(a.createdate!));
                return ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: Expanded(
                    child: ListView.builder(
                      // physics: isScrollable ? const ScrollPhysics() : const NeverScrollableScrollPhysics(),
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
              }
              return Container(
                decoration: BoxDecoration(color: Colors.amber),
                child: Text("data"),
              );
            },
          ),
        ],
      ),
    );
  }
}
