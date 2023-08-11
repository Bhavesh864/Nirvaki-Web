import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import '../../Customs/custom_chip.dart';

class CardFooter extends StatelessWidget {
  final int index;
  final List<CardDetails> cardDetails;
  final bool? call;
  final bool? whatsapp;
  final bool? edit;
  final bool? propertyId;
  final bool? name;
  final bool? showAvatarNumber;
  final bool? showAvatar1;
  final bool? showAvatar2;

  const CardFooter({
    Key? key,
    required this.index,
    this.call = true,
    this.whatsapp = true,
    this.edit = true,
    this.propertyId = true,
    this.name = true,
    this.showAvatarNumber = false,
    this.showAvatar1 = true,
    this.showAvatar2 = false,
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
              // const CustomChip(
              //   label: Icon(
              //     Icons.edit_outlined,
              //   ),
              //   paddingHorizontal: 3,
              // ),
              const CustomChip(
                label: Icon(
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
        Container(
          margin: const EdgeInsets.only(right: 5),
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage(cardData.assignedto![0].image!.isEmpty ? noImg : cardData.assignedto![0].image!), fit: BoxFit.fill),
            borderRadius: BorderRadius.circular(40),
          ),
        ),
      ],
    );
  }
}
