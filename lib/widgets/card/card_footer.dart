import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import '../../Customs/custom_chip.dart';
import '../../constants/functions/make_call_function.dart';
import '../../constants/functions/navigation/navigation_functions.dart';
import '../../constants/utils/constants.dart';
import '../workItemDetail/Inventory_details_header.dart';

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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 30,
          width: 260,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(right: 3),
                  child: Text(
                    "${cardData.customerinfo!.firstname!} ${cardData.customerinfo!.lastname!}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              CustomChip(
                onPressed: () => makePhoneCall(cardData.customerinfo!.mobile!),
                label: const Icon(
                  Icons.call_outlined,
                ),
                paddingHorizontal: 3,
              ),
              CustomChip(
                onPressed: () => launchWhatsapp(cardData.customerinfo!.whatsapp, context),
                label: const FaIcon(
                  FontAwesomeIcons.whatsapp,
                ),
                paddingHorizontal: 3,
              ),
              // GestureDetector(
              //   onTap: () {
              //     if (cardData.workitemId!.contains("TD")) {
              //       // Navigator.of(context).pushNamed(AppRoutes.editTodo);
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
                ),
                paddingHorizontal: 3,
              ),
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
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: cardData.assignedto!
              .sublist(
                  0,
                  cardData.assignedto!.length < 2
                      ? 1
                      : cardData.assignedto!.length < 3
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
        ),
      ],
    );
  }
}
