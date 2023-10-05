import 'dart:async';
import 'dart:io';

import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/state_list.dart';
import 'package:yes_broker/constants/utils/colors.dart';

import 'package:yes_broker/customs/custom_fields.dart';
import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/customs/snackbar.dart';
import 'package:yes_broker/riverpodstate/sign_up_state.dart';
import 'package:yes_broker/pages/Auth/signup/signup_screen.dart';
import 'package:yes_broker/constants/validation/basic_validation.dart';
import 'package:yes_broker/screens/account_screens/profile_screen.dart';
import '../../../customs/dropdown_field.dart';
import '../../../constants/utils/constants.dart';
import '../../../constants/utils/image_constants.dart';
import '../../../routes/routes.dart';
import '../../../widgets/auth/details_header.dart';

// ================================== Second method ==================================
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

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
  final TextEditingController statecontroller = TextEditingController();
  final TextEditingController citycontroller = TextEditingController();
  final TextEditingController uploadLogocontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final notify = ref.read(selectedItemForsignup.notifier);
    print('object---> $citiesList');
    print('controller---> ${controller.text}');

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
                            GooglePlaceAutoCompleteTextField(
                                boxDecoration: const BoxDecoration(),
                                textEditingController: controller,
                                googleAPIKey: AppConst.googlemapkey,
                                inputDecoration: InputDecoration(
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: AppColor.inputFieldBorderColor,
                                      )),
                                  errorStyle: const TextStyle(height: 0),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: Colors.red, width: 1),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                  hintText: 'Search your location',
                                  hintStyle: const TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(width: 1, color: Colors.white),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: AppColor.primary,
                                    ),
                                  ),
                                  errorMaxLines: 1,
                                ),
                                debounceTime: 800,
                                countries: ["in", "fr"],
                                isLatLngRequired: false,
                                getPlaceDetailWithLatLng: (Prediction prediction) {
                                  final str = prediction.lng.toString();
                                  print("placeDetails" + str);
//                                   List<String> parts = str.split(", ");
//
//                                   // Assign each part to the respective variable
//                                   String address = parts[0];
//                                   String city = parts[1];
//                                   String district = parts[2];
//                                   String state = parts[3];
//                                   String country = parts[4];
//
//                                   // Print the variables
//                                   print("Address: $address");
//                                   print("City: $city");
//                                   print("District: $district");
//                                   print("State: $state");
//                                   print("Country: $country");
                                },
                                itemClick: (Prediction prediction) {
                                  print(prediction.description);
                                  final str = prediction.description;
                                  print("placeDetail--> s" + str!);
                                  List<String> parts = str.split(", ");

                                  // Assign each part to the respective variable
                                  String address = parts[0];
                                  String city = parts[1];
                                  String district = parts[2];
                                  String state = parts[3];
                                  String country = parts[4];

                                  // Print the variables
                                  print("Address: $address");
                                  print("City: $city");
                                  print("District: $district");
                                  print("State: $state");
                                  print("Country: $country");
                                  controller.text = prediction.description ?? "";
                                  address1controller.text = "$address, $city";
                                  address2controller.text = "$district, $state";

                                  controller.selection = TextSelection.fromPosition(TextPosition(offset: prediction.description != null ? prediction.description!.length : 0));
                                }),
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
//                             Container(
//                               margin: const EdgeInsets.symmetric(horizontal: 6),
//                               child: Column(
//                                 children: [
//                                   DropDownField(
//                                       title: "State",
//                                       defaultValues: selectedState,
//                                       optionsList: stateList,
//                                       onchanged: (value) {
//                                         notify.add({"id": 11, "item": value});
//                                         setState(() {
//                                           selectedState = value as String;
//                                           citiesList = [];
//                                           selectedCity = "";
//                                         });
//                                         for (var i = 0; i < stateListsss.length; i++) {
//                                           if (stateListsss[i]["state"] == value) {
//                                             print(stateListsss[i]["districts"][0]);
//                                             setState(() {
//                                               citiesList = stateListsss[i]["districts"] as List<String>;
//                                               selectedCity = stateListsss[i]["districts"][0] as String;
//                                             });
//                                           }
//                                         }
//                                       }),
//                                   // stateListsss.where((element) => element);
//                                   // for (var state in stateListsss) {
//                                   //   if (state["state"] == value) {
//                                   //     setState(() {
//                                   //       citiesList = state["districts"] as List<String>;
//                                   //     });
//                                   //   }
//                                   // }
//                                   //     DropdownButton(
//                                   //       // hint: const Text('Select Rajasthan'),
//                                   //       // value: selectedCategory,
//                                   //       onChanged: (newValue) {
//                                   //         // print(newValue);
//                                   //         setState(() {
//                                   //           selectedCity = '';
//                                   //           selectedState = newValue!;
//                                   //           // citiesList = ["districts"] as List<String>;
//                                   //         });
//                                   //         for (var state in stateListsss) {
//                                   //           if (state["state"] == newValue) {
//                                   //             setState(() {
//                                   //               citiesList = state["districts"] as List<String>;
//                                   //             });
//                                   //           }
//                                   //         }
//                                   //       },
//                                   //       items: <String>[
//                                   //         "Andaman and Nicobar Islands",
//                                   //         "Andhra Pradesh",
//                                   //         "Arunachal Pradesh",
//                                   //         "Assam",
//                                   //         "Bihar",
//                                   //         "Chandigarh",
//                                   //         "Chhattisgarh",
//                                   //         "Dadra and Nagar Haveli",
//                                   //         "Daman and Diu",
//                                   //         "Delhi",
//                                   //         "Goa",
//                                   //         "Gujarat",
//                                   //         "Haryana",
//                                   //         "Himachal Pradesh",
//                                   //         "Jammu and Kashmir",
//                                   //         "Jharkhand",
//                                   //         "Karnataka",
//                                   //         "Kerala",
//                                   //         "Ladakh",
//                                   //         "Lakshadweep",
//                                   //         "Madhya Pradesh",
//                                   //         "Maharashtra",
//                                   //         "Manipur",
//                                   //         "Meghalaya",
//                                   //         "Mizoram",
//                                   //         "Nagaland",
//                                   //         "Odisha",
//                                   //         "Puducherry",
//                                   //         "Punjab",
//                                   //         "Rajasthan",
//                                   //         "Sikkim",
//                                   //         "Tamil Nadu",
//                                   //         "Telangana",
//                                   //         "Tripura",
//                                   //         "Uttar Pradesh",
//                                   //         "Uttarakhand",
//                                   //         "West Bengal",
//                                   //       ].map((String category) {
//                                   //         return DropdownMenuItem(
//                                   //           value: category,
//                                   //           child: Text(category),
//                                   //         );
//                                   //       }).toList(),
//                                   //     ),
//                                   //
//                                   //
//                                   //      DropdownButton<String>(
//                                   //       hint: Text('Select Subcategory'),
//                                   //       value: selectedSubCategory,
//                                   //       onChanged: (newValue) {
//                                   //         setState(() {
//                                   //           selectedSubCategory = newValue!;
//                                   //         });
//                                   //       },
//                                   //       items: stateListsss[selectedCategory]?.map((subcategory) {
//                                   //         return DropdownMenuItem(
//                                   //           value: subcategory,
//                                   //           child: Text(subcategory),
//                                   //         );
//                                   //       })?.toList() ?? [],
//                                   //     ),
//                                   //   ],
//                                   // ),
//
//                                   DropDownField(
//                                       title: "City",
//                                       defaultValues: selectedCity,
//                                       optionsList: citiesList,
//                                       onchanged: (value) {
//                                         notify.add({"id": 12, "item": value});
//                                         setState(() {
//                                           selectedCity = value as String;
//                                         });
//                                       }),
//
// //                                       DropdownButton<List<String>>(
// //             value: citiesList,
// //
// //             dropdownColor: Colors.white,
// //             focusColor: AppColor.secondary,
// //             items: citiesList.map((e) => _dataToMenuItem(e)).toList())
//                                   // DropdownMenuItem(child: Text('item')),
//                                   DropDownField(
//                                       title: "Register As",
//                                       defaultValues: "",
//                                       optionsList: dropdownitem,
//                                       onchanged: (value) {
//                                         notify.add({"id": 13, "item": value});
//                                       }),
//                                 ],
//                               ),
//                             ),
//
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
        ),
      ),
    );
  }
}

