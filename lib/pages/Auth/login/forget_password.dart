import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/Customs/responsive.dart';
import '../../../constants/utils/image_constants.dart';
import '../../../widgets/auth/common_auth_widgets.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final TextEditingController emailcontroller = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: 760,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(authBgImage),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black38,
                  BlendMode.darken,
                ),
              ),
            ),
            child: Center(
              child: CustomAuthCard(
                child: Container(
                  width: Responsive.isMobile(context) ? screenWidth * 0.9 : 500,
                  height: screenHeight / 1.2,

                  // constraints: const BoxConstraints(
                  //   minHeight: 0,
                  //   maxHeight: double.infinity,
                  // ),
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    children: [
                      const CustomAppLogo(),
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "Log In",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: screenWidth,
                        child: CustomButton(
                          leftIcon: Icons.g_mobiledata,
                          text: 'Continue with Google',
                          lefticonColor: Colors.white,
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: screenWidth,
                        child: CustomButton(
                            leftIcon: Icons.facebook_sharp,
                            text: 'Continue with facebook',
                            buttonColor: Colors.white,
                            lefticonColor: Colors.blue,
                            textColor: Colors.black,
                            onPressed: () {}),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: screenHeight,
                        child: CustomButton(
                            leftIcon: Icons.apple, text: 'Continue with apple', buttonColor: Colors.white, textColor: Colors.black, lefticonColor: Colors.black, onPressed: () {}),
                      ),
                      const SizedBox(height: 30),
                      const CustomOrDivider(),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: screenWidth,
                        child: CustomTextInput(
                          controller: emailcontroller,
                          hintText: 'Email address/ Phone number',
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: screenHeight,
                        child: CustomButton(
                          text: 'Reset',
                          onPressed: () {},
                          height: 40.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
