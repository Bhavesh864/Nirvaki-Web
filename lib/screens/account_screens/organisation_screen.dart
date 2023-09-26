// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/firebase/Methods/update_broker_info.dart';
import 'package:yes_broker/constants/firebase/userModel/broker_info.dart';
import 'package:yes_broker/customs/loader.dart';
import 'package:yes_broker/screens/account_screens/profile_screen.dart';

import '../../Customs/custom_fields.dart';
import '../../Customs/responsive.dart';
import '../../Customs/text_utility.dart';
import '../../constants/utils/colors.dart';

class OrganisationScreen extends ConsumerStatefulWidget {
  const OrganisationScreen({super.key});

  @override
  ConsumerState<OrganisationScreen> createState() => _OrganisationScreenState();
}

class _OrganisationScreenState extends ConsumerState<OrganisationScreen> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> brokerInfo;
  @override
  void initState() {
    super.initState();
    brokerInfo = FirebaseFirestore.instance.collection('brokerInfo').doc(AppConst.getAccessToken()).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: StreamBuilder(
          stream: brokerInfo,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
            if (snapshot.hasData) {
              final dataList = snapshot.data;
              BrokerInfo broker = BrokerInfo.fromSnapshot(dataList!);
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (Responsive.isMobile(context))
                    const Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: AppText(
                        text: "Organistion",
                        fontWeight: FontWeight.w700,
                        fontsize: 16,
                      ),
                    ),
                  CustomCompanyDetailsCard(
                    isPersonalDetails: false,
                    brokerData: broker,
                    isAdressDetails: false,
                  ),
                  CustomCompanyDetailsCard(
                    title: 'Company Information',
                    brokerData: broker,
                    isPersonalDetails: true,
                    isAdressDetails: false,
                  ),
                  CustomCompanyDetailsCard(
                    title: 'Company Address',
                    brokerData: broker,
                    isPersonalDetails: false,
                    isAdressDetails: true,
                  ),
                ],
              );
            }
            return const SizedBox();
          }),
    );
  }
}

class CustomCompanyDetailsCard extends ConsumerStatefulWidget {
  final String? title;
  final bool isPersonalDetails;
  final bool isAdressDetails;
  final BrokerInfo brokerData;

  const CustomCompanyDetailsCard({
    Key? key,
    this.title,
    required this.isPersonalDetails,
    required this.brokerData,
    required this.isAdressDetails,
  }) : super(key: key);

  @override
  ConsumerState<CustomCompanyDetailsCard> createState() => _CustomCompanyDetailsCard();
}

class _CustomCompanyDetailsCard extends ConsumerState<CustomCompanyDetailsCard> {
  bool isNameEditing = false;
  bool isPersonalDetailsEditing = false;
  bool isAddressEditing = false;

  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  File? profilePhoto;
  Uint8List? webProfile;
  String? uploadProfile;

  void startEditingFullName(String fullName) {
    setState(() {
      isNameEditing = true;
      companyNameController.text = fullName;
    });
  }

  void cancelEditingFullName() {
    setState(() {
      isNameEditing = false;
      companyNameController.clear();
    });
  }

  void startEditingAddressDetail(String city, String state, String address1, String address2) {
    setState(() {
      isAddressEditing = true;
      address1Controller.text = address1;
      address2Controller.text = address2;
      cityController.text = city;
      stateController.text = state;
    });
  }

  void cancelEditingAddressDetail() {
    setState(() {
      isAddressEditing = false;
      cityController.clear();
      address1Controller.clear();
      address2Controller.clear();
      stateController.clear();
    });
  }

  void startEditingPersonalDetails(String companyname, String email, String phone) {
    setState(() {
      isPersonalDetailsEditing = true;
      companyNameController.text = companyname;
      phoneController.text = phone;
      emailController.text = email;
    });
  }

  void cancelEditingPersonalDetails() {
    setState(() {
      isPersonalDetailsEditing = false;
      companyNameController.clear();
      emailController.clear();
      phoneController.clear();
    });
  }

