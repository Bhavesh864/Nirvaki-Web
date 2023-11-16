import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/customs/label_text_field.dart';
import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/pages/Auth/signup/sign_common_screen.dart';
import 'package:yes_broker/riverpodstate/signup/sign_up_state.dart';
import 'package:yes_broker/pages/Auth/signup/signup_screen.dart';
import 'package:yes_broker/constants/validation/basic_validation.dart';
import 'package:yes_broker/routes/routes.dart';
import 'package:yes_broker/widgets/auth/details_header.dart';
import '../../../Customs/custom_fields.dart';
import '../../../constants/utils/constants.dart';
import '../../../constants/utils/image_constants.dart';
import 'company_details.dart';
import 'country_code_modal.dart';

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
  final FocusNode firstNameFocusNode = FocusNode();
  final FocusNode lastNameFocusNode = FocusNode();
  final FocusNode mobileNumberFocusNode = FocusNode();
  final FocusNode whatsappNumberFocusNode = FocusNode();

  String selectedCountryCode = '+91';
  String whatsappCountryCode = '+91';
  bool isMobileEmpty = false;
  bool isWhatsEmpty = false;
  bool isChecked = true;

  final key = GlobalKey<FormState>();
  var isloading = false;

  void navigateTopage(SelectedSignupItems notify) {
    final isvalid = key.currentState?.validate();
    if (mobilenumbercontroller.text.trim() == "" || mobilenumbercontroller.text.length < 10) {
      setState(() {
        isMobileEmpty = true;
      });
      if (isChecked) {
        return;
      }
    } else {
      setState(() {
        isMobileEmpty = false;
      });
    }

    if (!isChecked) {
      if (whatsupnumbercontroller.text.trim() == "" || whatsupnumbercontroller.text.trim().length < 10) {
        setState(() {
          isWhatsEmpty = true;
        });
        return;
      } else {
        setState(() {
          isWhatsEmpty = false;
        });
      }
    } else {
      setState(() {
        isWhatsEmpty = false;
      });
    }
    if (isvalid!) {
      // if (kIsWeb) {
      // context.beamToNamed(AppRoutes.companyDetailsScreen);
      ref.read(changeScreenIndex.notifier).update(2);
      // } else {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) {
      //         return const CompanyDetailsAuthScreen();
      //       },
      //     ),
      //   );
      // }
    }
  }

  void openModal({bool? forMobile = true}) {
    final notify = ref.read(selectedItemForsignup.notifier);
    showDialog(
      context: context,
      builder: (context) {
        return CountryCodeModel(onCountrySelected: (data) {
          if (data.isNotEmpty) {
            if (forMobile == true) {
              setState(() {
                selectedCountryCode = data;
              });
              notify.add({"id": 5, "item": "$data ${mobilenumbercontroller.text}"});
            } else {
              setState(() {
                whatsappCountryCode = data;
              });
              notify.add({"id": 6, "item": "$data ${whatsupnumbercontroller.text}"});
            }
          }
        });
      },
    );
  }

  void setDataToTextField() {
    final editUser = ref.read(selectedItemForsignup);
    // if (isEdit) {
    if (editUser.any((element) => element["id"] == 3)) {
      firstnamecontroller.text = editUser.firstWhere((element) => element["id"] == 3)['item'] ?? "";
    }
    if (editUser.any((element) => element["id"] == 4)) {
      lastnamecontroller.text = editUser.firstWhere((element) => element["id"] == 4)['item'] ?? "";
    }
    if (editUser.any((element) => element["id"] == 5)) {
      List<String>? splitString = editUser.firstWhere((element) => element["id"] == 5)["item"].split(' ');
      if (splitString!.length == 1) {
        mobilenumbercontroller.text = splitString[0];
      }
      if (splitString.length == 2) {
        selectedCountryCode = splitString[0];
        mobilenumbercontroller.text = splitString[1];
      }
    }
    if (editUser.any((element) => element["id"] == 6)) {
      List<String>? splitString = editUser.firstWhere((element) => element["id"] == 6)["item"].split(' ');
      if (splitString!.length == 1) {
        whatsupnumbercontroller.text = splitString[0];
      }
      if (splitString.length == 2) {
        whatsappCountryCode = splitString[0];
        whatsupnumbercontroller.text = splitString[1];
      }
    }
  }

  @override
  void initState() {
    setDataToTextField();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final notify = ref.read(selectedItemForsignup.notifier);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppText(
              text: 'Welcome to Nirvaki',
              textColor: Colors.white,
              fontsize: Responsive.isMobile(context) ? 20 : 23,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 20),
            Card(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              "Let Us Know You Better",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Responsive.isMobile(context) ? 18 : 24,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          LabelTextInputField(
                            focusNode: firstNameFocusNode,
                            labelText: 'First Name',
                            isMandatory: true,
                            maxLength: 30,
                            inputController: firstnamecontroller,
                            validator: (value) => validateForNameField(props: "First Name", value: value!.trim()),
                            onFieldSubmitted: (value) {
                              FocusScope.of(context).requestFocus(lastNameFocusNode);
                            },
                            onChanged: (value) {
                              notify.add({"id": 3, "item": removeExtraSpaces(value)});
                            },
                          ),
                          LabelTextInputField(
                            focusNode: lastNameFocusNode,
                            labelText: 'Last Name',
                            maxLength: 30,
                            isMandatory: true,
                            inputController: lastnamecontroller,
                            validator: (value) => validateForNameField(props: "Last Name", value: value!.trim()),
                            onFieldSubmitted: (value) {
                              FocusScope.of(context).requestFocus(mobileNumberFocusNode);
                            },
                            onChanged: (value) {
                              notify.add({"id": 4, "item": removeExtraSpaces(value)});
                            },
                          ),
                          // CustomTextInput(
                          //   onlyDigits: true,
                          //   labelText: 'Mobile',
                          //   controller: mobilenumbercontroller,
                          //   validator: (value) => validateForMobileNumberFeild(value: value, props: "Mobile Number"),
                          //   onChanged: (value) {
                          //     notify.add({"id": 5, "item": value.trim()});
                          //   },
                          //   leftIcon: Icons.abc_sharp,
                          // ),
                          MobileNumberInputField(
                            fromProfile: true,
                            focusNode: mobileNumberFocusNode,
                            onFieldSubmitted: (value) {
                              if (!isChecked) {
                                FocusScope.of(context).requestFocus(whatsappNumberFocusNode);
                              } else {
                                navigateTopage(notify);
                              }
                            },
                            controller: mobilenumbercontroller,
                            hintText: 'Mobile Number',
                            isEmpty: isMobileEmpty,
                            openModal: openModal,
                            countryCode: selectedCountryCode,
                            onChange: (value) {
                              notify.add({"id": 5, "item": "$selectedCountryCode ${value.trim()}"});
                            },
                          ),
                          if (isMobileEmpty)
                            const Padding(
                              padding: EdgeInsets.only(left: 15.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: AppText(
                                  text: 'Please enter Mobile Number',
                                  textColor: Colors.red,
                                  fontsize: 12,
                                ),
                              ),
                            ),
                          CustomCheckbox(
                            value: isChecked,
                            label: 'Use Same Number For Whatsapp',
                            onChanged: (value) {
                              setState(() {
                                isChecked = value;
                              });
                            },
                          ),
                          if (!isChecked) ...[
                            MobileNumberInputField(
                              fromProfile: true,
                              focusNode: whatsappNumberFocusNode,
                              onFieldSubmitted: (value) {
                                if (!isChecked) {
                                  navigateTopage(notify);
                                }
                              },
                              controller: whatsupnumbercontroller,
                              hintText: 'Whatsapp Number',
                              isEmpty: isWhatsEmpty,
                              openModal: () {
                                openModal(forMobile: false);
                              },
                              countryCode: whatsappCountryCode,
                              onChange: (value) {
                                notify.add({"id": 6, "item": "$whatsappCountryCode ${value.trim()}"});
                              },
                            ),
                          ],
                          if (!isChecked && isWhatsEmpty)
                            const Padding(
                              padding: EdgeInsets.only(left: 15.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: AppText(
                                  text: 'Please enter Whatsapp Number',
                                  textColor: Colors.red,
                                  fontsize: 12,
                                ),
                              ),
                            ),
                          // CustomTextInput(
                          //   labelText: 'Whatsapp Number',
                          //   controller: whatsupnumbercontroller,
                          //   validator: !isChecked ? (value) => validateForMobileNumberFeild(value: value, props: "Whatsapp Number") : null,
                          //   onChanged: (value) {
                          //     notify.add({"id": 6, "item": value.trim()});
                          //   },
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                margin: const EdgeInsets.only(top: 20),
                                alignment: Alignment.centerLeft,
                                child: CustomButton(
                                  text: 'Back',
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w700,
                                  onPressed: () {
                                    ref.read(changeScreenIndex.notifier).update(0);
                                  },
                                  width: 73,
                                  height: 39,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 10,
                                ),
                                alignment: Alignment.centerRight,
                                child: CustomButton(
                                  text: 'Next',
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                  onPressed: () => navigateTopage(notify),
                                  width: 73,
                                  height: 39,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