//
//
// class CompanyDetailsAuthScreens extends StatefulWidget {
//   const CompanyDetailsAuthScreens({super.key});
//
//   @override
//   // ignore: library_private_types_in_public_api
//   _CompanyDetailsAuthScreensState createState() => _CompanyDetailsAuthScreensState();
// }
//
// class _CompanyDetailsAuthScreensState extends State<CompanyDetailsAuthScreens> {
//   TextEditingController controller = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the CompanyDetailsAuthScreen object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text("App titile"),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Invoke "debug painting" (press "p" in the console, choose the
//           // "Toggle Debug Paint" action from the Flutter Inspector in Android
//           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//           // to see the wireframe for each widget.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             SizedBox(height: 20),
//             placesAutoCompleteTextField(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   placesAutoCompleteTextField() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         children: [
//           ElevatedButton(
//               onPressed: () {
//                 getAllCategoryItems('Bikaner');
//               },
//               child: Text('click')),
//           GooglePlaceAutoCompleteTextField(
//               textEditingController: controller,
//               googleAPIKey: "AIzaSyD7KtQoq29-5TqELLdPBSQoqCD376-qGjA",
//               inputDecoration: InputDecoration(hintText: "Search your location"),
//               debounceTime: 800,
//               countries: ["in", "fr"],
//               isLatLngRequired: false,
//               getPlaceDetailWithLatLng: (Prediction prediction) {
//                 print("placeDetails" + prediction.lng.toString());
//               },
//               itemClick: (Prediction prediction) {
//                 controller.text = prediction.description ?? "";
//
//                 controller.selection = TextSelection.fromPosition(TextPosition(offset: prediction.description != null ? prediction.description!.length : 0));
//               }
//               // default 600 ms ,
//               ),
//         ],
//       ),
//     );
//   }
// }
//
// Future<void> getAllCategoryItems(String text) async {
//   print(text);
//   final uri = Uri.parse('https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${text}&key=AIzaSyBJXgFzyAEn02NMURljQ5xNdsPehFL9mXA');
//
//   final response = await http.get(
//     uri,
//     headers: <String, String>{
//       "Access-Control-Allow-Origin": "*",
//       "Access-Control-Allow-Methods": "GET,POST,PUT,OPTIONS",
//       "Access-Control-Allow-Headers": "Origin, X-Requested-With, Content-Type, Accept"
//     },
//     // headers: {
//     //   "Accept": "application/json",
//     //   "Access-Control-Allow-Origin": "*",
//     //   // "Access-Control-Allow-Origin": "*", // Required for CORS support to work
//     //   // // "Access-Control-Allow-Credentials": "true", // Required for cookies, authorization headers with HTTPS
//     //   // "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
//     //   // "Access-Control-Allow-Methods": "GET"
//     // },
//   );
//   var responseData = json.decode(response.body.toString());
//   if (response.statusCode == 200) {
//     print("responseData=----> $responseData");
//     // return Enter.fromJson(responseData);
//   } else {
//     throw Exception('Failed to load data');
//   }
// }
