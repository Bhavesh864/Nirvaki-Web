// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';

import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/utils/colors.dart';

import '../../constants/utils/constants.dart';

import '../app/nav_bar.dart';
import '../custom_chip.dart';

// ignore: must_be_immutable
class CardHeader extends StatelessWidget {
  final int index;
  List<CardDetails> cardDetails;

  CardHeader({
    Key? key,
    required this.index,
    required this.cardDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardData = cardDetails[index];
    return Row(
      children: [
        Expanded(
          child: Row(
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
                            label: CustomText(
                              title: "${cardData.cardType}",
                              size: 10,
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
                      tooltip: '',
                      initialValue: selectedOption,
                      splashRadius: 0,
                      padding: EdgeInsets.zero,
                      color: Colors.white.withOpacity(1),
                      offset: const Offset(10, 40),
                      itemBuilder: (context) => dropDownListData.map((e) => popupMenuItem(e.toString())).toList(),
                      child: CustomChip(
                        label: Row(
                          children: [
                            CustomText(
                              title: selectedOption,
                              color: taskStatusColor(selectedOption),
                              size: 10,
                            ),
                            Icon(
                              Icons.expand_more,
                              size: 18,
                              color: taskStatusColor(selectedOption),
                            ),
                          ],
                        ),
                        color: taskStatusColor(selectedOption).withOpacity(0.1),
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
          ),
        ),
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