  selectImage() async {
    XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      var webUrl = await pickedImage.readAsBytes();
      var imageUrl = File(pickedImage.path);
      if (kIsWeb) {
        setState(() {
          webProfile = webUrl;
        });
        return webUrl;
      }
      setState(() {
        profilePhoto = imageUrl;
      });
      return imageUrl;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final BrokerInfo broker = widget.brokerData;
    if (widget.title == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (isNameEditing) {
                        selectImage().then((value) {
                          if (value != "") {
                            uploadImageToFirebases(value).then((url) {
                              if (url != "") {
                                setState(() {
                                  uploadProfile = url;
                                });
                              }
                            });
                          }
                        });
                      }
                    },
                    child: CircleAvatar(
                      radius: 35,
                      backgroundImage: isNameEditing ? null : NetworkImage(broker.brokerlogo!),
                      child: isNameEditing
                          ? profilePhoto == null && webProfile == null
                              ? const Icon(
                                  Icons.add,
                                  size: 25,
                                )
                              : (kIsWeb)
                                  ? ClipOval(child: Image.memory(webProfile!, width: 70, height: 70, fit: BoxFit.cover))
                                  : ClipOval(child: Image.file(profilePhoto!, width: 70, height: 70, fit: BoxFit.cover))
                          : null,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isNameEditing) ...[
                        SizedBox(
                          height: 50,
                          width: companyNameController.text.length * 13,
                          child: CustomTextInput(
                            controller: companyNameController,
                            onFieldSubmitted: (newValue) {},
                          ),
                        ),
                      ] else ...[
                        Text(
                          broker.companyname!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              if (isNameEditing) ...[
                Row(
                  children: [
                    CustomButton(
                      height: 39,
                      text: "cancel",
                      borderColor: AppColor.primary,
                      onPressed: () {
                        cancelEditingFullName();
                      },
                      buttonColor: Colors.white,
                      textColor: AppColor.primary,
                    ),
                    const SizedBox(width: 7),
                    CustomButton(
                      text: "Save",
                      borderColor: AppColor.primary,
                      height: 39,
                      onPressed: () {
                        updateBrokerInfo(
                                brokerId: broker.brokerid,
                                role: broker.role,
                                companyName: companyNameController.text,
                                mobile: broker.brokercompanynumber,
                                whatsapp: broker.brokercompanywhatsapp,
                                email: broker.brokercompanyemail,
                                image: broker.brokerlogo,
                                companyAddress: broker.brokercompanyaddress)
                            .then((value) => {cancelEditingFullName()});
                      },
                    ),
                  ],
                ),
              ] else ...[
                GestureDetector(
                  onTap: () {
                    startEditingFullName(broker.companyname!);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xff898989).withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.edit_outlined,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text('Edit'),
                        ],
                      ),
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      );
    } else {
      return Card(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (isPersonalDetailsEditing && widget.isPersonalDetails || isAddressEditing && widget.isAdressDetails) ...[
                    Row(
                      children: [
                        CustomButton(
                          height: 39,
                          text: "cancel",
                          borderColor: AppColor.primary,
                          onPressed: () {
                            cancelEditingPersonalDetails();
                            cancelEditingAddressDetail();
                          },
                          buttonColor: Colors.white,
                          textColor: AppColor.primary,
                        ),
                        const SizedBox(width: 7),
                        CustomButton(
                          text: "Save",
                          borderColor: AppColor.primary,
                          height: 39,
                          onPressed: () {
                            if (widget.isPersonalDetails) {
                              updateBrokerInfo(
                                      brokerId: broker.brokerid,
                                      role: broker.role,
                                      companyName: broker.companyname,
                                      mobile: phoneController.text,
                                      whatsapp: broker.brokercompanywhatsapp,
                                      email: emailController.text,
                                      image: broker.brokerlogo,
                                      companyAddress: broker.brokercompanyaddress)
                                  .then((value) => {cancelEditingPersonalDetails()});
                            } else if (widget.isAdressDetails) {
                              updateBrokerInfo(
                                  brokerId: broker.brokerid,
                                  role: broker.role,
                                  companyName: broker.companyname,
                                  mobile: broker.brokercompanynumber,
                                  whatsapp: broker.brokercompanywhatsapp,
                                  email: broker.brokercompanyemail,
                                  image: broker.brokerlogo,
                                  companyAddress: {
                                    "city": cityController.text,
                                    "state": stateController.text,
                                    "Addressline1": address1Controller.text,
                                    "Addressline2p": address2Controller.text
                                  }).then((value) => {cancelEditingAddressDetail()});
                            }
                          },
                        ),
                      ],
                    ),
                  ] else ...[
                    GestureDetector(
                      onTap: () {
                        if (widget.isPersonalDetails) {
                          startEditingPersonalDetails(
                            broker.companyname!,
                            broker.brokercompanyemail!,
                            broker.brokercompanynumber!,
                          );
                        } else if (widget.isAdressDetails) {
                          startEditingAddressDetail(
                            broker.brokercompanyaddress['city'],
                            broker.brokercompanyaddress['state'],
                            broker.brokercompanyaddress['Addressline1'],
                            broker.brokercompanyaddress['Addressline2'],
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xff898989).withOpacity(0.5),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.edit_outlined,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('Edit'),
                          ],
                        ),
                      ),
                    ),
                  ]
                ],
              ),
              if (widget.isPersonalDetails) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Table(
                    children: [
                      TableRow(children: [
                        buildInfoFields('Email address', broker.brokercompanyemail!, isPersonalDetailsEditing, emailController),
                        buildInfoFields('Phone ', broker.brokercompanynumber!, isPersonalDetailsEditing, phoneController),
                        const SizedBox(),
                      ])
                    ],
                  ),
                ),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Table(
                    children: [
                      TableRow(children: [
                        buildInfoFields('Address 1', broker.brokercompanyaddress['Addressline1'], isAddressEditing, address1Controller),
                        buildInfoFields('City', broker.brokercompanyaddress['city'], isAddressEditing, cityController),
                        const SizedBox(),
                      ])
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Table(
                    children: [
                      TableRow(children: [
                        buildInfoFields('Address 2', broker.brokercompanyaddress['Addressline2'], isAddressEditing, address2Controller),
                        buildInfoFields('State', broker.brokercompanyaddress['state'], isAddressEditing, stateController),
                        const SizedBox(),
                      ])
                    ],
                  ),
                ),
              ]
            ],
          ),
        ),
      );
    }
  }
}
