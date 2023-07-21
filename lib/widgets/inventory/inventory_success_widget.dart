import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../Customs/custom_fields.dart';
import '../../Customs/custom_text.dart';
import '../../routes/routes.dart';

class InventorySuccessWidget extends StatelessWidget {
  const InventorySuccessWidget({Key? key}) : super(key: key);

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
        const CustomText(
          title: ' Inventory have been \n Successfully created',
          size: 48,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: CustomButton(
            height: 40,
            width: 165,
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
