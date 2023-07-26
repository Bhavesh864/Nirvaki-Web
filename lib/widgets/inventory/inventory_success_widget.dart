import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../Customs/custom_fields.dart';
import '../../Customs/custom_text.dart';
import '../../routes/routes.dart';

class WorkItemSuccessWidget extends StatelessWidget {
  final bool isInventory;
  const WorkItemSuccessWidget({Key? key, this.isInventory = true}) : super(key: key);

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
          title: ' ${isInventory ? 'Inventory' : 'Lead'} have been \n Successfully created',
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
              Navigator.of(context).pushNamed(AppRoutes.homeScreen);
            },
          ),
        )
      ],
    );
  }
}
