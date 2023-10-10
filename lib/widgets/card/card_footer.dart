import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import '../../Customs/custom_chip.dart';
import '../../constants/app_constant.dart';
import '../../constants/functions/make_call_function.dart';
import '../../constants/functions/navigation/navigation_functions.dart';
import '../../constants/utils/constants.dart';
import '../workItemDetail/inventory_details_header.dart';

class CardFooter extends StatelessWidget {
  final int index;
  final List<CardDetails> cardDetails;

  const CardFooter({
    Key? key,
    required this.index,
    required this.cardDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardData = cardDetails[index];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 25,
          width: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              if (cardData.customerinfo != null) ...[
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(right: 3),
                    child: Text(
                      "${checkNotNUllItem(cardData.customerinfo?.firstname) ? cardData.customerinfo!.firstname! : ""} ${checkNotNUllItem(cardData.customerinfo?.lastname) ? cardData.customerinfo!.lastname! : ""}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                checkNotNUllItem(cardData.customerinfo?.mobile)
                    ? CustomChip(
                        onPressed: () => makePhoneCall(cardData.customerinfo!.mobile!),
                        label: const Icon(
                          Icons.call_outlined,
                          size: 12,
                        ),
                        paddingHorizontal: 3,
                      )
                    : const SizedBox(),
                checkNotNUllItem(cardData.customerinfo?.whatsapp)
                    ? CustomChip(
                        onPressed: () => launchWhatsapp(cardData.customerinfo?.whatsapp, context),
                        label: const FaIcon(
                          FontAwesomeIcons.whatsapp,
                          size: 12,
                        ),
                        paddingHorizontal: 3,
                      )
                    : const SizedBox(),
              ] else ...[
                const SizedBox.shrink()
              ],
              // GestureDetector(
              //   onTap: () {
              //     if (cardData.workitemId!.contains("TD")) {
              //       // Navigator .of(context).pushNamed(AppRoutes.editTodo);
              //       context.beamToNamed(AppRoutes.editTodo, data: cardData);
              //     }
              //   },
              //   child: const CustomChip(
              //     label: Icon(
              //       Icons.edit_outlined,
              //     ),
              //     paddingHorizontal: 3,
              //   ),
              // ),
              if (!cardDetails[index].workitemId!.contains('TD'))
                CustomChip(
                  onPressed: () {
                    shareUrl(
                      context,
                      textToCombine: navigationUrl(
                        context,
                        cardDetails[index].workitemId!,
                      ),
                    );
                  },
                  label: const Icon(
                    Icons.share_outlined,
                    size: 12,
                  ),
                  paddingHorizontal: 3,
                ),
              if (!cardDetails[index].workitemId!.contains('TD'))
                CustomChip(
                  label: CustomText(
                    title: cardData.workitemId!,
                    size: 10,
                  ),
                  paddingHorizontal: 2,
                ),
            ],
          ),
        ),
        const Spacer(),
        checkNotNUllItem(cardData.assignedto) && cardData.assignedto!.isNotEmpty
            ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: cardData.assignedto!
                    .sublist(
                      0,
                      cardData.assignedto!.length < 2
                          ? 1
                          : cardData.assignedto!.length < 3
                              ? 2
                              : 3,
                    )
                    .asMap()
                    .entries
                    .map((entry) {
                  final index = entry.key;
                  final user = entry.value;
                  return Transform.translate(
                    offset: Offset(index * -10.0, 0),
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
                                title: '+${cardData.assignedto!.length - 2}',
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
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
