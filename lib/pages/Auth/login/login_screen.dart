import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/customs/custom_fields.dart';
import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/customs/snackbar.dart';
import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/constants/validation/basic_validation.dart';
import 'package:yes_broker/routes/routes.dart';
import 'package:yes_broker/widgets/auth/common_auth_widgets.dart';
import '../../../constants/firebase/Methods/sign_in_method.dart';
import '../../../constants/utils/image_constants.dart';
import '../signup/signup_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  final key = GlobalKey<FormState>();
  var isloading = false;
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();

  void loginwithemailpassword(BuildContext context) {
    FocusScope.of(context).unfocus();
    final isvalid = key.currentState?.validate();
    if (isvalid!) {
      setState(() {
        isloading = true;
      });
      signinMethod(email: emailcontroller.text.trim(), password: passwordcontroller.text.trim(), ref: ref).then((value) => {
            if (value == 'success')
              {
                // if (auth.currentUser?.emailVerified == true)
                //   {
                User.updateFcmToken(fcmtoken: AppConst.getFcmToken(), userid: AppConst.getAccessToken()),
                AppConst.setPublicView(false),
                // }
                // else
                //   {
                //     setState(() {
                //       isloading = false;
                //     }),
                //     customSnackBar(context: context, text: 'Please verify your email address.')
                //   }
              }
            else
              {
                setState(() {
                  isloading = false;
                }),
                customSnackBar(context: context, text: value!)
              }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Container(
          // padding: const EdgeInsets.symmetric(vertical: 30),
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
                      children: [
                        const CustomAppLogo(),
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            "Log In",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   width: w,
                        //   child: CustomButton(
                        //     leftIcon: Icons.g_mobiledata_rounded,
                        //     text: 'Continue with Google',
                        //     lefticonColor: Colors.white,
                        //     onPressed: () {},
                        //   ),
                        // ),
                        // const SizedBox(height: 10),
                        // SizedBox(
                        //   width: w,
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
                        //   width: w,
                        //   child: CustomButton(
                        //       leftIcon: Icons.apple,
                        //       text: 'Continue with apple',
                        //       buttonColor: Colors.white,
                        //       textColor: Colors.black,
                        //       lefticonColor: Colors.black,
                        //       onPressed: () {}),
                        // ),
                        // const SizedBox(height: 10),
                        // const CustomOrDivider(),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomTextInput(
                          focusnode: emailFocusNode,
                          controller: emailcontroller,
                          isDense: true,
                          labelText: 'Email Address',
                          validator: (val) => validateEmail(val?.trim()),
                          autofillHints: const [AutofillHints.email],
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(passwordFocusNode);
                          },
                          maxLength: 50,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextInput(
                          focusnode: passwordFocusNode,
                          controller: passwordcontroller,
                          isDense: true,
                          labelText: 'Password',
                          obscureText: true,
                          rightIcon: Icons.remove_red_eye_outlined,
                          validator: validatePassword,
                          onFieldSubmitted: (_) => loginwithemailpassword(context),
                          maxLength: 30,
                        ),
                        const SizedBox(height: 15),
                        isloading
                            ? const Center(child: CircularProgressIndicator.adaptive())
                            : Container(
                                margin: const EdgeInsets.symmetric(horizontal: 7),
                                width: w,
                                child: CustomButton(
                                  key: const Key("loginButton"),
                                  text: 'Login',
                                  onPressed: () {
                                    loginwithemailpassword(context);
                                  },
                                  height: 40.0,
                                ),
                              ),
                        const SizedBox(height: 20),
                        const CustomForgetPassword(),
                        const SizedBox(height: 15),
                        CustomSignUpNow(
                          onPressSignUp: () {
                            ref.read(selectedItemForsignup.notifier).emptyAllFields();
                            context.beamToNamed(AppRoutes.singupscreen);
                          },
                        ),
                        const SizedBox(height: 10),
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
