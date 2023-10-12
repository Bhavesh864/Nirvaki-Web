import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/constants/user_role.dart';

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
import 'package:yes_broker/riverpodstate/add_member_state.dart';

import '../../../../constants/utils/constants.dart';
import '../../../../riverpodstate/user_data.dart';
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
  String? editManagerName;
  String? editRoleName;
  String? role;

  void submitMemberRole() {
    final isEdit = ref.read(editAddMemberState);
    final editUser = ref.read(userForEditScreen);

    final isvalid = key.currentState?.validate();
    if (isvalid!) {
      setState(() {
        loading = true;
      });
      if (isEdit) {
        updateTeamMember(
                email: _emailController.text,
                firstname: _firstNameController.text,
                lastname: _lastNameController.text,
                mobile: _mobileController.text,
                managerName: manager != null ? '${manager?.userfirstname} ${manager?.userlastname}' : editUser?.managerName,
                managerid: manager != null ? manager?.userId : editUser?.managerid,
                role: role ?? editUser?.role,
                brokerId: editUser?.brokerId,
                userId: editUser?.userId,
                fcmToken: editUser?.fcmToken,
                imageUrl: editUser?.image,
                status: editUser?.status,
                isOnline: editUser?.isOnline,
                ref: ref)
            .then((value) => {
                  if (value == "success")
                    {
                      backToTeamScreen(),
                      customSnackBar(context: context, text: "Member Updated Successfully"),
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
      } else {
        if (manager != null && role != null) {
          sendInvitationEmail(
                  email: _emailController.text,
                  firstname: _firstNameController.text,
                  lastname: _lastNameController.text,
                  mobile: _mobileController.text,
                  managerName: '${manager?.userfirstname} ${manager?.userlastname}',
                  managerid: manager?.userId,
                  role: role)
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
        } else {
          customSnackBar(context: context, text: "Please Fill All Details");
        }
      }
    }
  }

  void backToTeamScreen() {
    if (Responsive.isMobile(context)) {
      Navigator.of(context).pop();
    } else {
      ref.read(addMemberScreenStateProvider.notifier).setAddMemberScreenState(false);
    }
  }

  void setEditDataToTextField() {
    final editUser = ref.read(userForEditScreen);
    final isEdit = ref.read(editAddMemberState);
    if (isEdit) {
      _firstNameController.text = editUser?.userfirstname ?? '';
      _lastNameController.text = editUser?.userlastname ?? '';
      _mobileController.text = editUser?.mobile ?? '';
      _emailController.text = editUser?.email ?? '';
    }
  }

  @override
  void initState() {
    super.initState();
    setEditDataToTextField();
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUserData = ref.read(userDataProvider);
    final isEdit = ref.read(editAddMemberState);
    final editUser = ref.read(userForEditScreen);

    return Card(
      elevation: Responsive.isMobile(context) ? 0 : 5,
      // margin: const EdgeInsets.all(20),
      child: loading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Container(
              height: Responsive.isMobile(context) ? 690 : double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    child: Form(
                      key: key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(12),
                            child: const AppText(
                              text: "Add Team Member",
                              fontsize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: height! * 0.04),
                          LabelTextInputField(
                            labelText: "First Name",
                            inputController: _firstNameController,
                            validator: (value) => validateForNormalFeild(value: value, props: "First Name"),
                            isMandatory: true,
                          ),
                          const SizedBox(height: 4),
                          LabelTextInputField(
                            labelText: "Last Name",
                            inputController: _lastNameController,
                            // validator: (value) => validateForNormalFeild(value: value, props: "Last Name"),
                          ),
                          const SizedBox(height: 4),
                          LabelTextInputField(
                              isMandatory: true,
                              onlyDigits: true,
                              labelText: "Mobile",
                              inputController: _mobileController,
                              validator: (value) => validateForMobileNumberFeild(value: value, props: "Mobile")),
                          const SizedBox(height: 4),
                          LabelTextInputField(
                            isMandatory: true,
                            labelText: "Email",
                            inputController: _emailController,
                            readyOnly: isEdit ? true : false,
                            validator: (value) => validateEmail(value),
                          ),
                          FutureBuilder(
                              future: User.getAllUsers(currentUserData!),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final filter = snapshot.data?.where((element) => element.userId != editUser?.userId && element.role != UserRole.employee).toList();
                                  final List<String> userNames = filter!.map((user) => "${user.userfirstname} ${user.userlastname}").toList();
                                  return Container(
                                    margin: const EdgeInsets.all(5),
                                    child: DropDownField(
                                        defaultValues: isEdit ? editUser?.managerName : "",
                                        title: "Manager",
                                        optionsList: userNames,
                                        onchanged: (e) {
                                          setState(() {
                                            User selectedUser = snapshot.data!.firstWhere((user) => '${user.userfirstname} ${user.userlastname}' == e);
                                            manager = selectedUser;
                                          });
                                        }),
                                  );
                                }
                                return Container(
                                    margin: const EdgeInsets.all(5),
                                    child: DropDownField(title: "Manager", defaultValues: isEdit ? editUser?.managerName : "", optionsList: const [], onchanged: (e) {}));
                              }),
                          Container(
                            margin: const EdgeInsets.all(5),
                            child: DropDownField(
                                title: "Role",
                                defaultValues: isEdit ? editUser?.role : "",
                                optionsList: const ["Employee", "Manager"],
                                onchanged: (e) {
                                  setState(() {
                                    role = e as String?;
                                  });
                                }),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CustomButton(
                                textStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
                                height: 39,
                                text: "cancel",
                                borderColor: AppColor.primary,
                                onPressed: backToTeamScreen,
                                buttonColor: Colors.white,
                                textColor: AppColor.primary,
                              ),
                              const SizedBox(width: 7),
                              CustomButton(
                                textStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
                                text: isEdit ? "Update" : "Send Invite",
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
