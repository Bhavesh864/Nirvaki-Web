import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/Customs/label_text_field.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/routes/routes.dart';
import '../../constants/utils/constants.dart';
import '../../constants/utils/image_constants.dart';
import '../../widgets/auth/details_header.dart';

class CompanyDetailsAuthScreen extends StatefulWidget {
  const CompanyDetailsAuthScreen({super.key});
  @override
  State<CompanyDetailsAuthScreen> createState() => _CompanyDetailsAuthScreenState();
}

class _CompanyDetailsAuthScreenState extends State<CompanyDetailsAuthScreen> {
  bool isChecked = true;
  final key = GlobalKey<FormState>();
  var isloading = false;

  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(vertical: 0),
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
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  constraints: BoxConstraints(
                    minHeight: 0,
                    maxHeight: Responsive.isMobile(context) ? height! * 0.8 : height! * 1,
                  ),
                  width: Responsive.isMobile(context) ? width! * 0.9 : 600,
                  child: Form(
                    key: key,
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const DetailsHeaderWidget(isPersonalDetails: false),
                            const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                "Tell us about your company...",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            LabelTextInputField(
                              labelText: 'Company Name',
                              inputController: TextEditingController(),
                            ),
                            LabelTextInputField(
                              labelText: 'Mobile',
                              inputController: TextEditingController(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: CustomCheckbox(
                                value: isChecked,
                                label: 'Use this as whatsapp number',
                                onChanged: (value) {
                                  setState(() {
                                    isChecked = value;
                                  });
                                },
                              ),
                            ),
                            LabelTextInputField(
                              labelText: 'Whatsapp Number',
                              inputController: TextEditingController(),
                            ),
                            LabelTextInputField(
                              labelText: 'Address',
                              inputController: TextEditingController(),
                            ),
                            LabelTextInputField(
                              labelText: 'Register As',
                              inputController: TextEditingController(),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10, bottom: 10),
                              alignment: Alignment.centerRight,
                              child: CustomButton(
                                text: 'Save',
                                onPressed: () {
                                  Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
                                },
                                width: 73,
                                height: 39,
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
      ),
    );
  }
}
