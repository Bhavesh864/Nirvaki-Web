// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/constants/app_constant.dart';
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
                  ),
                  CustomCompanyDetailsCard(
                    title: 'Company Information',
                    brokerData: broker,
                    isPersonalDetails: true,
                  ),
                  CustomCompanyDetailsCard(
                    title: 'Company Address',
                    brokerData: broker,
                    isPersonalDetails: false,
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
  final BrokerInfo brokerData;

  const CustomCompanyDetailsCard({
    Key? key,
    this.title,
    required this.isPersonalDetails,
    required this.brokerData,
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
                    onTap: () {},
                    child: CircleAvatar(
                      radius: 35,
                      backgroundImage: isNameEditing ? null : NetworkImage(broker.brokerlogo!),
                      child: isNameEditing
                          ? const Icon(
                              Icons.add,
                              size: 25,
                            )
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
                        cancelEditingFullName();
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
                  if (isPersonalDetailsEditing && widget.isPersonalDetails) ...[
                    Row(
                      children: [
                        CustomButton(
                          height: 39,
                          text: "cancel",
                          borderColor: AppColor.primary,
                          onPressed: () {
                            cancelEditingPersonalDetails();
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
                            cancelEditingPersonalDetails();
                          },
                        ),
                      ],
                    ),
                  ] else ...[
                    GestureDetector(
                      onTap: () {
                        startEditingPersonalDetails(
                          broker.companyname!,
                          broker.brokercompanyemail!,
                          broker.brokercompanynumber!,
                        );
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildInfoFields('Email address', broker.brokercompanyemail!, isPersonalDetailsEditing, emailController),
                      buildInfoFields('Phone ', broker.brokercompanynumber!, isPersonalDetailsEditing, phoneController),
                      const SizedBox(),
                      const SizedBox(),
                      const SizedBox(),
                    ],
                  ),
                ),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildInfoFields('Address 1', broker.brokercompanyaddress['Addressline1'], false, TextEditingController()),
                      buildInfoFields('City', broker.brokercompanyaddress['city'], false, TextEditingController()),
                      const SizedBox(
                        width: 60,
                      ),
                      const SizedBox(),
                      const SizedBox(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildInfoFields('Address 2', broker.brokercompanyaddress['Addressline2'], false, TextEditingController()),
                      buildInfoFields('State', broker.brokercompanyaddress['state'], false, TextEditingController()),
                      const SizedBox(),
                      const SizedBox(),
                      const SizedBox(),
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
