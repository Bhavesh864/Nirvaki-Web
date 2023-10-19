import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/Customs/text_utility.dart';

import 'package:yes_broker/constants/firebase/detailsModels/activity_details.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/customs/responsive.dart';

import '../constants/functions/navigation/navigation_functions.dart';
import '../constants/functions/time_formatter.dart';
import '../riverpodstate/common_index_state.dart';

class TimeLineItem extends ConsumerStatefulWidget {
  final int index;
  final List<ActivityDetails> activitiesList;
  const TimeLineItem({super.key, required this.index, required this.activitiesList});

  @override
  ConsumerState<TimeLineItem> createState() => _TimeLineItemState();
}

class _TimeLineItemState extends ConsumerState<TimeLineItem> {
  @override
  Widget build(BuildContext context) {
    final scrWidth = MediaQuery.of(context).size.width;
    var timeLine = widget.activitiesList[widget.index];
    final formattedTime = TimeFormatter.formatFirestoreTimestamp(timeLine.createdate);

    return Container(
      padding: const EdgeInsets.only(top: 20, left: 5),
      // height: 100,
      width: 100,
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  ref.read(detailsPageIndexTabProvider.notifier).state = 1;
                  navigateBasedOnId(context, timeLine.itemid!, ref);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: timeLine.itemid!.contains('LD') ? AppColor.leadChipColor : AppColor.inventoryChipColor,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        timeLine.itemid!.contains('LD') ? MaterialSymbols.location_away : MaterialSymbols.location_home_outlined,
                        color: timeLine.itemid!.contains('LD') ? AppColor.leadIconColor : AppColor.inventoryIconColor,
                      ),
                      const SizedBox(width: 5),
                      CustomText(
                        title: timeLine.itemid!,
                        size: 12,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Container(
                  width: Responsive.isDesktop(context)
                      ? 250
                      : scrWidth < 400
                          ? 200
                          : 210,
                  padding: const EdgeInsets.only(bottom: 5, left: 5),
                  child: AppText(
                    text: capitalizeFirstLetter(timeLine.activitybody!.activitytitle!),
                    fontsize: 14,
                    softwrap: true,
                  ),
                ),
              )
            ],
          ),
          ListTile(
            horizontalTitleGap: 6,
            titleAlignment: ListTileTitleAlignment.center,
            trailing: CustomText(
              title: formattedTime,
              size: 12,
              color: AppColor.primary,
            ),
            leading: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(timeLine.userImageUrl == null || timeLine.userImageUrl!.isEmpty ? noImg : timeLine.userImageUrl!), fit: BoxFit.fill),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            title: CustomText(
              title: capitalizeFirstLetter(timeLine.createdby!.userfirstname!),
              size: 12,
            ),
          ),
        ],
      ),
    );
  }
}

String capitalizeFirstLetter(String text) {
  if (text.isEmpty) {
    return text;
  }
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}
