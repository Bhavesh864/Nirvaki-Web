import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/functions/navigation/navigation_functions.dart';
import 'package:yes_broker/widgets/workItemDetail/Inventory_details_header.dart';
import 'package:yes_broker/widgets/workItemDetail/inventory_details_header.dart';
import '../../Customs/custom_chip.dart';
import '../../constants/utils/constants.dart';

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
              GestureDetector(
                onTap: () {
                  shareUrl(
                    context,
                    textToCombine: navigationUrl(
                      context,
                      cardDetails[index].workitemId!,
                    ),
                  );
                },
                child: const CustomChip(
                  label: Icon(
                    Icons.share_outlined,
                  ),
                  paddingHorizontal: 3,
                ),
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
          mainAxisAlignment: MainAxisAlignment.end,
          children: cardData.assignedto!.asMap().entries.map((entry) {
            final index = entry.key;
            final user = entry.value;
            return Transform.translate(
              offset: Offset(index * -8.0, 0),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      user.image!.isEmpty ? noImg : user.image!,
                    ),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}
