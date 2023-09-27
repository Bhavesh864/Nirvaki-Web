// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:image_picker/image_picker.dart';
import 'package:yes_broker/constants/firebase/Methods/add_member_send_email.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';

import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/riverpodstate/user_data.dart';

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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: Responsive.isMobile(context) ? 0 : 10),
          child: StreamBuilder(
              stream: userInfo,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                }
                if (snapshot.hasData) {
                  final dataList = snapshot.data;
                  User userInfo = User.fromSnapshot(dataList!);
                  return SingleChildScrollView(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (Responsive.isMobile(context))
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                            // padding: EdgeInsets.only(left: 5.0, bottom: 10),
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
                        SizedBox(height: Responsive.isMobile(context) ? 20 : 40),
                        CustomAddressAndProfileCard(
                          title: 'Personal Information',
                          isPersonalDetails: true,
                          userData: userInfo,
                        ),
                        SizedBox(height: Responsive.isMobile(context) ? 20 : 40),
                        CustomAddressAndProfileCard(
                          title: 'Address',
                          isPersonalDetails: false,
                          userData: userInfo,
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
        ),
      ),
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
  File? profilePhoto;
  Uint8List? webProfile;
  String? uploadProfile;

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
      } else {
        setState(() {
          profilePhoto = imageUrl;
        });
        return imageUrl;
      }
    }
    return '';
  }

  void submitPhoto() {
    final userData = widget.userData;
    updateTeamMember(
            email: userData.email,
            firstname: userData.userfirstname,
            lastname: userData.userfirstname,
            mobile: userData.mobile,
            managerName: userData.managerName,
            managerid: userData.managerid,
            role: userData.role,
            brokerId: userData.brokerId,
            userId: userData.userId,
            fcmToken: userData.fcmToken,
            imageUrl: uploadProfile,
            status: userData.status,
            isOnline: userData.isOnline,
            ref: ref)
        .then((value) => {
              uploadProfile = '',
              profilePhoto = null,
              webProfile = null,
              cancelEditingFullName(),
            });
  }

  @override
  Widget build(BuildContext context) {
    final userData = widget.userData;
    if (widget.title == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 15, top: 10, bottom: 10),
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
                      backgroundImage: isNameEditing ? null : NetworkImage(userData.image),
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
                    if (Responsive.isMobile(context)) ...[
                      InkWell(
                        onTap: () {
                          cancelEditingFullName();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            Icons.cancel_outlined,
                            size: 25,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ] else ...[
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
                    ],
                    const SizedBox(width: 7),
                    if (Responsive.isDesktop(context)) ...[
                      CustomButton(
                        text: "Save",
                        borderColor: AppColor.primary,
                        height: 39,
                        onPressed: () {
                          submitPhoto();
                        },
                      ),
                    ] else ...[
                      InkWell(
                        onTap: () {
                          submitPhoto();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            Icons.check,
                            size: 25,
                            color: AppColor.primary,
                          ),
                        ),
                      )
                    ],
                  ],
                ),
              ] else ...[
                GestureDetector(
                  onTap: () {
                    startEditingFullName("${userData.userfirstname} ${userData.userlastname}");
                  },
                  child: const EditBlock(),
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
                                    isOnline: userData.isOnline,
                                    ref: ref)
                                .then((value) => {
                                      cancelEditingPersonalDetails(),
                                    });
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
                      child: const EditBlock(),
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
                        buildInfoFields('First name', userData.userfirstname, isPersonalDetailsEditing, firstNameController, context),
                        buildInfoFields('Last Name ', userData.userlastname, isPersonalDetailsEditing, lastNameController, context),
                        if (Responsive.isDesktop(context)) ...[const SizedBox()],
                      ])
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Table(
                    children: [
                      TableRow(children: [
                        buildInfoFields('Email address', userData.email, isPersonalDetailsEditing, emailController, context),
                        buildInfoFields('Phone ', userData.mobile, isPersonalDetailsEditing, phoneController, context),
                        if (!Responsive.isMobile(context)) buildInfoFields('Employee ID', userData.userId, false, TextEditingController(), context),
                      ])
                    ],
                  ),
                ),
                if (Responsive.isMobile(context)) buildInfoFields('Employee ID', userData.userId, false, TextEditingController(), context),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Table(
                    children: [
                      TableRow(children: [
                        buildInfoFields('City', 'New Delhi', false, TextEditingController(), context),
                        buildInfoFields('State ', 'Delhi', false, TextEditingController(), context),
                        const SizedBox()
                      ])
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Table(
                    children: [
                      TableRow(children: [
                        buildInfoFields('Country', 'India', false, TextEditingController(), context),
                        buildInfoFields('Pin Code ', '110077', false, TextEditingController(), context),
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

Widget buildInfoFields(String fieldName, String fieldDetail, bool isEditing, TextEditingController textController, BuildContext context) {
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
          width: Responsive.isDesktop(context) ? 300 : 160,
          // width: fieldDetail.length * 15,
          child: CustomTextInput(
            controller: textController,
            onFieldSubmitted: (newValue) {},
          ),
        ),
      ] else ...[
        const SizedBox(height: 3),
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

Future<String> uploadImageToFirebases(imageUrl) async {
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
    return imageUrl;
  } catch (e) {
    print(e);
    return '';
  }
}

class EditBlock extends StatelessWidget {
  const EditBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xff898989).withOpacity(0.5),
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Row(
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
    );
  }
}
