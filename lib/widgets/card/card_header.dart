// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/firebase/detailsModels/inventory_details.dart';
import 'package:yes_broker/constants/firebase/detailsModels/lead_details.dart';
import 'package:yes_broker/constants/utils/colors.dart';
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 30,
          width: 260,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              CustomChip(
                  label: Icon(
                    checkIconByCategory(cardData),
                    color: checkIconColorByCategory(cardData),
                    size: 18,
                    // weight: 10.12,
                  ),
                  color: checkChipColorByCategory(cardData)),
              checkNotNUllItem(cardData.roomconfig?.bedroom)
                  ? CustomChip(
                      label: CustomText(
                        title: "${cardData.roomconfig?.bedroom}BHK+${cardData.roomconfig?.additionalroom?[0] ?? ""}",
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
              checkNotNUllItem(cardData.propertyarearange?.arearangestart)
                  ? CustomChip(
                      label: CustomText(
                        title: "${cardData.propertyarearange?.arearangestart} ${cardData.propertyarearange?.unit}",
                        size: 10,
                      ),
                    )
                  : const SizedBox(),
              checkNotNUllItem(cardData.propertypricerange?.arearangestart)
                  ? CustomChip(
                      label: CustomText(
                        title: "${cardData.propertypricerange?.arearangestart}${cardData.propertypricerange?.unit}",
                        size: 10,
                      ),
                    )
                  : const SizedBox(),
              checkNotNUllItem(cardData.cardCategory)
                  ? CustomChip(
                      label: CustomText(
                        title: cardData.cardCategory!,
                        size: 10,
                      ),
                    )
                  : const SizedBox(),
              PopupMenuButton(
                initialValue: status ?? cardData.status,
                splashRadius: 0,
                padding: EdgeInsets.zero,
                color: Colors.white.withOpacity(1),
                offset: const Offset(10, 40),
                itemBuilder: (context) => dropDownStatusDataList.map((e) => popupMenuItem(e.toString())).toList(),
                onSelected: (value) {
                  CardDetails.updateCardStatus(id: cardData.workitemId!, newStatus: value);
                  status![widget.index].status = value;
                  if (cardData.workitemId!.contains("IN")) {
                    InventoryDetails.updatecardStatus(id: cardData.workitemId!, newStatus: value);
                  } else if (cardData.workitemId!.contains("LD")) {
                    LeadDetails.updatecardStatus(id: cardData.workitemId!, newStatus: value);
                  }
                  setState(() {});
                },
                child: CustomChip(
                  label: Row(
                    children: [
                      CustomText(
                        title: status![widget.index].status ?? cardData.status!,
                        color: taskStatusColor(status![widget.index].status ?? cardData.status!),
                        size: 10,
                      ),
                      Icon(
                        Icons.expand_more,
                        size: 18,
                        color: taskStatusColor(status![widget.index].status ?? cardData.status!),
                      ),
                    ],
                  ),
                  color: taskStatusColor(status![widget.index].status ?? cardData.status!).withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        const Icon(
          Icons.chevron_right,
          size: 20,
        )
      ],
    );
  }
}

bool isTypeisTodo(CardDetails cardData) {
  if (cardData.cardType != "LD" && cardData.cardType != "IN") {
    return true;
  }
  return false;
}

dynamic checkIconByCategory(CardDetails carddata) {
  if (carddata.workitemId!.contains("IN")) {
    return MaterialSymbols.location_home_outlined;
  } else if (carddata.workitemId!.contains("LD")) {
    return MaterialSymbols.location_away;
  } else if (carddata.linkedItemType!.contains("LD")) {
    return MaterialSymbols.location_away;
  } else if (carddata.linkedItemType!.contains("IN")) {
    return MaterialSymbols.location_home_outlined;
  }
  return MaterialSymbols.location_home_outlined;
}

Color checkIconColorByCategory(CardDetails carddata) {
  if (carddata.workitemId!.contains("IN")) {
    return AppColor.inventoryIconColor;
  } else if (carddata.workitemId!.contains("LD")) {
    return AppColor.leadIconColor;
  } else if (carddata.linkedItemType!.contains("LD")) {
    return AppColor.leadIconColor;
  } else if (carddata.linkedItemType!.contains("IN")) {
    return AppColor.inventoryIconColor;
  }
  return AppColor.leadIconColor;
}

Color checkChipColorByCategory(CardDetails carddata) {
  if (carddata.workitemId!.contains("IN")) {
    return AppColor.inventoryChipColor;
  } else if (carddata.workitemId!.contains("LD")) {
    return AppColor.leadChipColor;
  } else if (carddata.linkedItemType!.contains("LD")) {
    return AppColor.leadChipColor;
  } else if (carddata.linkedItemType!.contains("IN")) {
    return AppColor.inventoryChipColor;
  }
  return AppColor.inventoryIconColor;
}

bool checkNotNUllItem(dynamic data) {
  if (data != null) {
    return true;
  } else {
    return false;
  }
}
