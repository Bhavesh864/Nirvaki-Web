import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/customs/custom_fields.dart';
import 'package:yes_broker/customs/dropdown_field.dart';
import 'package:yes_broker/customs/label_text_field.dart';
import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/customs/snackbar.dart';
import 'package:yes_broker/customs/text_utility.dart';
import 'package:yes_broker/constants/firebase/Methods/add_member_send_email.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/validation/basic_validation.dart';

import '../../../../constants/utils/constants.dart';
import '../team_screen.dart';

class AddMemberScreen extends ConsumerStatefulWidget {
  const AddMemberScreen({super.key});

  @override
  AddMemberScreenState createState() => AddMemberScreenState();
}

class AddMemberScreenState extends ConsumerState<AddMemberScreen> {
  final key = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  User? manager;
  bool loading = false;
  var role;

  void submitMemberRole() {
    final isvalid = key.currentState?.validate();
    if (isvalid!) {
      setState(() {
        loading = true;
      });
      sendInvitationEmail(
              email: _emailController.text,
              firstname: _firstNameController.text,
              lastname: _lastNameController.text,
              mobile: _mobileController.text,
              managerName: '${manager?.userfirstname} ${manager?.userlastname}',
              managerid: manager?.userId,
              role: role.toString())
          .then((value) => {
                if (value == "success")
                  {
                    backToTeamScreen(),
                    // customSnackBar(context: context, text: "Add Member successfully"),
                    setState(() {
                      loading = false;
                    })
                  }
                else
                  {
                    customSnackBar(context: context, text: value),
                    setState(() {
                      loading = false;
                    })
                  }
              });
    }
  }

  void backToTeamScreen() {
    if (Responsive.isMobile(context)) {
      Navigator.of(context).pop();
    }
    ref.read(addMemberScreenStateProvider.notifier).setAddMemberScreenState(false);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(20),
      child: loading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : Container(
              padding: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    child: Form(
                      key: key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppText(
                            text: "Add Team Member",
                            fontsize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                          SizedBox(height: height! * 0.04),
                          LabelTextInputField(
                            labelText: "First Name",
                            inputController: _firstNameController,
                            validator: (value) => validateForNormalFeild(value: value, props: "First Name"),
                          ),
                          LabelTextInputField(
                            labelText: "Last Name",
                            inputController: _lastNameController,
                            validator: (value) => validateForNormalFeild(value: value, props: "Last Name"),
                          ),
                          LabelTextInputField(
                              labelText: "Mobile", inputController: _mobileController, validator: (value) => validateForMobileNumberFeild(value: value, props: "Mobile")),
                          LabelTextInputField(
                            labelText: "Email",
                            inputController: _emailController,
                            validator: (value) => validateEmail(value),
                          ),
                          FutureBuilder(
                              future: User.getAllUsers(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final List<String> userNames = snapshot.data!.map((user) => "${user.userfirstname} ${user.userlastname}").toList();
                                  return DropDownField(
                                      title: "Manager",
                                      optionsList: userNames,
                                      onchanged: (e) {
                                        setState(() {
                                          User selectedUser = snapshot.data!.firstWhere((user) => '${user.userfirstname} ${user.userlastname}' == e);
                                          manager = selectedUser;
                                        });
                                      });
                                }
                                return DropDownField(title: "Manager", optionsList: const [], onchanged: (e) {});
                              }),
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
                                onPressed: () => submitMemberRole(),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
