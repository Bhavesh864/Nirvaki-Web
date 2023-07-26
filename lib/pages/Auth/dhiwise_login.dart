import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';

class DhiwiseLoginScreen extends StatelessWidget {
  const DhiwiseLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/login_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 52),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 732,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 5),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 732,
                          width: 396,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/image1.png',
                              height: 60,
                              width: 57,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 21),
                              child: Text(
                                "Log In",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                padding: const EdgeInsets.symmetric(horizontal: 56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Image.asset('assets/images/google.png'),
                                  ),
                                  const SizedBox(width: 15),
                                  const Text("Continue with Google"),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                primary: Colors.transparent,
                                side: BorderSide(color: Colors.grey.shade300, width: 1),
                                padding: const EdgeInsets.symmetric(horizontal: 56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Image.asset('assets/images/frame1.png'),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text("Continue with Facebook"),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                primary: Colors.transparent,
                                side: BorderSide(color: Colors.grey.shade300, width: 1),
                                padding: const EdgeInsets.symmetric(horizontal: 56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Image.asset('assets/images/frame1_blue400.png'),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text("Continue with Twitter"),
                                ],
                              ),
                            ),
                            Container(
                              height: 19,
                              width: double.maxFinite,
                              margin: const EdgeInsets.only(top: 20),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: SizedBox(
                                        width: double.maxFinite,
                                        child: Divider(
                                          height: 1,
                                          thickness: 1,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      height: 16,
                                      width: 62,
                                      color: Colors.grey.shade100,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "or",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 56, top: 17),
                                child: Text(
                                  "Enter OTP",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding: EdgeInsets.only(left: 56, top: 24, right: 56),
                            //   child: PinCodeTextField(
                            //     appContext: context,
                            //     length: 6,
                            //     obscureText: false,
                            //     obscuringCharacter: '*',
                            //     keyboardType: TextInputType.number,
                            //     autoDismissKeyboard: true,
                            //     enableActiveFill: true,
                            //     inputFormatters: [
                            //       FilteringTextInputFormatter.digitsOnly,
                            //     ],
                            //     onChanged: (value) {},
                            //     textStyle: TextStyle(
                            //       color: Colors.black,
                            //       fontSize: 24,
                            //       fontWeight: FontWeight.w400,
                            //     ),
                            //     pinTheme: PinTheme(
                            //       fieldHeight: 48,
                            //       fieldWidth: 48,
                            //       shape: PinCodeFieldShape.box,
                            //       borderRadius: BorderRadius.circular(4),
                            //       selectedFillColor: Colors.white,
                            //       activeFillColor: Colors.white,
                            //       inactiveFillColor: Colors.white,
                            //       inactiveColor: Colors.indigo,
                            //       selectedColor: Colors.indigo,
                            //       activeColor: Colors.indigo,
                            //     ),
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(left: 56, top: 23, right: 56),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "02:32",
                                    style: TextStyle(
                                      color: Colors.indigo,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 44, top: 1),
                                    child: RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "I didn't receive any code.",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15,
                                            ),
                                          ),
                                          TextSpan(
                                            text: " ",
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 15,
                                            ),
                                          ),
                                          TextSpan(
                                            text: "RESEND",
                                            style: TextStyle(
                                              color: Colors.indigo,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                primary: Colors.indigo,
                                padding: const EdgeInsets.symmetric(horizontal: 56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text("Log in"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                "Forget Password?",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 19),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Don’t Have an account?",
                                      style: TextStyle(
                                        color: Colors.grey.shade900,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: " ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "Signup Now.",
                                      style: TextStyle(
                                        color: Colors.blue.shade600,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
