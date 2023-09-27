import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Customs/custom_chip.dart';
import '../../Customs/custom_text.dart';
import '../../constants/app_constant.dart';
import '../../constants/firebase/detailsModels/card_details.dart';
import '../../constants/firebase/detailsModels/inventory_details.dart';
import '../../constants/firebase/detailsModels/lead_details.dart';
import '../../constants/firebase/detailsModels/todo_details.dart';
import '../../constants/functions/navigation/navigation_functions.dart';
import '../../constants/utils/colors.dart';
import '../../constants/utils/constants.dart';
import '../../riverpodstate/common_index_state.dart';
import '../app/dropdown_menu.dart';
import '../app/nav_bar.dart';

TableRow buildTableHeader() {
  return TableRow(
    children: [
      buildWorkItemTableItem(
        const Text(
          'DESCRIPTION',
          style: TextStyle(
            color: AppColor.cardtitleColor,
          ),
        ),
      ),
      buildWorkItemTableItem(
        const Text(
          'DETAILS',
          style: TextStyle(
            color: AppColor.cardtitleColor,
          ),
        ),
      ),
      buildWorkItemTableItem(
        const Text(
          'STATUS',
          style: TextStyle(
            color: AppColor.cardtitleColor,
          ),
        ),
      ),
      buildWorkItemTableItem(
        const Text(
          'OWNER',
          style: TextStyle(
            color: AppColor.cardtitleColor,
          ),
        ),
      ),
      buildWorkItemTableItem(
          const Text(
            'ASSIGNED TO',
            style: TextStyle(
              color: AppColor.cardtitleColor,
            ),
          ),
          align: Alignment.center),
      // buildWorkItemTableItem(
      //   Container(),
      //   align: Alignment.center,
      // ),
    ],
  );
}

