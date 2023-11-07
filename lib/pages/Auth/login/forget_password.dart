import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/Customs/snackbar.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/constants/validation/basic_validation.dart';
import '../../../constants/utils/image_constants.dart';
import '../../../widgets/auth/common_auth_widgets.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController emailcontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(authBgImage),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black26,
                  BlendMode.darken,
                ),
              ),
            ),
            child: Center(
              child: CustomAuthCard(
                child: SingleChildScrollView(
                  child: Container(
                    width: Responsive.isMobile(context) ? screenWidth * 0.9 : 500,
                    // height: screenHeight / 1.2,

                    // constraints: const BoxConstraints(
                    //   minHeight: 0,
                    //   maxHeight: double.infinity,
                    // ),
                    padding: EdgeInsets.all(Responsive.isMobile(context) ? 10 : 20),
                    child: Form(
                      key: formkey,
                      child: Column(
                        children: [
                          const CustomAppLogo(),
                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "Reset Password",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // SizedBox(
                          //   width: screenWidth,
                          //   child: CustomButton(
                          //     leftIcon: Icons.g_mobiledata,
                          //     text: 'Continue with Google',
                          //     lefticonColor: Colors.white,
                          //     onPressed: () {},
                          //   ),
                          // ),
                          // const SizedBox(height: 10),
                          // SizedBox(
                          //   width: screenWidth,
                          //   child: CustomButton(
                          //       leftIcon: Icons.facebook_sharp,
                          //       text: 'Continue with facebook',
                          //       buttonColor: Colors.white,
                          //       lefticonColor: Colors.blue,
                          //       textColor: Colors.black,
                          //       onPressed: () {}),
                          // ),
                          // const SizedBox(height: 10),
                          // SizedBox(
                          //   width: screenHeight,
                          //   child: CustomButton(
                          //       leftIcon: Icons.apple, text: 'Continue with apple', buttonColor: Colors.white, textColor: Colors.black, lefticonColor: Colors.black, onPressed: () {}),
                          // ),
                          // const SizedBox(height: 30),
                          // const CustomOrDivider(),
                          // const SizedBox(
                          //   height: 20,
                          // ),
                          SizedBox(
                            width: screenWidth,
                            child: CustomTextInput(
                              controller: emailcontroller,
                              hintText: 'Email address',
                              keyboardType: TextInputType.emailAddress,
                              validator: validateEmail,
                              maxLength: 50,
                            ),
                          ),
                          // const SizedBox(height: 15),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 15),
                            width: screenHeight,
                            child: CustomButton(
                              text: 'Reset',
                              onPressed: () {
                                if (formkey.currentState!.validate()) {
                                  User.resetPassword(emailcontroller.text).then((value) => {
                                        if (value == "success")
                                          {
                                            FocusScope.of(context).unfocus(),
                                            customSnackBar(context: context, text: "Password Reset Link Send Via Email ${emailcontroller.text}"),
                                            Navigator.of(context).pop(),
                                          }
                                        else
                                          {customSnackBar(context: context, text: value)}
                                      });
                                }
                              },
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
        ),
      ),
    );
  }
}
