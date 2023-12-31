import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/firebase/detailsModels/activity_details.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/customs/responsive.dart';

import '../constants/firebase/userModel/user_info.dart';
import '../constants/functions/navigation/navigation_functions.dart';
import '../constants/functions/time_formatter.dart';
import '../constants/methods/string_methods.dart';
import '../riverpodstate/common_index_state.dart';

class TimeLineItem extends ConsumerStatefulWidget {
  final int index;
  final List<ActivityDetails> activitiesList;
  final bool fromHome;
  final List<User> allUsersList;
  const TimeLineItem({
    super.key,
    required this.index,
    required this.activitiesList,
    required this.fromHome,
    required this.allUsersList,
  });

  @override
  ConsumerState<TimeLineItem> createState() => _TimeLineItemState();
}

class _TimeLineItemState extends ConsumerState<TimeLineItem> {
  User getNamesMatchWithid(id) {
    final User userArr = widget.allUsersList.firstWhere((element) => id == element.userId);
    return userArr;
  }

  @override
  Widget build(BuildContext context) {
    final scrWidth = MediaQuery.of(context).size.width;
    var timeLine = widget.activitiesList[widget.index];
    // final messageData = snapshot.data![index];
    // final isSender = messageData.senderId == AppConst.getAccessToken();

    // final bool isFirstMessageOfNewDay =
    //     !isSameDay(
    //       messageData.timeSent.toDate(),
    //       snapshot.data![index - 1].timeSent.toDate(),
    //     );

    final bool isNewWeek = DateTime.now().difference(timeLine.createdate!.toDate()).inDays >= 7;
    // final String formattedTime = getMessageDay(timeLine.createdate!.toDate(), isNewWeek);

    final formattedTime = TimeFormatter.formatFirestoreTimestamp(timeLine.createdate, isNewWeek);

    // final createdbyUser = getUserNameById(timeLine.createdby!.userid!, assigned.isNotEmpty ?  assigned :[]);

    double detailsViewWidth() {
      if (Responsive.isDesktop(context)) {
        if (widget.fromHome) {
          return 250.0;
        }
        return scrWidth / 2;
      } else if (Responsive.isMobile(context)) {
        if (scrWidth < 400) {
          return 170;
        }
        if (scrWidth > 600) {
          return 260;
        }
        return 210;
      } else {
        if (widget.fromHome == false && scrWidth < 1100 && scrWidth > 900) {
          return scrWidth / 2.6;
        }
        if (widget.fromHome == false && scrWidth < 900 && scrWidth > 750) {
          return scrWidth / 2.8;
        }
        return 250.0;
      }
    }

    return Container(
      padding: const EdgeInsets.only(top: 20, left: 5),
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
                  if (widget.fromHome) {
                    ref.read(detailsPageIndexTabProvider.notifier).state = 1;
                    navigateBasedOnId(context, timeLine.itemid!, ref);
                  }
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
                  width: detailsViewWidth(),
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
                border: Border.all(color: Colors.grey, width: 1.0),
                image: DecorationImage(
                    image: NetworkImage(widget.allUsersList.isNotEmpty
                        ? getNamesMatchWithid(timeLine.createdby?.userid).image.isEmpty
                            ? noImg
                            : getNamesMatchWithid(timeLine.createdby?.userid).image
                        : noImg),
                    fit: BoxFit.fill),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            title: CustomText(
              title: capitalizeFirstLetter(widget.allUsersList.isNotEmpty ? getNamesMatchWithid(timeLine.createdby?.userid).userfirstname : ""),
              size: 12,
            ),
          )
        ],
      ),
    );
  }
}
