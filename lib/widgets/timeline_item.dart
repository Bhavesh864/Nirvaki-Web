import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';

import 'package:yes_broker/constants/firebase/detailsModels/activity_details.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/Customs/custom_chip.dart';

import '../constants/utils/image_constants.dart';

class TimeLineItem extends StatelessWidget {
  final int index;
  final List<ActivityDetails> activitiesList;
  const TimeLineItem({super.key, required this.index, required this.activitiesList});

  @override
  Widget build(BuildContext context) {
    var timeLine = activitiesList[index];
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
                CustomChip(
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
              CustomText(
                title: timeLine.activitybody!.activitytitle!,
                size: 12,
              )
            ],
          ),
          ListTile(
            horizontalTitleGap: 6,
            titleAlignment: ListTileTitleAlignment.center,
            leading: Container(
              // height: 20,
              width: 20,
              decoration: BoxDecoration(
                image: const DecorationImage(image: AssetImage(profileImage)),
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            title: CustomText(
              title: timeLine.createdby!.userfirstname!,
              size: 12,
            ),
          ),
        ],
      ),
    );
  }
}
