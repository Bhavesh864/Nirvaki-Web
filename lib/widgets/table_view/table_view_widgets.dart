import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../Customs/custom_text.dart';
import '../../Customs/text_utility.dart';
import '../../constants/app_constant.dart';
import '../../constants/firebase/detailsModels/card_details.dart';
import '../../constants/firebase/detailsModels/inventory_details.dart';
import '../../constants/firebase/detailsModels/lead_details.dart';
import '../../constants/firebase/detailsModels/todo_details.dart';
import '../../constants/functions/make_call_function.dart';
import '../../constants/functions/navigation/navigation_functions.dart';
import '../../constants/utils/colors.dart';
import '../../constants/utils/constants.dart';
import '../../customs/custom_chip.dart';
import '../../riverpodstate/common_index_state.dart';
import '../app/dropdown_menu.dart';
import '../app/nav_bar.dart';
import '../assigned_circular_images.dart';

TableRow buildTableHeader({bool isTodo = false}) {
  return TableRow(
    children: [
      buildWorkItemTableItem(
        const Row(
          children: [
            Text(
              'DESCRIPTION',
              style: TextStyle(
                color: AppColor.cardtitleColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            Icon(
              Icons.swap_vert,
              color: Color(0xFF6A7587),
              size: 16,
            )
          ],
        ),
      ),
      buildWorkItemTableItem(
        Text(
          isTodo ? 'TASK TYPE' : 'DETAILS',
          style: const TextStyle(
            color: AppColor.cardtitleColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      buildWorkItemTableItem(
        const Text(
          'STATUS',
          style: TextStyle(
            color: AppColor.cardtitleColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      if (isTodo)
        buildWorkItemTableItem(
          const Row(
            children: [
              Text(
                'DUE DATE',
                style: TextStyle(
                  color: AppColor.cardtitleColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              Icon(
                Icons.swap_vert,
                color: Color(0xFF6A7587),
                size: 16,
              )
            ],
          ),
          align: Alignment.center,
        ),
      buildWorkItemTableItem(
        const Text(
          'OWNER',
          style: TextStyle(
            color: AppColor.cardtitleColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      buildWorkItemTableItem(
        const Text(
          'ASSIGNED TO',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColor.cardtitleColor,
            letterSpacing: 0.5,
          ),
        ),
        align: Alignment.center,
      ),
      // if (!isTodo)
      //   buildWorkItemTableItem(
      //     const Text(
      //       '',
      //     ),
      //     align: Alignment.center,
      //   ),
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
        Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: Text(
            cardItem.cardTitle!,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
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
            CustomChip2(
                label: Icon(
                  checkIconByCategory(cardItem),
                  color: checkIconColorByCategory(cardItem),
                  size: 18,
                  // weight: 10.12,
                ),
                color: checkChipColorByCategory(cardItem)),
            checkNotNUllItem(cardItem.roomconfig?.bedroom)
                ? CustomChip2(
                    label: CustomText(
                      title: buildBedroomText(cardItem.roomconfig),
                      size: 10,
                    ),
                  )
                : const SizedBox(),
            isTypeisTodo(cardItem)
                ? CustomChip2(
                    color: AppColor.primary.withOpacity(0.1),
                    label: CustomText(
                      title: "${cardItem.cardType}",
                      size: 10,
                      color: AppColor.primary,
                    ),
                  )
                : const SizedBox(),
            checkNotNUllItem(cardItem.propertyarearange?.arearangestart) && checkNotNUllItem(cardItem.propertyarearange?.unit)
                ? CustomChip2(
                    label: CustomText(
                      title: "${cardItem.propertyarearange?.arearangestart} ${cardItem.propertyarearange?.unit}",
                      size: 10,
                    ),
                  )
                : const SizedBox(),
            checkNotNUllItem(cardItem.propertypricerange?.arearangestart)
                ? CustomChip2(
                    label: CustomText(
                      title: "${cardItem.propertypricerange?.arearangestart}",
                      size: 10,
                    ),
                  )
                : const SizedBox(),
            checkNotNUllItem(cardItem.cardCategory)
                ? CustomChip2(
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

      if (id!.contains('TD'))
        buildWorkItemTableItem(
          AppText(
            text: DateFormat('dd MMM yyyy').format(DateFormat('dd-MM-yy').parse(cardItem.duedate!)),
            fontsize: 12,
            textColor: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),

      buildWorkItemTableItem(
        ScrollConfiguration(
          behavior: ScrollConfiguration.of(context!).copyWith(scrollbars: false),
          child: ListView(
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
              CustomChip2(
                onPressed: () => makePhoneCall(cardItem.customerinfo!.mobile!),
                label: const Icon(
                  Icons.call_outlined,
                ),
                paddingHorizontal: 3,
              ),
              InkWell(
                onTap: () {},
                child: CustomChip2(
                  onPressed: () => launchWhatsapp(cardItem.customerinfo?.whatsapp, context),
                  label: const FaIcon(
                    FontAwesomeIcons.whatsapp,
                  ),
                  paddingHorizontal: 3,
                ),
              ),
            ],
          ),
        ),
        id: id,
        context: context,
        ref: ref,
      ),

      buildWorkItemTableItem(
        align: Alignment.center,
        AssignedCircularImages(
          cardData: cardItem,
          heightOfCircles: 24,
          widthOfCircles: 24,
        ),
        id: id,
        context: context,
        ref: ref,
      ),

      // if (!id!.contains('TD'))
      //   buildWorkItemTableItem(
      //     InkWell(
      //       onTap: () {
      //         AppConst.getOuterContext()!.beamToNamed(id.contains("IN") ? AppRoutes.addInventory : AppRoutes.addLead, data: true);
      //       },
      //       child: const CustomChip(
      //         label: Icon(Icons.edit_outlined),
      //         paddingVertical: 6,
      //       ),
      //     ),
      //     align: Alignment.centerRight,
      //   ),
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
