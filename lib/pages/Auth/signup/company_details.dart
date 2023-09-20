import 'dart:io';

import 'package:beamer/beamer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:yes_broker/customs/custom_fields.dart';

import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/riverpodstate/sign_up_state.dart';
import 'package:yes_broker/pages/Auth/signup/signup_screen.dart';

import 'package:yes_broker/constants/validation/basic_validation.dart';

import '../../../customs/dropdown_field.dart';
import '../../../constants/utils/constants.dart';
import '../../../constants/utils/image_constants.dart';
import '../../../routes/routes.dart';
import '../../../widgets/auth/details_header.dart';

class CompanyDetailsAuthScreen extends ConsumerStatefulWidget {
  const CompanyDetailsAuthScreen({super.key});
  @override
  CompanyDetailsAuthScreenState createState() => CompanyDetailsAuthScreenState();
}

class CompanyDetailsAuthScreenState extends ConsumerState<CompanyDetailsAuthScreen> {
  bool isChecked = true;
  final key = GlobalKey<FormState>();
  var isloading = false;

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
                // if (Responsive.isMobile(context))
                //   {
                //     Navigator.of(context).pushReplacementNamed(AppRoutes.loginScreen),
                //   }
                // else
                //   {
                // }
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

  // Future<XFile?> selectImagee() async {
  selectImagee() async {
    XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      uploadLogocontroller.text = pickedImage!.name;
    });
    var webUrl = await pickedImage!.readAsBytes();
    var imageUrl = File(pickedImage.path);
    if (kIsWeb) {
      return webUrl;
    }
    return imageUrl;
  }

  final List<String> dropdownitem = ["Broker", "Builder"];
  final TextEditingController companynamecontroller = TextEditingController();
  final TextEditingController mobilenumbercontroller = TextEditingController();
  final TextEditingController whatsupnumbercontroller = TextEditingController();
  final TextEditingController address1controller = TextEditingController();
  final TextEditingController address2controller = TextEditingController();
  final TextEditingController statecontroller = TextEditingController();
  final TextEditingController citycontroller = TextEditingController();
  final TextEditingController uploadLogocontroller = TextEditingController();

  void uploadImageToFirebase(imageUrl) async {
    final uniqueKey = DateTime.now().microsecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImagesToUpload = referenceDirImages.child(uniqueKey);

    try {
      if (kIsWeb) {
        final metaData = SettableMetadata(contentType: 'image/jpeg');
        await referenceImagesToUpload.putData(imageUrl, metaData);
      } else {
        await referenceImagesToUpload.putFile(imageUrl);
      }
      imageUrl = await referenceImagesToUpload.getDownloadURL();
      print("imageUrl--> $imageUrl");
      final notify = ref.read(selectedItemForsignup.notifier);
      notify.add({"id": 14, "item": imageUrl});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final notify = ref.read(selectedItemForsignup.notifier);
    print("notify---> $notify");
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
                            CustomTextInput(
                              margin: const EdgeInsets.all(7),
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
                                margin: const EdgeInsets.all(7),
                                labelText: 'Whatsapp Number',
                                controller: whatsupnumbercontroller,
                                validator: !isChecked ? (value) => validateForMobileNumberFeild(value: value, props: "Whatsapp Number") : null,
                                onChanged: (value) {
                                  notify.add({"id": 9, "item": value.trim()});
                                },
                              ),
                            CustomTextInput(
                              labelText: 'Address',
                              margin: const EdgeInsets.all(7),
                              controller: address1controller,
                              validator: (value) => validateForNormalFeild(value: value, props: "Address"),
                              onChanged: (value) {
                                notify.add({"id": 10, "item": value.trim()});
                              },
                            ),
                            CustomTextInput(
                              controller: uploadLogocontroller,
                              readonly: true,
                              labelText: "Upload Logo",
                              ontap: () {
                                selectImagee().then((value) => {
                                      uploadImageToFirebase(value)
                                      // getImageUrl(value!).then((img) => {uploadImageToFirebase(img)})
                                    });
                              },
                              rightIcon: Icons.publish,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              child: Column(
                                children: [
                                  DropDownField(
                                      title: "State",
                                      defaultValues: "",
                                      optionsList: const ["Rajasthan"],
                                      onchanged: (value) {
                                        notify.add({"id": 11, "item": value});
                                      }),
                                  DropDownField(
                                      title: "City",
                                      defaultValues: "",
                                      optionsList: const ["Jaipur", "Bikaner"],
                                      onchanged: (value) {
                                        notify.add({"id": 12, "item": value});
                                      }),
                                  DropDownField(
                                      title: "Register As",
                                      defaultValues: "",
                                      optionsList: dropdownitem,
                                      onchanged: (value) {
                                        notify.add({"id": 13, "item": value});
                                      }),
                                ],
                              ),
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
        ),
      ),
    );
  }
}
