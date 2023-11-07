import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/widgets/assigned_circular_images.dart';
import '../../Customs/custom_chip.dart';
import '../../constants/app_constant.dart';
import '../../constants/functions/make_call_function.dart';
import '../../constants/functions/navigation/navigation_functions.dart';
import '../../constants/methods/string_methods.dart';
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
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
            }),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                if (cardData.customerinfo != null) ...[
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(right: 5),
                      child: Text(
                        "${checkNotNUllItem(cardData.customerinfo?.firstname) ? capitalizeFirstLetter(cardData.customerinfo!.firstname!) : ""} ${checkNotNUllItem(cardData.customerinfo?.lastname) ? capitalizeFirstLetter(cardData.customerinfo!.lastname!) : ""}",
                        style: const TextStyle(
                          fontSize: 13,
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
                          onPressed: () {
                            List<String>? splitString = cardData.customerinfo?.whatsapp?.split(' ');
                            if (splitString?.length == 2) {
                              launchWhatsapp(splitString?[1], context);
                            }
                          },
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
        ),
        const Spacer(),
        AssignedCircularImages(
          cardData: cardData,
          heightOfCircles: 24,
          widthOfCircles: 24,
        )
      ],
    );
  }
}
