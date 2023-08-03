import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/Customs/label_text_field.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/pages/Auth/signup/sign_up_state.dart';
import 'package:yes_broker/pages/Auth/validation/basic_validation.dart';
import 'package:yes_broker/routes/routes.dart';
import '../../../Customs/dropdown_field.dart';
import '../../../constants/utils/constants.dart';
import '../../../constants/utils/image_constants.dart';
import '../../../widgets/auth/details_header.dart';

class CompanyDetailsAuthScreen extends StatefulWidget {
  const CompanyDetailsAuthScreen({super.key});
  @override
  State<CompanyDetailsAuthScreen> createState() => _CompanyDetailsAuthScreenState();
}

class _CompanyDetailsAuthScreenState extends State<CompanyDetailsAuthScreen> {
  bool isChecked = true;
  final key = GlobalKey<FormState>();
  var isloading = false;
  void navigateTopage() {
    final isvalid = key.currentState?.validate();
    if (isvalid!) {
      // Navigator.pushNamed(context, AppRoutes.companyDetails, arguments: notify);
    }
  }

  final List<String> dropdownitem = ["Broker", "Builder"];
  final TextEditingController companynamecontroller = TextEditingController();
  final TextEditingController mobilenumbercontroller = TextEditingController();
  final TextEditingController whatsupnumbercontroller = TextEditingController();
  final TextEditingController address1controller = TextEditingController();
  final TextEditingController address2controller = TextEditingController();
  final TextEditingController statecontroller = TextEditingController();
  final TextEditingController citycontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final SelectedSignupItems notify = ModalRoute.of(context)?.settings.arguments as SelectedSignupItems;
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
                            CustomTextInput(
                              labelText: 'Company Name',
                              controller: companynamecontroller,
                              validator: (value) => validateForNormalFeild(value: value, props: "Company Name"),
                              onChanged: (value) {
                                notify.add({"id": 7, "item": value.trim()});
                              },
                            ),
                            CustomTextInput(
                              labelText: 'Mobile',
                              controller: mobilenumbercontroller,
                              validator: (value) => validateForMobileNumberFeild(value: value, props: "Mobile Number"),
                              onChanged: (value) {
                                notify.add({"id": 8, "item": value.trim()});
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
                                  notify.add({"id": 9, "item": value.trim()});
                                },
                              ),
                            CustomTextInput(
                              labelText: 'Address',
                              controller: address1controller,
                              validator: (value) => validateForNormalFeild(value: value, props: "Address"),
                              onChanged: (value) {
                                notify.add({"id": 10, "item": value.trim()});
                              },
                            ),
                            DropDownField(
                                title: "State",
                                optionsList: const ["Rajasthan"],
                                onchanged: (value) {
                                  notify.add({"id": 11, "item": value});
                                }),
                            DropDownField(
                                title: "City",
                                optionsList: const ["Jaipur", "Bikaner"],
                                onchanged: (value) {
                                  notify.add({"id": 12, "item": value});
                                }),
                            DropDownField(
                                title: "Register As",
                                optionsList: dropdownitem,
                                onchanged: (value) {
                                  notify.add({"id": 13, "item": value});
                                }),
                            Container(
                              margin: const EdgeInsets.only(top: 10, bottom: 10),
                              alignment: Alignment.centerRight,
                              child: CustomButton(
                                text: 'Save',
                                onPressed: navigateTopage,
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
