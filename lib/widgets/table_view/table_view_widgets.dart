import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Customs/custom_chip.dart';
import '../../Customs/custom_text.dart';
import '../../constants/app_constant.dart';
import '../../constants/firebase/detailsModels/card_details.dart';
import '../../constants/firebase/detailsModels/inventory_details.dart';
import '../../constants/firebase/detailsModels/lead_details.dart';
import '../../constants/firebase/detailsModels/todo_details.dart';
import '../../constants/utils/colors.dart';
import '../../constants/utils/constants.dart';
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
  List<CardDetails>? status,
) {
  return TableRow(
    key: ValueKey(cardItem.workitemId),
    children: [
      buildWorkItemTableItem(
        Text(
          cardItem.cardTitle!,
        ),
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
            checkNotNUllItem(cardItem.propertyarearange?.arearangestart)
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
      ),
      buildWorkItemTableItem(
        ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(right: 3),
                child: Text(
                  "${cardItem.customerinfo!.firstname!} ${cardItem.customerinfo!.lastname!}",
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
      ),
      buildWorkItemTableItem(
          Container(
            margin: const EdgeInsets.only(right: 5),
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage(cardItem.assignedto![0].image!.isEmpty ? noImg : cardItem.assignedto![0].image!), fit: BoxFit.fill),
              borderRadius: BorderRadius.circular(40),
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

TableCell buildWorkItemTableItem(Widget child, {Alignment align = Alignment.centerLeft}) {
  return TableCell(
    verticalAlignment: TableCellVerticalAlignment.middle,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 0),
      alignment: align,
      height: 70,
      child: child,
    ),
  );
}