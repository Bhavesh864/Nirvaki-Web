import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/Customs/responsive.dart';

import 'package:yes_broker/riverpodstate/sign_up_state.dart';

import 'package:yes_broker/constants/validation/basic_validation.dart';
import 'package:yes_broker/routes/routes.dart';
import 'package:yes_broker/widgets/auth/common_auth_widgets.dart';
import '../../../Customs/custom_text.dart';
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

  String? validateReenteredPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    } else if (value != passwordcontroller.text) {
      return "Password do not match";
    }
    return null;
  }

  void navigateTopage(SelectedSignupItems notify) {
    final isvalid = key.currentState?.validate();
    if (isvalid!) {
      if (Responsive.isMobile(context)) {
        Navigator.pushNamed(context, AppRoutes.personalDetailsScreen);
      } else {
        context.beamToNamed(AppRoutes.personalDetailsScreen);
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
                              labelText: 'Email address',
                              validator: validateEmail,
                              onChanged: (value) {
                                notify.add({"id": 1, "item": value.trim()});
                              }),
                        ),
                        CustomTextInput(
                          controller: passwordcontroller,
                          labelText: 'Password',
                          validator: validatePassword,
                          obscureText: true,
                          // rightIcon: Icons.remove_red_eye,
                        ),
                        const Text('Use a minimum of 10 characters with at-least one-special symbol and one upper case letter. '),
                        const SizedBox(height: 15),
                        CustomTextInput(
                            controller: reenteredpasswordcontroller,
                            labelText: 'Re-enter Password',
                            obscureText: true,
                            onChanged: (value) {
                              notify.add({"id": 2, "item": value.trim()});
                            },
                            rightIcon: Icons.remove_red_eye,
                            validator: validateReenteredPassword),
                        const SizedBox(height: 10),
                        isloading
                            ? const Center(child: CircularProgressIndicator.adaptive())
                            : SizedBox(
                                width: w,
                                child: CustomButton(
                                  text: 'Sign up',
                                  onPressed: () => navigateTopage(notify),
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
                                  if (Responsive.isMobile(context)) {
                                    Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
                                  } else {
                                    context.beamToNamed(AppRoutes.loginScreen);
                                  }
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
