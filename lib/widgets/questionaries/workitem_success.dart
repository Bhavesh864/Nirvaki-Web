// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../customs/custom_fields.dart';
import '../../customs/custom_text.dart';

class WorkItemSuccessWidget extends StatelessWidget {
  final String isInventory;
  final bool isEdit;

  const WorkItemSuccessWidget({
    Key? key,
    required this.isInventory,
    required this.isEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Lottie.network(
            'https://lottie.host/a861e48f-e9ec-4daf-a520-b13522422df5/pcZJc9Jkdm.json',
            alignment: Alignment.center,
            height: 396,
            width: 444,
          ),
        ),
        CustomText(
          title: ' ${isInventory == 'IN' ? 'Inventory' : isInventory == 'Todo' ? 'Todo' : 'Lead'} has been \n  ${isEdit ? 'Edited' : 'Created'} Successfully',
          size: 48,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: CustomButton(
            height: 40,
            width: 165,
            isBorder: false,
            text: 'Go to Dashboard',
            onPressed: () {
              // if (Responsive.isMobile(context)) {
              //   Navigator.of(context).pushNamed(AppRoutes.homeScreen);
              // } else {
              context.beamToNamed('/');
              // }
            },
          ),
        )
      ],
    );
  }
}