TableRow buildWorkItemRowTile(
  CardDetails cardItem,
  int index,
  List<CardDetails>? status, {
  WidgetRef? ref,
  BuildContext? context,
  String? id,
}) {
  return TableRow(
    // key: ValueKey(cardItem.workitemId),
    children: [
      buildWorkItemTableItem(
        Text(
          cardItem.cardTitle!,
        ),
        id: id,
        context: context,
        ref: ref,
      ),
      buildWorkItemTableItem(
        ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: [
            CustomChip(
                label: Icon(
                  checkIconByCategory(cardItem),
                  color: checkIconColorByCategory(cardItem),
                  size: 18,
                  // weight: 10.12,
                ),
                color: checkChipColorByCategory(cardItem)),
            checkNotNUllItem(cardItem.roomconfig?.bedroom)
                ? CustomChip(
                    label: CustomText(
                      title: "${cardItem.roomconfig?.bedroom}BHK+${cardItem.roomconfig?.additionalroom?[0] ?? ""}",
                      size: 10,
                    ),
                  )
                : const SizedBox(),
            isTypeisTodo(cardItem)
                ? CustomChip(
                    color: AppColor.primary.withOpacity(0.1),
                    label: CustomText(
                      title: "${cardItem.cardType}",
                      size: 10,
                      color: AppColor.primary,
                    ),
                  )
                : const SizedBox(),
            checkNotNUllItem(cardItem.propertyarearange?.arearangestart) && checkNotNUllItem(cardItem.propertyarearange?.unit)
                ? CustomChip(
                    label: CustomText(
                      title: "${cardItem.propertyarearange?.arearangestart} ${cardItem.propertyarearange?.unit}",
                      size: 10,
                    ),
                  )
                : const SizedBox(),
            checkNotNUllItem(cardItem.propertypricerange?.arearangestart)
                ? CustomChip(
                    label: CustomText(
                      title: "${cardItem.propertypricerange?.arearangestart}${cardItem.propertypricerange?.unit}",
                      size: 10,
                    ),
                  )
                : const SizedBox(),
            checkNotNUllItem(cardItem.cardCategory)
                ? CustomChip(
                    label: CustomText(
                      title: cardItem.cardCategory!,
                      size: 10,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        id: id,
        context: context,
        ref: ref,
      ),
      buildWorkItemTableItem(
        StatefulBuilder(builder: (context, setstate) {
          return CustomStatusDropDown(
            status: status![index].status ?? cardItem.status,
            itemBuilder: (context) => isTypeisTodo(cardItem)
                ? todoDropDownList.map((e) => popupMenuItem(e.toString())).toList()
                : dropDownStatusDataList.map((e) => popupMenuItem(e.toString())).toList(),
            onSelected: (value) {
              CardDetails.updateCardStatus(id: cardItem.workitemId!, newStatus: value);
              if (cardItem.workitemId!.contains(ItemCategory.isInventory)) {
                InventoryDetails.updatecardStatus(id: cardItem.workitemId!, newStatus: value);
              } else if (cardItem.workitemId!.contains(ItemCategory.isLead)) {
                LeadDetails.updatecardStatus(id: cardItem.workitemId!, newStatus: value);
              } else if (cardItem.workitemId!.contains(ItemCategory.isTodo)) {
                TodoDetails.updatecardStatus(id: cardItem.workitemId!, newStatus: value);
              }
              status[index].status = value;
              setstate(() {});
            },
          );
        }),
        id: id,
        context: context,
        ref: ref,
      ),
      buildWorkItemTableItem(
        ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(right: 3),
                child: Text(
                  "${cardItem.customerinfo?.firstname} ${cardItem.customerinfo?.lastname ?? ""}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const CustomChip(
              label: Icon(
                Icons.call_outlined,
              ),
              paddingHorizontal: 3,
            ),
            const CustomChip(
              label: FaIcon(
                FontAwesomeIcons.whatsapp,
              ),
              paddingHorizontal: 3,
            ),
          ],
        ),
        id: id,
        context: context,
        ref: ref,
      ),
      buildWorkItemTableItem(
        align: Alignment.center,
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: cardItem.assignedto!
              .sublist(
                  0,
                  cardItem.assignedto!.length < 2
                      ? 1
                      : cardItem.assignedto!.length < 3
                          ? 2
                          : 3)
              .asMap()
              .entries
              .map((entry) {
            final index = entry.key;
            final user = entry.value;
            return Transform.translate(
              offset: Offset(index * -8.0, 0),
              child: Container(
                margin: EdgeInsets.zero,
                width: 24,
                height: 24,
                decoration: index > 1
                    ? BoxDecoration(
                        border: Border.all(color: Colors.white),
                        color: index > 1 ? Colors.grey.shade300 : null,
                        borderRadius: BorderRadius.circular(40),
                      )
                    : BoxDecoration(
                        border: Border.all(color: Colors.white),
                        image: DecorationImage(
                          image: NetworkImage(
                            user.image!.isEmpty ? noImg : user.image!,
                          ),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                child: index > 1
                    ? Center(
                        child: CustomText(
                          title: '+${cardItem.assignedto!.length - 2}',
                          color: Colors.black,
                          size: 9,
                          // textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
        id: id,
        context: context,
        ref: ref,
      ),

      // buildWorkItemTableItem(
      //   Container(),
      //   align: Alignment.center,
      // ),
    ],
  );
}

TableCell buildWorkItemTableItem(
  Widget child, {
  Alignment align = Alignment.centerLeft,
  String? id = '',
  BuildContext? context,
  WidgetRef? ref,
}) {
  return TableCell(
    verticalAlignment: TableCellVerticalAlignment.middle,
    child: GestureDetector(
      onTap: () {
        if (context != null && ref != null && id != '') {
          ref.read(detailsPageIndexTabProvider.notifier).update(
                (state) => 0,
              );
          navigateBasedOnId(context, id!, ref);
        }
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 0),
        alignment: align,
        height: 70,
        child: child,
      ),
    ),
  );
}
