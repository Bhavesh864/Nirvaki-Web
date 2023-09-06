// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/firebase/detailsModels/inventory_details.dart';
import 'package:yes_broker/constants/firebase/detailsModels/lead_details.dart';
import 'package:yes_broker/constants/firebase/detailsModels/todo_details.dart';
import 'package:yes_broker/constants/firebase/send_notification.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/widgets/app/dropdown_menu.dart';
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
              CustomChip(
                paddingHorizontal: 0,
                label: Icon(
                  checkIconByCategory(cardData),
                  color: checkIconColorByCategory(cardData),
                  size: 16,
                  // weight: 10.12,
                ),
                color: checkChipColorByCategory(cardData),
              ),
              CustomStatusDropDown(
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
                  notifyToUser(
                    itemid: cardData.workitemId!,
                    assignedto: cardData.assignedto,
                    content: "${currentUser["userfirstname"]} ${currentUser["userlastname"]} change status to $value",
                    title: "${cardData.workitemId} status changed",
                  );
                },
              ),
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
