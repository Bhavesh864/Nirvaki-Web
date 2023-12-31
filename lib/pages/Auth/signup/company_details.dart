// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'package:yes_broker/Customs/label_text_field.dart';
import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/firebase/google_places_model.dart';
import 'package:yes_broker/constants/validation/basic_validation.dart';
import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/customs/snackbar.dart';
import 'package:yes_broker/pages/Auth/signup/signup_screen.dart';
import 'package:yes_broker/riverpodstate/signup/sign_up_state.dart';
import 'package:yes_broker/screens/account_screens/profile_screen.dart';

import '../../../Customs/custom_fields.dart';
import '../../../constants/utils/constants.dart';
import '../../../customs/dropdown_field.dart';
import '../../../widgets/auth/details_header.dart';
import 'country_code_modal.dart';

class CompanyDetailsAuthScreen extends ConsumerStatefulWidget {
  final Function goToNextScreen;
  final Function goToPreviousScreen;

  const CompanyDetailsAuthScreen({
    super.key,
    required this.goToNextScreen,
    required this.goToPreviousScreen,
  });
  @override
  CompanyDetailsAuthScreenState createState() => CompanyDetailsAuthScreenState();
}

class CompanyDetailsAuthScreenState extends ConsumerState<CompanyDetailsAuthScreen> {
  bool isChecked = true;
  final key = GlobalKey<FormState>();
  var isloading = false;
  TextEditingController controller = TextEditingController();
  final FocusNode companyNameFocusNode = FocusNode();
  final FocusNode logoFocusNode = FocusNode();
  final FocusNode mobileNumberFocusNode = FocusNode();
  final FocusNode whatsappNumberFocusNode = FocusNode();
  final FocusNode locationFocusNode = FocusNode();
  final FocusNode address1FocusNode = FocusNode();
  final FocusNode address2FocusNode = FocusNode();
  final FocusNode registerAsFocusNode = FocusNode();

  void submitSignupForm(SelectedSignupItems notify) {
    final isvalid = key.currentState?.validate();
    if (mobilenumbercontroller.text.trim().isEmpty && mobilenumbercontroller.text.trim().length < 10) {
      setState(() {
        isMobileEmpty = true;
      });
      return;
    } else {
      setState(() {
        isMobileEmpty = false;
      });
    }
    if (whatsupnumbercontroller.text == "" && !isChecked && whatsupnumbercontroller.text.trim().length < 10) {
      setState(() {
        isWhatsappEmpty = true;
      });
      return;
    } else {
      setState(() {
        isWhatsappEmpty = false;
      });
    }
    if (isvalid!) {
      setState(() {
        isloading = true;
      });
      notify.signup().then((value) => {
            if (value == 'success')
              {
                setState(() {
                  isloading = false;
                }),
                Beamer.of(context).beamToReplacementNamed('/login'),
                // context.beamToReplacementNamed('/'),
                customSnackBar(context: context, text: "Verification email sent. Please check your inbox to verify your email"),
              }
            else
              {
                setState(() {
                  isloading = false;
                }),
                customSnackBar(context: context, text: value!),
              }
          });
    }
  }

  selectImage() async {
    XFile? pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 60,
    );

    var webUrl = await pickedImage!.readAsBytes();
    var imageUrl = File(pickedImage.path);

