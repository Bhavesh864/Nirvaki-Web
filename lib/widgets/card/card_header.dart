// gnore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/constants/firebase/Methods/add_activity.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/firebase/detailsModels/inventory_details.dart';
import 'package:yes_broker/constants/firebase/detailsModels/lead_details.dart';
import 'package:yes_broker/constants/firebase/detailsModels/todo_details.dart';
import 'package:yes_broker/constants/firebase/send_notification.dart';
import 'package:yes_broker/constants/functions/assingment_methods.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/riverpodstate/user_data.dart';
import 'package:yes_broker/widgets/app/dropdown_menu.dart';
import '../../Customs/text_utility.dart';
import '../../constants/app_constant.dart';
import '../../constants/firebase/userModel/user_info.dart';
import '../../constants/utils/constants.dart';
import '../app/nav_bar.dart';
import '../../Customs/custom_chip.dart';

// ignore: must_be_immutable
class CardHeader extends ConsumerStatefulWidget {
  final int index;
  List<CardDetails> cardDetails;

  CardHeader({
    Key? key,
    required this.index,
    required this.cardDetails,
  }) : super(key: key);

  @override
  CardHeaderState createState() => CardHeaderState();
}

class CardHeaderState extends ConsumerState<CardHeader> {
  // String? status;
  List<CardDetails>? status = [];

  @override
  Widget build(BuildContext context) {
    final cardData = widget.cardDetails[widget.index];
    status = widget.cardDetails;
    final User? user = ref.read(userDataProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: Responsive.isMobile(context) ? 27 : 25,
          width: cardData.workitemId!.contains('TD') ? 180 : 250,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
            }),
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                // Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(6),
                //     color: checkChipColorByCategory(cardData),
                //   ),
                //   child: Icon(
                //     checkIconByCategory(cardData),
                //     color: checkIconColorByCategory(cardData),
                //     size: 16,
                //     // weight: 10.12,
                //   ),
                // ),
                if (cardData.workitemId!.contains('TD') && cardData.linkedItemId!.isNotEmpty)
                  CustomChip(
                    paddingHorizontal: 0,
                    label: Icon(
                      checkIconByCategory(cardData),
                      color: checkIconColorByCategory(cardData),
                      size: 14,
                      // weight: 10.12,
                    ),
                    color: checkChipColorByCategory(cardData),
                  ),
                if (!cardData.workitemId!.contains('TD'))
                  CustomChip(
                    paddingHorizontal: 0,
                    label: Icon(
                      checkIconByCategory(cardData),
                      color: checkIconColorByCategory(cardData),
                      size: 14,
                      // weight: 10.12,
                    ),
                    color: checkChipColorByCategory(cardData),
                  ),
                Container(
                  margin: const EdgeInsets.only(right: 5),
                  child: CustomStatusDropDown(
                    status: status![widget.index].status ?? cardData.status,
                    itemBuilder: (context) => isTypeisTodo(cardData)
                        ? todoDropDownList.map((e) => popupMenuItem(e.toString())).toList()
                        : dropDownStatusDataList.map((e) => popupMenuItem(e.toString())).toList(),
                    onSelected: (value) {
                      CardDetails.updateCardStatus(id: cardData.workitemId!, newStatus: value);
                      status![widget.index].status = value;
                      if (cardData.workitemId!.contains(ItemCategory.isInventory)) {
                        InventoryDetails.updatecardStatus(id: cardData.workitemId!, newStatus: value);
                      } else if (cardData.workitemId!.contains(ItemCategory.isLead)) {
                        LeadDetails.updatecardStatus(id: cardData.workitemId!, newStatus: value);
                      } else if (cardData.workitemId!.contains(ItemCategory.isTodo)) {
                        TodoDetails.updatecardStatus(id: cardData.workitemId!, newStatus: value);
                      }
                      setState(() {});
                      final item = calculateTypeOfWorkitem(cardData.workitemId!);
                      submitActivity(itemid: cardData.workitemId, activitytitle: "$item status changed to $value", user: user!);
                      notifyToUser(
                        currentuserdata: user,
                        itemid: cardData.workitemId!,
                        assignedto: cardData.assignedto,
                        content: "${cardData.workitemId} $item status changed to $value",
                        title: "$item status changed",
                      );
                    },
                  ),
                ),
                checkNotNUllItem(cardData.cardCategory)
                    ? CustomChip(
                        label: CustomText(
                          title: cardData.cardCategory!,
                          size: 10,
                        ),
                      )
                    : const SizedBox(),
                checkNotNUllItem(cardData.propertypricerange?.arearangestart)
                    ? CustomChip(
                        label: CustomText(
                          title: "${cardData.propertypricerange?.arearangestart}",
                          size: 10,
                        ),
                      )
                    : const SizedBox(),
                checkNotNUllItem(cardData.roomconfig?.bedroom)
                    ? CustomChip(
                        label: CustomText(
                          title: buildBedroomText(cardData.roomconfig),
                          size: 10,
                        ),
                      )
                    : const SizedBox(),
                isTypeisTodo(cardData)
                    ? CustomChip(
                        color: AppColor.primary.withOpacity(0.1),
                        label: CustomText(
                          title: "${cardData.cardType}",
                          size: 10,
                          color: AppColor.primary,
                        ),
                      )
                    : const SizedBox(),
                checkNotNUllItem(cardData.propertyarearange?.arearangestart) && checkNotNUllItem(cardData.propertyarearange?.unit)
                    ? CustomChip(
                        label: CustomText(
                          title: "${cardData.propertyarearange?.arearangestart} ${cardData.propertyarearange?.unit}",
                          size: 10,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
        // const Spacer(),
        Row(
          children: [
            buildDateChip(cardData),
            const Icon(
              Icons.chevron_right,
              size: 20,
            )
          ],
        )
        // Row(
        //   children: [
        //     if (cardData.duedate != null)
        //       Container(
        //         decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(4),
        //           color: cardData.duedate != null &&
        //                   DateFormat('dd-MM-yy HH:mm a').parse('${cardData.duedate!} ${cardData.dueTime ?? '11:00 PM'}').isBefore(
        //                         DateTime.now(),
        //                       )
        //               ? cardData.status == "Closed"
        //                   ? AppColor.chipGreyColor
        //                   : const Color.fromARGB(255, 249, 145, 137).withOpacity(0.2)
        //               : AppColor.chipGreyColor,
        //         ),
        //         padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        //         child: Row(
        //           children: [
        //             Icon(
        //               Icons.calendar_month_outlined,
        //               size: 12,
        //               color: cardData.duedate != null &&
        //                       DateFormat('dd-MM-yy HH:mm a').parse('${cardData.duedate!} ${cardData.dueTime ?? '11:00 PM'}').isBefore(DateTime.now())
        //                   ? cardData.status == "Closed"
        //                       ? Colors.black
        //                       : Colors.red
        //                   : Colors.black,
        //             ),
        //             const SizedBox(width: 2),
        //             AppText(
        //               text: DateFormat('dd MMM yyyy').format(DateFormat('dd-MM-yy HH:mm a').parse('${cardData.duedate!} ${cardData.dueTime ?? '11:00 PM'}')),
        //               fontsize: 10,
        //               textColor: cardData.duedate != null &&
        //                       DateFormat('dd-MM-yy HH:mm a').parse('${cardData.duedate!} ${cardData.dueTime ?? '11:00 PM'}').isBefore(DateTime.now())
        //                   ? cardData.status == "Closed"
        //                       ? Colors.black
        //                       : Colors.red.shade500
        //                   : Colors.black,
        //             ),
        //           ],
        //         ),
        //       ),
        //     const Icon(
        //       Icons.chevron_right,
        //       size: 20,
        //     )
        //   ],
        // )
      ],
    );
  }
}

