// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/constants/firebase/Methods/add_member_send_email.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/customs/responsive.dart';

import '../../Customs/custom_fields.dart';
import '../../Customs/loader.dart';
import '../../Customs/text_utility.dart';
import '../../constants/app_constant.dart';
import '../../constants/utils/colors.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> userInfo;
  @override
  void initState() {
    super.initState();
    userInfo = FirebaseFirestore.instance.collection('users').doc(AppConst.getAccessToken()).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Responsive.isMobile(context) ? 15.0 : 0),
      child: StreamBuilder(
          stream: userInfo,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
            if (snapshot.hasData) {
              final dataList = snapshot.data;
              User userInfo = User.fromSnapshot(dataList!);
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (Responsive.isMobile(context))
                    const Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: AppText(
                        text: "Profile",
                        fontWeight: FontWeight.w700,
                        fontsize: 16,
                      ),
                    ),
                  CustomAddressAndProfileCard(
                    isPersonalDetails: false,
                    userData: userInfo,
                  ),
                  CustomAddressAndProfileCard(
                    title: 'Personal Information',
                    isPersonalDetails: true,
                    userData: userInfo,
                  ),
                  CustomAddressAndProfileCard(
                    title: 'Address',
                    isPersonalDetails: false,
                    userData: userInfo,
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          }),
    );
  }
}

class CustomAddressAndProfileCard extends ConsumerStatefulWidget {
  final String? title;
  final bool isPersonalDetails;
  final User userData;
  const CustomAddressAndProfileCard({
    Key? key,
    this.title,
    required this.userData,
    required this.isPersonalDetails,
  }) : super(key: key);

  @override
  ConsumerState<CustomAddressAndProfileCard> createState() => _CustomAddressAndProfileCardState();
}

class _CustomAddressAndProfileCardState extends ConsumerState<CustomAddressAndProfileCard> {
  bool isNameEditing = false;
  bool isPersonalDetailsEditing = false;
  bool isAddressEditing = false;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void startEditingFullName(String fullName) {
    setState(() {
      isNameEditing = true;
      fullNameController.text = fullName;
    });
  }

  void cancelEditingFullName() {
    setState(() {
      isNameEditing = false;
      fullNameController.clear();
    });
  }

  void startEditingPersonalDetails(String firstName, String lastName, String email, String phone) {
    setState(() {
      isPersonalDetailsEditing = true;
      firstNameController.text = firstName;
      lastNameController.text = lastName;
      phoneController.text = phone;
      emailController.text = email;
    });
  }

  void cancelEditingPersonalDetails() {
    setState(() {
      isPersonalDetailsEditing = false;
      firstNameController.clear();
      lastNameController.clear();
      emailController.clear();
      phoneController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = widget.userData;
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
                      backgroundImage: isNameEditing ? null : NetworkImage(userData.image),
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
                      // if (isNameEditing) ...[
                      //   SizedBox(
                      //     height: 50,
                      //     width: fullNameController.text.length * 13,
                      //     child: CustomTextInput(
                      //       controller: fullNameController,
                      //       onFieldSubmitted: (newValue) {},
                      //     ),
                      //   ),
                      // ] else ...[
                      Text(
                        "${userData.userfirstname} ${userData.userlastname}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // ],
                      Text(
                        userData.role,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF818181),
                          fontWeight: FontWeight.w500,
                        ),
                      )
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
                    startEditingFullName("${userData.userfirstname} ${userData.userlastname}");
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
                            updateTeamMember(
                                    email: emailController.text.trim(),
                                    firstname: firstNameController.text.trim(),
                                    lastname: lastNameController.text.trim(),
                                    mobile: phoneController.text.trim(),
                                    managerName: userData.managerName,
                                    managerid: userData.managerid,
                                    role: userData.role,
                                    brokerId: userData.brokerId,
                                    userId: userData.userId,
                                    fcmToken: userData.fcmToken,
                                    imageUrl: userData.image,
                                    status: userData.status,
                                    isOnline: userData.isOnline)
                                .then((value) => {cancelEditingPersonalDetails()});
                          },
                        ),
                      ],
                    ),
                  ] else ...[
                    GestureDetector(
                      onTap: () {
                        startEditingPersonalDetails(
                          userData.userfirstname,
                          userData.userlastname,
                          userData.email,
                          userData.mobile,
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
                      buildInfoFields('First name', userData.userfirstname, isPersonalDetailsEditing, firstNameController),
                      buildInfoFields('Last Name ', userData.userlastname, isPersonalDetailsEditing, lastNameController),
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
                      buildInfoFields('Email address', userData.email, isPersonalDetailsEditing, emailController),
                      buildInfoFields('Phone ', userData.mobile, isPersonalDetailsEditing, phoneController),
                      if (!Responsive.isMobile(context)) buildInfoFields('Employee ID', userData.userId, false, TextEditingController()),
                      const SizedBox(),
                      const SizedBox(),
                      const SizedBox(),
                    ],
                  ),
                ),
                if (Responsive.isMobile(context)) buildInfoFields('Employee ID', userData.userId, false, TextEditingController()),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildInfoFields('City', 'New Delhi', false, TextEditingController()),
                      buildInfoFields('State ', 'Delhi', false, TextEditingController()),
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
                      buildInfoFields('Country', 'India', false, TextEditingController()),
                      buildInfoFields('Pin Code ', '110077', false, TextEditingController()),
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

Widget buildInfoFields(String fieldName, String fieldDetail, bool isEditing, TextEditingController textController) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        fieldName,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF818181),
          fontWeight: FontWeight.w500,
        ),
      ),
      if (isEditing) ...[
        SizedBox(
          height: 50,
          width: fieldDetail.length * 13,
          child: CustomTextInput(
            controller: textController,
            onFieldSubmitted: (newValue) {},
          ),
        ),
      ] else ...[
        Text(
          fieldDetail,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ]
    ],
  );
}
