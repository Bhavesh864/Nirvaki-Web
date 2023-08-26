import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/customs/custom_fields.dart';

import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/riverpodstate/sign_up_state.dart';
import 'package:yes_broker/pages/Auth/signup/signup_screen.dart';
import 'package:yes_broker/constants/validation/basic_validation.dart';

import 'package:yes_broker/routes/routes.dart';

import 'package:yes_broker/widgets/auth/details_header.dart';
import '../../../constants/utils/constants.dart';
import '../../../constants/utils/image_constants.dart';

class PersonalDetailsAuthScreen extends ConsumerStatefulWidget {
  const PersonalDetailsAuthScreen({super.key});
  @override
  PersonalDetailsAuthScreenState createState() => PersonalDetailsAuthScreenState();
}

class PersonalDetailsAuthScreenState extends ConsumerState<PersonalDetailsAuthScreen> {
  final TextEditingController firstnamecontroller = TextEditingController();
  final TextEditingController lastnamecontroller = TextEditingController();
  final TextEditingController mobilenumbercontroller = TextEditingController();
  final TextEditingController whatsupnumbercontroller = TextEditingController();

  bool isChecked = true;
  final key = GlobalKey<FormState>();
  var isloading = false;
  void navigateTopage(SelectedSignupItems notify) {
    final isvalid = key.currentState?.validate();
    if (isvalid!) {
      // if (Responsive.isMobile(context)) {
      //   Navigator.pushNamed(context, AppRoutes.companyDetailsScreen);
      // } else {
      context.beamToNamed(AppRoutes.companyDetailsScreen);
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    final notify = ref.read(selectedItemForsignup.notifier);
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
                            CustomTextInput(
                              labelText: 'First Name',
                              controller: firstnamecontroller,
                              validator: (value) => validateForNormalFeild(props: "First Name", value: value),
                              onChanged: (value) {
                                notify.add({"id": 3, "item": value.trim()});
                              },
                            ),
                            CustomTextInput(
                              labelText: 'Last Name',
                              controller: lastnamecontroller,
                              validator: (value) => validateForNormalFeild(props: "Last Name", value: value),
                              onChanged: (value) {
                                notify.add({"id": 4, "item": value.trim()});
                              },
                            ),
                            CustomTextInput(
                              labelText: 'Mobile',
                              controller: mobilenumbercontroller,
                              validator: (value) => validateForMobileNumberFeild(value: value, props: "Mobile Number"),
                              onChanged: (value) {
                                notify.add({"id": 5, "item": value.trim()});
                              },
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
                            if (!isChecked)
                              CustomTextInput(
                                labelText: 'Whatsapp Number',
                                controller: whatsupnumbercontroller,
                                validator: !isChecked ? (value) => validateForMobileNumberFeild(value: value, props: "Whatsapp Number") : null,
                                onChanged: (value) {
                                  notify.add({"id": 6, "item": value.trim()});
                                },
                              ),
                            Container(
                              margin: const EdgeInsets.only(top: 10, bottom: 10),
                              alignment: Alignment.centerRight,
                              child: CustomButton(
                                text: 'Next',
                                onPressed: () => navigateTopage(notify),
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
