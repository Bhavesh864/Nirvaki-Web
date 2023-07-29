import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/pages/Auth/personal_details.dart';
import 'package:yes_broker/routes/routes.dart';
import 'package:yes_broker/widgets/auth/common_auth_widgets.dart';
import '../../Customs/custom_text.dart';
import '../../constants/utils/colors.dart';
import '../../constants/utils/image_constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final key = GlobalKey<FormState>();
  var isloading = false;

  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(vertical: 60),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(authBgImage),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black12,
                  BlendMode.darken,
                ),
              ),
            ),
            child: Center(
              child: Card(
                child: Container(
                  width: Responsive.isMobile(context) ? w * 0.9 : 500,
                  padding: const EdgeInsets.all(25),
                  child: Form(
                    key: key,
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomAppLogo(),
                        const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          child: CustomTextInput(
                            controller: emailcontroller,
                            hintText: 'Email address',
                          ),
                        ),
                        CustomTextInput(
                          controller: passwordcontroller,
                          hintText: 'Password',
                          obscureText: true,
                          rightIcon: Icons.remove_red_eye,
                        ),
                        const Text('Use a minimum of 10 characters with at-least one-special symbol and one upper case letter. '),
                        const SizedBox(height: 15),
                        CustomTextInput(
                          controller: passwordcontroller,
                          hintText: 'Re-enter Password',
                          obscureText: true,
                          rightIcon: Icons.remove_red_eye,
                        ),
                        const SizedBox(height: 10),
                        isloading
                            ? const Center(child: CircularProgressIndicator.adaptive())
                            : SizedBox(
                                width: w,
                                child: CustomButton(
                                  text: 'Sign up',
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(context, AppRoutes.personalDetails);
                                  },
                                  height: 40.0,
                                ),
                              ),
                        const SizedBox(height: 10),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CustomText(
                                title: 'Already Have an account?',
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
                                },
                                child: const CustomText(
                                  title: 'Login',
                                  color: AppColor.primary,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
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
