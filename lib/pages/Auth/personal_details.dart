import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/Customs/label_text_field.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/routes/routes.dart';
import 'package:yes_broker/widgets/auth/details_header.dart';
import '../../constants/utils/constants.dart';
import '../../constants/utils/image_constants.dart';

class PersonalDetailsAuthScreen extends StatefulWidget {
  const PersonalDetailsAuthScreen({super.key});
  @override
  State<PersonalDetailsAuthScreen> createState() => _PersonalDetailsAuthScreenState();
}

class _PersonalDetailsAuthScreenState extends State<PersonalDetailsAuthScreen> {
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
            // padding: const EdgeInsets.symmetric(vertical: 0),
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
                    maxHeight: Responsive.isMobile(context) ? height! * 0.8 : height! * 0.88,
                  ),
                  width: Responsive.isMobile(context) ? width! * 0.9 : 600,
                  child: Form(
                    key: key,
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const DetailsHeaderWidget(isPersonalDetails: true),
                            const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                "Let us know you better..",
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
                              labelText: 'First Name',
                              inputController: TextEditingController(),
                            ),
                            LabelTextInputField(
                              labelText: 'Last Name',
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
                                text: 'Next',
                                onPressed: () {
                                  Navigator.pushReplacementNamed(context, AppRoutes.companyDetails);
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
