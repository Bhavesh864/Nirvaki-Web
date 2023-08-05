import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/Customs/dropdown_field.dart';
import 'package:yes_broker/Customs/label_text_field.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/utils/colors.dart';

import '../../../../constants/utils/constants.dart';
import '../team_screen.dart';

class AddMemberScreen extends ConsumerStatefulWidget {
  const AddMemberScreen({super.key});

  @override
  AddMemberScreenState createState() => AddMemberScreenState();
}

class AddMemberScreenState extends ConsumerState<AddMemberScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  var role;
  void backToTeamScreen() {
    if (Responsive.isMobile(context)) {
      Navigator.of(context).pop();
    }
    ref.read(addMemberScreenStateProvider.notifier).setAddMemberScreenState(false);
  }

  Future<void> inviteNewUser(String email) async {
    try {
      await FirebaseAuth.instance
          .sendSignInLinkToEmail(
            email: email,
            actionCodeSettings: ActionCodeSettings(
              url: 'http://localhost:54448/#/signup_screen', // Replace with your dynamic link URL
              handleCodeInApp: true,
              iOSBundleId: 'com.example.yesBroker', // Replace with your iOS bundle ID
              androidPackageName: 'com.example.yes_broker', // Replace with your Android package name
              androidInstallApp: true,
              androidMinimumVersion: '10',
            ),
          )
          .then((value) => {});
      print('Invitation email sent successfully');
    } catch (e) {
      print('Failed to send invitation email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                    text: "Add Team Member",
                    fontsize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: height! * 0.04),
                  LabelTextInputField(labelText: "First Name", inputController: _firstNameController),
                  LabelTextInputField(labelText: "Last Name", inputController: _lastNameController),
                  LabelTextInputField(labelText: "Mobile", inputController: _mobileController),
                  LabelTextInputField(labelText: "Email", inputController: _emailController),
                  DropDownField(title: "Manager", optionsList: const ["Employe", "Manager"], onchanged: (e) {}),
                  DropDownField(
                      title: "Role",
                      optionsList: const ["Employe", "Manager"],
                      onchanged: (e) {
                        setState(() {
                          role = e;
                        });
                      }),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButton(
                        height: 39,
                        text: "cancel",
                        borderColor: AppColor.primary,
                        onPressed: backToTeamScreen,
                        buttonColor: Colors.white,
                        textColor: AppColor.primary,
                      ),
                      const SizedBox(width: 7),
                      CustomButton(
                        text: "Send Invite",
                        borderColor: AppColor.primary,
                        height: 39,
                        onPressed: () => inviteNewUser("manishchayal14@gmail.com"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
