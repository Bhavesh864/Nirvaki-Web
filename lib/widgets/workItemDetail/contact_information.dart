// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:yes_broker/constants/firebase/detailsModels/inventory_details.dart';

import '../../Customs/custom_chip.dart';
import '../../Customs/custom_text.dart';
import '../../constants/app_constant.dart';

class ContactInformation extends StatelessWidget {
  final Customerinfo customerinfo;
  const ContactInformation({
    Key? key,
    required this.customerinfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                title: '${customerinfo.firstname} ${customerinfo.lastname}',
                fontWeight: FontWeight.w600,
                size: 20,
              ),
              if (!AppConst.getPublicView())
                const CustomChip(
                  label: Icon(
                    Icons.more_vert,
                  ),
                  paddingHorizontal: 3,
                ),
            ],
          ),
        ),
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          dense: true,
          visualDensity: const VisualDensity(vertical: -2),
          leading: const CustomChip(
            label: Icon(
              Icons.call_outlined,
              color: Colors.black,
            ),
            paddingHorizontal: 3,
          ),
          title: CustomText(
            title: customerinfo.mobile!,
            size: 14,
            color: const Color(0xFFA8A8A8),
          ),
          minLeadingWidth: 0,
        ),
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          dense: true,
          visualDensity: const VisualDensity(vertical: -2),
          leading: const CustomChip(
            label: Icon(
              FontAwesomeIcons.whatsapp,
              color: Colors.black,
            ),
            paddingHorizontal: 3,
          ),
          title: CustomText(
            title: customerinfo.whatsapp ?? 'Not Active',
            size: 12,
            color: const Color(0xFFA8A8A8),
          ),
          minLeadingWidth: 0,
        ),
      ],
    );
  }
}
