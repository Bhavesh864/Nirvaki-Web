import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/constants/firebase/detailsModels/activity_details.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/Customs/custom_chip.dart';

import '../constants/functions/navigation/navigation_functions.dart';
import '../constants/functions/time_formatter.dart';

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
    var timeLine = widget.activitiesList[widget.index];
    final formattedTime = TimeFormatter.formatFirestoreTimestamp(timeLine.createdate);
    return Container(
      padding: const EdgeInsets.only(top: 0, left: 5),
      height: 100,
      width: 100,
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
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
            children: [
              if (!timeLine.itemid!.contains('TD'))
                InkWell(
                  onTap: () {
                    navigateBasedOnId(context, timeLine.itemid!, ref);
                  },
                  child: CustomChip(
                    label: CustomText(
                      title: timeLine.itemid!,
                      size: 12,
                    ),
                    color: timeLine.itemid!.contains('LD') ? AppColor.leadChipColor : AppColor.inventoryChipColor,
                    avatar: Icon(
                      timeLine.itemid!.contains('LD') ? MaterialSymbols.location_home_outlined : MaterialSymbols.location_away,
                      color: timeLine.itemid!.contains('LD') ? AppColor.leadIconColor : AppColor.inventoryIconColor,
                    ),
                  ),
                ),
              CustomText(
                title: capitalizeFirstLetter(timeLine.activitybody!.activitytitle!),
                size: 14,
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
                image: DecorationImage(image: NetworkImage(timeLine.userImageUrl!), fit: BoxFit.fill),
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