Widget buildChipColor(Color backgroundColor, Color textColor, IconData icon, String text) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: backgroundColor,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
    child: Row(
      children: [
        Icon(
          icon,
          size: 12,
          color: textColor,
        ),
        const SizedBox(width: 2),
        AppText(
          text: text,
          fontsize: 10,
          textColor: textColor,
        ),
      ],
    ),
  );
}

Widget buildDateChip(CardDetails cardData) {
  if (cardData.duedate == null) {
    return const SizedBox(); // Return an empty widget if duedate is null
  }

  final parsedDueDate = DateFormat('dd-MM-yy HH:mm a').parse('${cardData.duedate!} ${cardData.dueTime ?? '11:00 PM'}');
  final isBeforeNow = parsedDueDate.isBefore(DateTime.now());

  final backgroundColor =
      isBeforeNow ? (cardData.status == "Closed" ? AppColor.chipGreyColor : const Color.fromARGB(255, 249, 145, 137).withOpacity(0.2)) : AppColor.chipGreyColor;
  final textColor = isBeforeNow ? (cardData.status == "Closed" ? Colors.black : Colors.red.shade500) : Colors.black;

  return buildChipColor(
    backgroundColor,
    textColor,
    Icons.calendar_month_outlined,
    DateFormat('dd MMM yyyy').format(parsedDueDate),
  );
}
