import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/routes/routes.dart';
import '../../constants/utils/image_constants.dart';

class CustomAuthCard extends StatelessWidget {
  final Widget child;
  const CustomAuthCard({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}

class CustomAppLogo extends StatelessWidget {
  const CustomAppLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Image.asset(
        appLogo,
        width: 60,
        height: 60,
      ),
    );
  }
}

class CustomOrDivider extends StatelessWidget {
  const CustomOrDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.only(bottom: 6),
      margin: const EdgeInsets.only(top: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: double.maxFinite,
              child: Divider(
                height: 1,
                thickness: 1.5,
                color: Colors.grey.shade400,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 16,
              width: 40,
              color: Colors.white,
            ),
          ),
          const Align(
            alignment: Alignment.topCenter,
            child: Text(
              "or",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomForgetPassword extends StatelessWidget {
  const CustomForgetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(AppRoutes.forgetPassword);
        },
        child: const CustomText(
          title: 'Forget password?',
          size: 14,
        ),
      ),
    );
  }
}

class CustomSignUpNow extends StatelessWidget {
  const CustomSignUpNow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            title: 'Don’t Have an account?',
            color: Colors.grey,
          ),
          SizedBox(
            width: 10,
          ),
          CustomText(
            title: 'Signup Now.',
            color: AppColor.primary,
          ),
        ],
      ),
    );
  }
}