    if (!kIsWeb) {
      if (imageUrl.lengthSync() <= 1048576) {
        setState(() {
          uploadLogocontroller.text = pickedImage.name;
        });
        return imageUrl;
      } else {
        return 'Image size should not exceeds 1 MB';
      }
    } else {
      if (webUrl.length <= 1048576) {
        setState(() {
          uploadLogocontroller.text = pickedImage.name;
        });
        return webUrl;
      } else {
        return 'Image size should not exceeds 1 MB';
      }
    }
  }

  final List<String> dropdownitem = ["Broker", "Builder"];
  List<String> citiesList = [];
  String selectedCity = '';
  String selectedState = '';
  String? registerAs;
  final TextEditingController companynamecontroller = TextEditingController();
  final TextEditingController mobilenumbercontroller = TextEditingController();
  final TextEditingController whatsupnumbercontroller = TextEditingController();
  final TextEditingController address1controller = TextEditingController();
  final TextEditingController address2controller = TextEditingController();
  TextEditingController statecontroller = TextEditingController();
  final TextEditingController citycontroller = TextEditingController();
  final TextEditingController uploadLogocontroller = TextEditingController();
  List placesList = [];
  String selectedCountryCode = '+91';
  String selectedwhatsappCountryCode = '+91';
  bool isMobileEmpty = false;
  bool isWhatsappEmpty = false;

  void openModal(bool isMobile) {
    final notify = ref.read(selectedItemForsignup.notifier);
    showDialog(
      context: context,
      builder: (context) {
        return CountryCodeModel(onCountrySelected: (data) {
          if (data.isNotEmpty) {
            if (isMobile) {
              setState(() {
                selectedCountryCode = data;
              });
              notify.add({"id": 8, "item": "$data ${mobilenumbercontroller.text}"});
            } else {
              setState(() {
                selectedwhatsappCountryCode = data;
              });
              notify.add({"id": 9, "item": "$data ${whatsupnumbercontroller.text}"});
            }
          }
        });
      },
    );
  }

  void setDataToTextField() {
    final editUser = ref.read(selectedItemForsignup);
    // if (isEdit) {
    if (editUser.any((element) => element["id"] == 7)) {
      companynamecontroller.text = editUser.firstWhere((element) => element["id"] == 7)['item'] ?? "";
    }
    if (editUser.any((element) => element["id"] == 14)) {
      uploadLogocontroller.text = editUser.firstWhere((element) => element["id"] == 14)['item'] ?? "";
    }
    if (editUser.any((element) => element["id"] == 8)) {
      List<String>? splitString = editUser.firstWhere((element) => element["id"] == 8)["item"].split(' ');
      if (splitString!.length == 1) {
        mobilenumbercontroller.text = splitString[0];
      }
      if (splitString.length == 2) {
        selectedCountryCode = splitString[0];
        mobilenumbercontroller.text = splitString[1];
      }
    }
    if (editUser.any((element) => element["id"] == 9)) {
      List<String>? splitString = editUser.firstWhere((element) => element["id"] == 9)["item"].split(' ');
      if (splitString!.length == 1) {
        whatsupnumbercontroller.text = splitString[0];
      }
      if (splitString.length == 2) {
        selectedwhatsappCountryCode = splitString[0];
        whatsupnumbercontroller.text = splitString[1];
      }
    }
    if (editUser.any((element) => element["id"] == 11)) {
      address1controller.text = editUser.firstWhere((element) => element["id"] == 11)['item'] ?? "";
    }
    if (editUser.any((element) => element["id"] == 15)) {
      address2controller.text = editUser.firstWhere((element) => element["id"] == 15)['item'] ?? "";
    }
    if (editUser.any((element) => element["id"] == 13)) {
      registerAs = editUser.firstWhere((element) => element["id"] == 13)['item'] ?? "";
    }
    if (editUser.any((element) => element["id"] == 16)) {
      statecontroller.text = editUser.firstWhere((element) => element["id"] == 16)['item'] ?? "";
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
        child: Card(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                      const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: DetailsHeaderWidget(isPersonalDetails: false),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "Tell Us About Your Company",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: Responsive.isMobile(context) ? 18 : 24,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      LabelTextInputField(
                        // margin: const EdgeInsets.all(7),
                        focusNode: companyNameFocusNode,
                        labelText: 'Company Name',
                        isMandatory: true,
                        maxLength: 100,
                        inputController: companynamecontroller,
                        validator: (value) => validateForNormalFeild(value: value, props: "Company Name"),
                        onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(logoFocusNode),
                        onChanged: (value) {
                          notify.add({"id": 7, "item": value.trim()});
                        },
                      ),
                      LabelTextInputField(
                        focusNode: logoFocusNode,
                        inputController: uploadLogocontroller,
                        validator: (value) => validateLogoField(value: value, props: 'company logo'),
                        onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(mobileNumberFocusNode),
                        isMandatory: true,
                        readyOnly: true,
                        labelText: "Upload Logo",
                        rightIcon: Icons.publish,
                        isDatePicker: true,
                        onTap: () {
                          selectImage().then((value) => {
                                if (!value.contains('Image size'))
                                  {
                                    uploadImageToFirebases(value).then((url) {
                                      if (url != "") {
                                        final notify = ref.read(selectedItemForsignup.notifier);
                                        notify.add({"id": 14, "item": url});
                                      }
                                    })
                                  }
                                else
                                  {customSnackBar(context: context, text: value.toString())}
                              });
                        },
                      ),
                      // CustomTextInput(
                      //   margin: const EdgeInsets.all(7),
                      //   labelText: 'Mobile',
                      //   onlyDigits: true,
                      //   controller: mobilenumbercontroller,
                      //   validator: (value) => validateForMobileNumberFeild(value: value, props: "Mobile Number"),
                      //   onChanged: (value) {
                      //     notify.add({"id": 8, "item": value.trim()});
                      //   },
                      // ),
                      MobileNumberInputField(
                        fromProfile: true,
                        focusNode: mobileNumberFocusNode,
                        fontsize: 14,
                        controller: mobilenumbercontroller,
                        onFieldSubmitted: (value) {
                          if (!isChecked) {
                            FocusScope.of(context).requestFocus(whatsappNumberFocusNode);
                          } else {
                            FocusScope.of(context).requestFocus(locationFocusNode);
                          }
                        },
                        hintText: 'Mobile Number',
                        isEmpty: isMobileEmpty,
                        openModal: () => openModal(true),
                        countryCode: selectedCountryCode,
                        onChange: (value) {
                          notify.add({"id": 8, "item": "$selectedCountryCode ${value.trim()}"});
                        },
                      ),
                      if (isMobileEmpty)
                        const Padding(
                          padding: EdgeInsets.only(left: 15.0, bottom: 5),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: AppText(
                              text: 'Please enter Mobile Number',
                              textColor: Colors.red,
                              fontsize: 12,
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: CustomCheckbox(
                          value: isChecked,
                          label: 'Use Same Number For Whatsapp',
                          onChanged: (value) {
                            setState(() {
                              isChecked = value;
                            });
                            if (!value) {
                              whatsupnumbercontroller.text = "";
                            }
                          },
                        ),
                      ),
                      if (!isChecked)
                        MobileNumberInputField(
                          // margin: const EdgeInsets.all(7),
                          focusNode: whatsappNumberFocusNode,
                          fromProfile: true,
                          hintText: 'Whatsapp Number',
                          isMandatory: true,
                          openModal: () => openModal(false),
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(locationFocusNode);
                          },
                          countryCode: selectedCountryCode,
                          controller: whatsupnumbercontroller,
                          onChange: (value) {
                            notify.add({"id": 9, "item": value.trim()});
                          },
                          isEmpty: isWhatsappEmpty,
                        ),
                      if (isWhatsappEmpty && !isChecked)
                        const Padding(
                          padding: EdgeInsets.only(left: 15.0, bottom: 5),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: AppText(
                              text: 'Please enter Whatsapp Number',
                              textColor: Colors.red,
                              fontsize: 12,
                            ),
                          ),
                        ),
                      LabelTextInputField(
                        labelText: 'Search your location',
                        focusNode: locationFocusNode,
                        // margin: const EdgeInsets.all(7),
                        inputController: statecontroller,
                        isMandatory: true,
                        validator: (value) => validateForNormalFeild(value: value, props: "Search Location"),
                        onChanged: (value) {
                          getPlaces(value).then((places) {
                            // print(places);
                            final descriptions = places.predictions?.map((prediction) => prediction.description) ?? [];
                            setState(() {
                              placesList = descriptions.toList();
                            });
                          });
                        },
                      ),
                      if (placesList.isNotEmpty)
                        Container(
                          constraints: const BoxConstraints(maxHeight: 200),
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0.8), borderRadius: BorderRadius.circular(8)),
                          margin: const EdgeInsets.symmetric(horizontal: 7),
                          child: _buildPlacesList(notify),
                        ),
                      LabelTextInputField(
                        labelText: 'Address 1',
                        // margin: const EdgeInsets.all(7),
                        isMandatory: true,
                        maxLength: 150,
                        inputController: address1controller,
                        validator: (value) => validateForNormalFeild(value: value, props: "Addressline 1"),
                        onChanged: (value) {
                          notify.add({"id": 10, "item": value.trim()});
                        },
                      ),
                      LabelTextInputField(
                        labelText: 'Address 2',
                        maxLength: 150,
                        isMandatory: true,
                        inputController: address2controller,
                        validator: (value) => validateForNormalFeild(value: value, props: "Addressline 2"),
                        onChanged: (value) {
                          notify.add({"id": 15, "item": value.trim()});
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        child: Column(
                          children: [
                            CustomDropdownFormField<String>(
                              label: "Register As",
                              value: registerAs,
                              isMandatory: true,
                              items: dropdownitem,
                              onChanged: (value) {
                                setState(() {
                                  registerAs = value;
                                });
                                notify.add({"id": 13, "item": value});
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select role';
                                }
                                return null;
                              },
                            ),
                            // DropDownField(
                            //     title: "Register As",
                            //     defaultValues: "Broker",
                            //     optionsList: dropdownitem,
                            //     onchanged: (value) {
                            //       notify.add({"id": 13, "item": value});
                            //     }),
                          ],
                        ),
                      ),
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
                                widget.goToPreviousScreen();
                              },
                              width: 73,
                              height: 39,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            margin: const EdgeInsets.only(top: 20),
                            alignment: Alignment.centerRight,
                            child: isloading
                                ? const Center(child: CircularProgressIndicator.adaptive())
                                : CustomButton(
                                    text: 'Save',
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w700,
                                    onPressed: () => submitSignupForm(notify),
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
      ),
    );
  }

  ListView _buildPlacesList(SelectedSignupItems notify) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: placesList.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: AppText(
            fontsize: 13,
            text: placesList[index],
            textColor: Colors.black,
          ),
          onTap: () {
            final str = placesList[index];

            try {
              List<String> words = str.split(' ');
              if (words.length > 3) {
                String lastThreeWords = words.contains("India") ? words.sublist(words.length - 3).join(' ') : words.sublist(words.length - 2).join(' ');
                String remainingWords = words.contains("India") ? words.sublist(0, words.length - 3).join(' ') : words.sublist(0, words.length - 2).join(' ');
                if (remainingWords.endsWith(',')) {
                  remainingWords = remainingWords.replaceFirst(RegExp(r',\s*$'), '');
                }
                if (lastThreeWords.endsWith(',')) {
                  lastThreeWords = lastThreeWords.replaceFirst(RegExp(r',\s*$'), '');
                }
                List<String> lastThreeWordsList = lastThreeWords.split(' ');
                if (lastThreeWordsList.isNotEmpty) {
                  if (lastThreeWordsList.contains('India')) {
                    lastThreeWordsList.removeLast();
                  }
                  lastThreeWords = lastThreeWordsList.join(' ');
                }
                if (lastThreeWords.endsWith(',')) {
                  lastThreeWords = lastThreeWords.replaceFirst(RegExp(r',\s*$'), '');
                }
                statecontroller.text = placesList[index] ?? "";
                address1controller.text = remainingWords;
                address2controller.text = lastThreeWords;
                notify.add({"id": 10, "item": remainingWords});
                notify.add({"id": 15, "item": lastThreeWords});
                final cityName = lastThreeWordsList[0].endsWith(',') ? lastThreeWordsList[0].replaceFirst(RegExp(r',\s*$'), '') : lastThreeWordsList[0];
                final stateName = lastThreeWordsList[1].endsWith(',') ? lastThreeWordsList[1].replaceFirst(RegExp(r',\s*$'), '') : lastThreeWordsList[1];
                notify.add({"id": 12, "item": cityName});
                notify.add({"id": 11, "item": stateName});
                notify.add({"id": 16, "item": placesList[index]});
                setState(() {
                  placesList = [];
                });
              } else {
                setState(() {
                  placesList = [];
                });
                address1controller.text = "";
                address2controller.text = "";
                customSnackBar(context: context, text: 'Choose a proper address');
              }
            } catch (e) {
              setState(() {
                placesList = [];
                address1controller.text = "";
                address2controller.text = "";
              });
              address1controller.text = "";
              address2controller.text = "";
            }
          },
        );
      },
    );
  }
}

Future<GooglePlaces> getPlaces(String text) async {
  final uri = Uri.parse(kIsWeb
      ? "https://us-central1-brokr-in.cloudfunctions.net/getPlacesData?input=$text"
      : "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$text&components=country:IN&key=${AppConst.googlemapkey}");
  // final uri = Uri.parse("http://142.93.234.216:44210/api/v1/user/locations?name=${text}");
  // final uri = Uri.parse(kIsWeb
  //     ? "https://proxy.cors.sh/https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$text&components=country:IN&key=${AppConst.googlemapkey}"
  //     : "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$text&components=country:IN&key=${AppConst.googlemapkey}");
  final response = await http.get(uri);
  var responseData = json.decode(response.body);
  if (response.statusCode == 200) {
    return GooglePlaces.fromJson(responseData);
  } else {
    throw Exception('Failed to load data');
  }
}
