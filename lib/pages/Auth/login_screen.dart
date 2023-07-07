import 'package:flutter/material.dart';
import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/constants/colors.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/constants/constants.dart';
import 'package:yes_broker/pages/Auth/forget_password.dart';
import 'package:yes_broker/TabScreens/main_screens/home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    // final h = MediaQuery.of(context).size.height;
    final TextEditingController emailcontroller = TextEditingController();
    final TextEditingController passwordcontroller = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: 800,
            padding: const EdgeInsets.symmetric(vertical: 60),
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
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                    width: Responsive.isMobile(context) ? w * 0.9 : 500,
                    // height: h / 1.2,
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      children: [
                        SizedBox(
                          child: Image.asset(
                            appLogo,
                            width: 60,
                            height: 60,
                          ),
                        ),
                        const SizedBox(height: 25),
                        SizedBox(
                          width: w,
                          child: CustomButton(
                              leftIcon: Icons.g_mobiledata,
                              text: 'Continue with Google',
                              lefticonColor: Colors.white,
                              onPressed: () {}),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: w,
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
                          width: w,
                          child: CustomButton(
                              leftIcon: Icons.apple,
                              text: 'Continue with apple',
                              buttonColor: Colors.white,
                              textColor: Colors.black,
                              lefticonColor: Colors.black,
                              onPressed: () {}),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width:
                                  Responsive.isMobile(context) ? w * 0.2 : 150,
                              height: 1,
                              color: Colors.grey,
                            ),
                            const CustomText(
                              title: 'or',
                              size: 13,
                              color: Colors.grey,
                            ),
                            Container(
                              width:
                                  Responsive.isMobile(context) ? w * 0.2 : 150,
                              height: 1,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: w,
                          child: CustomTextInput(
                              controller: emailcontroller,
                              hintText: 'Email address'),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: w,
                          child: CustomTextInput(
                            controller: passwordcontroller,
                            hintText: 'Password',
                            obscureText: true,
                            rightIcon: Icons.remove_red_eye,
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: w,
                          child: CustomButton(
                            text: 'Login',
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(HomeScreen.routeName);
                            },
                            height: 40.0,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(ForgetPassword.routeName);
                            },
                            child: const CustomText(
                              title: 'Forget password?',
                              size: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Center(
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
                        )
                      ],
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
