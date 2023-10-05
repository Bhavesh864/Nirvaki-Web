import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/firebase/google_places_model.dart';

import 'package:yes_broker/customs/custom_fields.dart';
import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/customs/snackbar.dart';
import 'package:yes_broker/riverpodstate/sign_up_state.dart';
import 'package:yes_broker/pages/Auth/signup/signup_screen.dart';
import 'package:yes_broker/constants/validation/basic_validation.dart';
import 'package:yes_broker/screens/account_screens/profile_screen.dart';
import '../../../constants/utils/constants.dart';
import '../../../constants/utils/image_constants.dart';
import '../../../routes/routes.dart';
import '../../../widgets/auth/details_header.dart';
import 'package:http/http.dart' as http;

class CompanyDetailsAuthScreen extends ConsumerStatefulWidget {
  const CompanyDetailsAuthScreen({super.key});
  @override
  CompanyDetailsAuthScreenState createState() => CompanyDetailsAuthScreenState();
}

class CompanyDetailsAuthScreenState extends ConsumerState<CompanyDetailsAuthScreen> {
  bool isChecked = true;
  final key = GlobalKey<FormState>();
  var isloading = false;
  TextEditingController controller = TextEditingController();

  void submitSignupForm(SelectedSignupItems notify) {
    final isvalid = key.currentState?.validate();
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
                context.beamToReplacementNamed(AppRoutes.loginScreen),
              }
            else
              {
                setState(() {
                  isloading = false;
                }),
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value!))),
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

  final TextEditingController companynamecontroller = TextEditingController();
  final TextEditingController mobilenumbercontroller = TextEditingController();
  final TextEditingController whatsupnumbercontroller = TextEditingController();
  final TextEditingController address1controller = TextEditingController();
  final TextEditingController address2controller = TextEditingController();
  TextEditingController statecontroller = TextEditingController();
  final TextEditingController citycontroller = TextEditingController();
  final TextEditingController uploadLogocontroller = TextEditingController();
  List placesList = [];

  @override
  Widget build(BuildContext context) {
    final notify = ref.read(selectedItemForsignup.notifier);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
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
                                  margin: const EdgeInsets.all(7),
                                  labelText: 'Company Name',
                                  controller: companynamecontroller,
                                  validator: (value) => validateForNormalFeild(value: value, props: "Company Name"),
                                  onChanged: (value) {
                                    notify.add({"id": 7, "item": value.trim()});
                                  },
                                ),
                                GestureDetector(
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
                                  child: CustomTextInput(
                                    controller: uploadLogocontroller,
                                    readonly: true,
                                    enabled: false,
                                    labelText: "Upload Logo",
                                    rightIcon: Icons.publish,
                                  ),
                                ),
                                CustomTextInput(
                                  margin: const EdgeInsets.all(7),
                                  labelText: 'Mobile',
                                  onlyDigits: true,
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
                                    margin: const EdgeInsets.all(7),
                                    labelText: 'Whatsapp Number',
                                    controller: whatsupnumbercontroller,
                                    validator: !isChecked ? (value) => validateForMobileNumberFeild(value: value, props: "Whatsapp Number") : null,
                                    onChanged: (value) {
                                      notify.add({"id": 9, "item": value.trim()});
                                    },
                                  ),
                                CustomTextInput(
                                  labelText: 'Search your location',
                                  margin: const EdgeInsets.all(7),
                                  controller: statecontroller,
                                  validator: (value) => validateForNormalFeild(value: value, props: "Search Location"),
                                  onChanged: (value) {
                                    var list = [];
                                    getPlaces(value).then((places) => {
                                          for (var i = 0; i < places.data!.predictions!.length; i++)
                                            {
                                              list.add(places.data!.predictions![i].description),
                                            },
                                          setState(() {
                                            placesList = list;
                                          })
                                        });
                                  },
                                ),
                                if (placesList.isNotEmpty)
                                  Container(
                                    height: 200,
                                    decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0.8), borderRadius: BorderRadius.circular(8)),
                                    margin: const EdgeInsets.symmetric(horizontal: 7),
                                    child: ListView.builder(
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
                                              if (words.length >= 3) {
                                                String lastThreeWords = words.sublist(words.length - 3).join(' ');
                                                String remainingWords = words.sublist(0, words.length - 3).join(' ');
                                                List<String> lastThreeWordsList = lastThreeWords.split(' ');
                                                if (lastThreeWordsList.length >= 1) {
                                                  lastThreeWordsList.removeLast();
                                                  lastThreeWords = lastThreeWordsList.join(' ');
                                                }
                                                statecontroller.text = placesList[index] ?? "";
                                                address1controller.text = remainingWords;
                                                address2controller.text = lastThreeWords;
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
                                              });
                                              address1controller.text = "";
                                              address2controller.text = "";
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                CustomTextInput(
                                  labelText: 'Address 1',
                                  margin: const EdgeInsets.all(7),
                                  controller: address1controller,
                                  validator: (value) => validateForNormalFeild(value: value, props: "Addressline 1"),
                                  onChanged: (value) {
                                    notify.add({"id": 10, "item": value.trim()});
                                  },
                                ),
                                CustomTextInput(
                                  labelText: 'Address 2',
                                  margin: const EdgeInsets.all(7),
                                  controller: address2controller,
                                  validator: (value) => validateForNormalFeild(value: value, props: "Addressline 2"),
                                  onChanged: (value) {
                                    notify.add({"id": 15, "item": value.trim()});
                                  },
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                                  alignment: Alignment.centerRight,
                                  child: isloading
                                      ? const Center(child: CircularProgressIndicator.adaptive())
                                      : CustomButton(
                                          text: 'Save',
                                          onPressed: () => submitSignupForm(notify),
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
            ],
          ),
        ),
      ),
    );
  }
}

Future<GooglePlacesModel> getPlaces(String text) async {
  print(text);
  final uri = Uri.parse("http://142.93.234.216:44210/api/v1/user/locations?name=${text}");

  final response = await http.get(
    uri,
    headers: <String, String>{
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "GET,POST,PUT,OPTIONS",
      "Access-Control-Allow-Headers": "Origin, X-Requested-With, Content-Type, Accept"
    },
  );
  var responseData = json.decode(response.body.toString());
  print("responseData=----> $responseData");
  if (response.statusCode == 200) {
    return GooglePlacesModel.fromJson(responseData);
  } else {
    throw Exception('Failed to load data');
  }
}
