import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/customs/custom_fields.dart';
import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/pages/Auth/signup/personal_details.dart';

import 'package:yes_broker/riverpodstate/sign_up_state.dart';

import 'package:yes_broker/constants/validation/basic_validation.dart';
import 'package:yes_broker/routes/routes.dart';
import 'package:yes_broker/widgets/auth/common_auth_widgets.dart';
import '../../../customs/custom_text.dart';
import '../../../constants/utils/colors.dart';
import '../../../constants/utils/image_constants.dart';

final selectedItemForsignup = StateNotifierProvider<SelectedSignupItems, List<Map<String, dynamic>>>((ref) {
  return SelectedSignupItems();
});

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends ConsumerState<SignUpScreen> {
  final key = GlobalKey<FormState>();
  var isloading = false;
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode reEnteredpasswordFocusNode = FocusNode();

  String? validateReenteredPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    } else if (value != passwordcontroller.text.trim()) {
      return "Password do not match";
    }
    return null;
  }

  void navigateTopage(SelectedSignupItems notify) {
    final isvalid = key.currentState?.validate();
    if (isvalid!) {
      if (kIsWeb) {
        context.beamToNamed(AppRoutes.personalDetailsScreen);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const PersonalDetailsAuthScreen();
            },
          ),
        );
      }
    }
  }

  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController reenteredpasswordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final notify = ref.read(selectedItemForsignup.notifier);
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
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
              child: Card(
                child: SingleChildScrollView(
                  child: Container(
                    width: Responsive.isMobile(context) ? w * 0.9 : 500,
                    padding: EdgeInsets.symmetric(horizontal: Responsive.isMobile(context) ? 10 : 20, vertical: 15),
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
                                focusnode: emailFocusNode,
                                controller: emailcontroller,
                                labelText: 'Email address',
                                validator: validateEmail,
                                maxLength: 50,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context).requestFocus(passwordFocusNode);
                                },
                                onChanged: (value) {
                                  notify.add({"id": 1, "item": value.trim()});
                                }),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextInput(
                            focusnode: passwordFocusNode,
                            controller: passwordcontroller,
                            labelText: 'Password',
                            validator: validateSignupPassword,
                            obscureText: true,
                            maxLength: 30,
                            onFieldSubmitted: (value) {
                              FocusScope.of(context).requestFocus(reEnteredpasswordFocusNode);
                            },
                            // rightIcon: Icons.remove_red_eye,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            child: const Text(
                              'Use a minimum of 6 characters with at-least one-special symbol and one number. ',
                            ),
                          ),
                          const SizedBox(height: 15),
                          CustomTextInput(
                            focusnode: reEnteredpasswordFocusNode,
                            controller: reenteredpasswordcontroller,
                            labelText: 'Re-enter Password',
                            obscureText: true,
                            onChanged: (value) {
                              notify.add({"id": 2, "item": value.trim()});
                            },
                            onFieldSubmitted: (_) => navigateTopage(notify),
                            maxLength: 30,
                            rightIcon: Icons.remove_red_eye,
                            validator: validateReenteredPassword,
                          ),
                          const SizedBox(height: 10),
                          isloading
                              ? const Center(child: CircularProgressIndicator.adaptive())
                              : Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 7),
                                  width: w,
                                  child: CustomButton(
                                    text: 'Sign up',
                                    onPressed: () => navigateTopage(notify),
                                    height: 40.0,
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0, bottom: 5),
                            child: Center(
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                children: [
                                  const CustomText(
                                    title: 'Already Have an account? ',
                                    color: Colors.grey,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // if (Responsive.isMobile(context)) {
                                      //   Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
                                      // } else {
                                      context.beamToReplacementNamed(AppRoutes.loginScreen);
                                      // }
                                    },
                                    child: const CustomText(
                                      title: 'Login',
                                      color: AppColor.primary,
                                    ),
                                  ),
                                ],
                              ),
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
      ),
    );
  }
}
