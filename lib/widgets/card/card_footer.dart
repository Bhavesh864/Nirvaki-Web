// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants/utils/constants.dart';
import '../../constants/utils/image_constants.dart';
import '../custom_chip.dart';

class CardFooter extends StatelessWidget {
  final int index;
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 3),
          child: Text(
            userData[index].name!,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const CustomChip(
          label: Icon(
            Icons.call_outlined,
            color: Colors.black,
            size: 14,
          ),
          paddingHorizontal: 3,
        ),
        const CustomChip(
          label: FaIcon(
            FontAwesomeIcons.whatsapp,
            color: Colors.black,
            size: 14,
          ),
          paddingHorizontal: 3,
        ),
        const CustomChip(
          label: Icon(
            Icons.edit_outlined,
            color: Colors.black,
            size: 14,
          ),
          paddingHorizontal: 3,
        ),
        const CustomChip(
          label: Icon(
            Icons.share_outlined,
            color: Colors.black,
            size: 14,
          ),
          paddingHorizontal: 3,
        ),
        const Spacer(),
        Container(
          margin: const EdgeInsets.only(right: 5),
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            image: const DecorationImage(image: AssetImage(profileImage)),
            borderRadius: BorderRadius.circular(40),
          ),
          // child: Text(width.toString()),
        ),
      ],
    );
  }
}
