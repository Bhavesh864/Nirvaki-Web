// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';

import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/utils/colors.dart';

import '../../constants/utils/constants.dart';

import '../app/nav_bar.dart';
import '../custom_chip.dart';

class CardHeader extends StatelessWidget {
  final int index;
  List<CardDetails> cardDetails;
  final bool? showWorkItem;
  final bool? showTask;
  final bool? showTag1;
  final bool? showTag2;
  final bool? showTag3;
  final bool? showTag4;
  final bool? showTag5;
  final bool? showTag6;
  final bool? showStatus;
  final bool? showDate;
  CardHeader({
    Key? key,
    required this.index,
    required this.cardDetails,
    this.showWorkItem = true,
    this.showTask = true,
    this.showTag1 = false,
    this.showTag2 = false,
    this.showTag3 = false,
    this.showTag4 = false,
    this.showTag5 = false,
    this.showTag6 = false,
    this.showStatus = true,
    this.showDate = true,
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
                        cardData.cardType == "IN" ? MaterialSymbols.location_home_outlined : MaterialSymbols.location_away,
                        color: cardData.cardType == "IN" ? AppColor.inventoryIconColor : AppColor.leadIconColor,
                        size: 18,
                        // weight: 10.12,
                      ),
                      color: cardData.cardType == "IN" ? AppColor.inventoryChipColor : AppColor.leadChipColor,
                    ),
                    cardData.roomconfig!.bedroom != null
                        ? CustomChip(
                            label: CustomText(
                              title: "${cardData.roomconfig!.bedroom}BHK+${cardData.roomconfig!.additionalroom?[0] ?? ""}",
                              size: 10,
                            ),
                          )
                        : const SizedBox(),
                    CustomChip(
                      label: CustomText(
                        title: "${cardData.propertyarearange!.arearangestart} ${cardData.propertyarearange!.unit}",
                        size: 10,
                      ),
                    ),
                    CustomChip(
                      label: CustomText(
                        title: "${cardData.propertypricerange!.arearangestart}${cardData.propertypricerange!.unit}",
                        size: 10,
                      ),
                    ),
                    CustomChip(
                      label: CustomText(
                        title: cardData.cardCategory!,
                        size: 10,
                      ),
                    ),
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
