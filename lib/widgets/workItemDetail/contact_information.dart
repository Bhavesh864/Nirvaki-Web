// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yes_broker/constants/firebase/userModel/broker_info.dart';
import 'package:yes_broker/constants/functions/make_call_function.dart';
import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/customs/text_utility.dart';

import '../../Customs/custom_chip.dart';
import '../../Customs/custom_text.dart';
import '../../constants/app_constant.dart';
import '../../constants/methods/string_methods.dart';

class ContactInformation extends StatelessWidget {
  final dynamic customerinfo;
  const ContactInformation({
    Key? key,
    required this.customerinfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double bottomNavHeight = MediaQuery.of(context).padding.bottom;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (checkNotNUllItem(customerinfo?.firstname) || checkNotNUllItem(customerinfo?.lastname)) ...[
              Container(
                constraints: BoxConstraints(maxWidth: Responsive.isTablet(context) ? 240 : 270),
                child: AppText(
                  text: capitalizeFirstLetter('${customerinfo.firstname} ${checkNotNUllItem(customerinfo?.lastname) ? customerinfo.lastname : ""}'),
                  fontWeight: FontWeight.w600,
                  softwrap: true,
                  // overflow: TextOverflow.ellipsis,
                  fontsize: 20,
                ),
              ),
            ],
            if (!AppConst.getPublicView())
              const CustomChip(
                paddingVertical: 6,
                label: Icon(
                  Icons.more_vert,
                ),
                paddingHorizontal: 3,
              ),
          ],
        ),
        if (customerinfo.companyname != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.apartment_outlined,
                  color: Colors.grey,
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: CustomText(
                    title: customerinfo.companyname,
                    size: 12,
                    softWrap: true,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFA8A8A8),
                  ),
                ),
              ],
            ),
          ),
        // ListTile(
        //   minVerticalPadding: 0,
        //   contentPadding: const EdgeInsets.all(0),
        //   leading: const Icon(
        //     Icons.apartment_outlined,
        //   ),
        //   dense: true,
        //   minLeadingWidth: 2,
        //   horizontalTitleGap: 8,
        //   titleAlignment: ListTileTitleAlignment.center,
        //   title: CustomText(
        //     title: customerinfo.companyname,
        //     size: 12,
        //     fontWeight: FontWeight.w400,
        //     color: const Color(0xFFA8A8A8),
        //   ),
        // ),
        ListTile(
          onTap: () => makePhoneCall(customerinfo.mobile!),
          contentPadding: const EdgeInsets.all(0),
          dense: true,
          visualDensity: const VisualDensity(vertical: -2),
          leading: const CustomChip(
            paddingVertical: 6,
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
          minVerticalPadding: 0,
          onTap: () {
            List<String> splitString = customerinfo.whatsapp.split(' ');
            if (splitString.length == 2) {
              launchWhatsapp(splitString[1], context);
            }
          },
          contentPadding: const EdgeInsets.all(0),
          dense: true,
          visualDensity: const VisualDensity(vertical: -2),
          leading: const CustomChip(
            paddingVertical: 6,
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
        if (customerinfo?.email != null)
          ListTile(
            onTap: () {
              openEmailApp(customerinfo?.email);
            },
            contentPadding: const EdgeInsets.all(0),
            dense: true,
            visualDensity: const VisualDensity(vertical: -2),
            leading: const CustomChip(
              paddingVertical: 6,
              label: Icon(
                Icons.mail_outline,
                color: Colors.black,
              ),
              paddingHorizontal: 3,
            ),
            title: SizedBox(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: CustomText(
                  title: customerinfo.email ?? 'Not Active',
                  size: 13,
                  // softWrap: true,
                  color: const Color(0xFFA8A8A8),
                ),
              ),
            ),
            minLeadingWidth: 0,
          ),

        SizedBox(height: bottomNavHeight),
      ],
    );
  }
}

class CompanyInformation extends StatelessWidget {
  final BrokerInfo companyInfo;
  const CompanyInformation({
    Key? key,
    required this.companyInfo,
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
                title: toPascalCase(companyInfo.companyname!),
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
            title: companyInfo.brokercompanynumber!,
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
            title: companyInfo.brokercompanywhatsapp ?? 'Not Active',
            size: 12,
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
              Icons.home_outlined,
              color: Colors.black,
            ),
            paddingHorizontal: 3,
          ),
          title: CustomText(
            softWrap: true,
            title:
                "${companyInfo.brokercompanyaddress["Addressline1"]}, ${companyInfo.brokercompanyaddress["Addressline2"]}, ${companyInfo.brokercompanyaddress["city"]}, ${companyInfo.brokercompanyaddress["state"]}",
            size: 12,
            color: const Color(0xFFA8A8A8),
          ),
          minLeadingWidth: 0,
        ),
      ],
    );
  }
}
