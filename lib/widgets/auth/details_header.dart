import 'package:flutter/material.dart';

import '../../Customs/custom_text.dart';
import '../../Customs/responsive.dart';
import '../../constants/utils/colors.dart';

class DetailsHeaderWidget extends StatelessWidget {
  final bool isPersonalDetails;
  const DetailsHeaderWidget({super.key, required this.isPersonalDetails});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            CircleAvatar(
              backgroundColor: isPersonalDetails ? AppColor.primary : AppColor.secondary,
              radius: 30,
              child: Icon(
                Icons.person_outline,
                color: isPersonalDetails ? Colors.white : const Color(0xFF444444),
                size: 32,
              ),
            ),
            CustomText(
              title: 'Personal Details',
              size: 14,
              color: isPersonalDetails ? AppColor.primary : Colors.black,
            ),
          ],
        ),
        const SizedBox(
          width: 10,
        ),
        SizedBox(
            width: Responsive.isMobile(context) ? 30 : 80,
            child: const Divider(
              color: Colors.grey,
              thickness: 1,
            )),
        const SizedBox(
          width: 10,
        ),
        Column(
          children: [
            CircleAvatar(
              backgroundColor: !isPersonalDetails ? AppColor.primary : AppColor.secondary,
              radius: 30,
              child: Icon(
                Icons.home_work_outlined,
                color: !isPersonalDetails ? Colors.white : const Color(0xFF444444),
                size: 32,
              ),
            ),
            CustomText(
              title: 'Company Details',
              size: 14,
              color: !isPersonalDetails ? AppColor.primary : Colors.black,
            ),
          ],
        ),
      ],
    );
  }
}
