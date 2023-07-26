import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/constants/firebase/userModel/broker_info.dart';
import 'package:yes_broker/routes/routes.dart';
import 'package:yes_broker/widgets/auth/common_auth_widgets.dart';
import '../../constants/utils/image_constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final key = GlobalKey<FormState>();
  var isloading = false;
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();

  void loginwithemailpassword() {
    final isvalid = key.currentState?.validate();
    if (isvalid!) {
      setState(() {
        isloading = true;
      });
      signinwithbroker(emailcontroller.text, passwordcontroller.text).then((value) => {
            if (value == 'success')
              {
                setState(() {
                  isloading = false;
                }),
                Navigator.of(context).pushReplacementNamed(AppRoutes.homeScreen)
              }
            else
              {
                setState(() {
                  isloading = false;
                }),
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value!))),
              }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: 750,
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
                          width: w,
                          child: CustomButton(
                            leftIcon: Icons.g_mobiledata_rounded,
                            text: 'Continue with Google',
                            lefticonColor: Colors.white,
                            onPressed: () {},
                          ),
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
                        const CustomOrDivider(),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextInput(
                          controller: emailcontroller,
                          hintText: 'Email address',
                          validator: (value) {
                            if (value!.isEmpty || value.length < 6) {
                              return 'Please enter email';
                            }
                            return null;
                          },
                        ),
                        // const SizedBox(height: 15),
                        CustomTextInput(
                          controller: passwordcontroller,
                          hintText: 'Password',
                          obscureText: true,
                          rightIcon: Icons.remove_red_eye,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 6) {
                              return 'Password should be atleast 6 character long';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        isloading
                            ? const Center(child: CircularProgressIndicator.adaptive())
                            : SizedBox(
                                width: w,
                                child: CustomButton(
                                  text: 'Login',
                                  onPressed: () => loginwithemailpassword(),
                                  height: 40.0,
                                ),
                              ),
                        const SizedBox(height: 10),
                        const CustomForgetPassword(),
                        const SizedBox(height: 10),
                        const CustomSignUpNow(),
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
