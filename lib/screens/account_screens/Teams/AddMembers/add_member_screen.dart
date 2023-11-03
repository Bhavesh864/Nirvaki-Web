import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/constants/user_role.dart';
import 'package:yes_broker/customs/custom_fields.dart';
import 'package:yes_broker/customs/label_text_field.dart';
import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/customs/snackbar.dart';
import 'package:yes_broker/customs/text_utility.dart';
import 'package:yes_broker/constants/firebase/Methods/add_member_send_email.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/validation/basic_validation.dart';
import 'package:yes_broker/riverpodstate/add_member_state.dart';
import '../../../../Customs/dropdown_field.dart';
import '../../../../constants/utils/constants.dart';
import '../../../../pages/Auth/signup/country_code_modal.dart';
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
  String mobileCountryCode = '+91';
  String mobileNoValidation = '';

  void submitMemberRole() {
    final isEdit = ref.read(editAddMemberState);
    final editUser = ref.read(userForEditScreen);

    final isvalid = key.currentState?.validate();
    if (_mobileController.text.isEmpty) {
      setState(() {
        mobileNoValidation = 'Please enter Mobile Number';
      });
      return;
    } else if (_mobileController.text.trim().length < 10) {
      setState(() {
        mobileNoValidation = 'Please enter 10 digit Mobile Number';
      });
      return;
    } else {
      setState(() {
        mobileNoValidation = '';
      });
    }
    if (isvalid!) {
      setState(() {
        loading = true;
      });
      if (isEdit) {
        updateTeamMember(
                email: _emailController.text,
                firstname: _firstNameController.text,
                lastname: _lastNameController.text,
                mobile: "$mobileCountryCode ${_mobileController.text}",
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
        sendInvitationEmail(
                email: _emailController.text,
                firstname: _firstNameController.text,
                lastname: _lastNameController.text,
                mobile: "$mobileCountryCode ${_mobileController.text}",
                managerName: '${manager?.userfirstname} ${manager?.userlastname}',
                managerid: manager?.userId,
                role: role)
            .then((value) => {
                  if (value == "success")
                    {
                      backToTeamScreen(),
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
      _emailController.text = editUser?.email ?? '';
      // _mobileController.text = editUser?.mobile ?? '';
      List<String>? splitString = editUser?.mobile.split(' ');
      if (splitString!.length == 1) {
        _mobileController.text = splitString[0];
      }
      if (splitString.length == 2) {
        mobileCountryCode = splitString[0];
        _mobileController.text = splitString[1];
      }
    }
  }

  void openModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CountryCodeModel(onCountrySelected: (data) {
          if (data.isNotEmpty) {
            setState(() {
              mobileCountryCode = data;
            });
          }
        });
      },
    );
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

    return GestureDetector(
      onTap: () {
        if (!kIsWeb) FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Card(
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
                              maxLength: 30,
                              inputController: _firstNameController,
                              validator: (value) => validateForNormalFeild(value: value, props: "First Name"),
                              isMandatory: true,
                            ),
                            const SizedBox(height: 4),
                            LabelTextInputField(
                              maxLength: 30,
                              labelText: "Last Name",
                              inputController: _lastNameController,
                              // validator: (value) => validateForNormalFeild(value: value, props: "Last Name"),
                            ),
                            const SizedBox(height: 4),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MobileNumberInputField(
                                  fromProfile: true,
                                  controller: _mobileController,
                                  hintText: "Mobile",
                                  isEmpty: mobileNoValidation == '' ? false : true,
                                  openModal: () {
                                    openModal(context);
                                  },
                                  countryCode: mobileCountryCode,
                                  onChange: (value) {},
                                ),
                                if (mobileNoValidation != '')
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0, bottom: 5),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: AppText(
                                        text: mobileNoValidation,
                                        textColor: Colors.red,
                                        fontsize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            LabelTextInputField(
                              isMandatory: true,
                              labelText: "Email",
                              maxLength: 50,
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
                                      child: CustomDropdownFormField<String>(
                                        label: "Manager",
                                        value: isEdit ? editUser?.managerName : editManagerName,
                                        isMandatory: true,
                                        items: userNames,
                                        onChanged: (value) {
                                          setState(() {
                                            editManagerName = value;
                                            User selectedUser = snapshot.data!.firstWhere((user) => '${user.userfirstname} ${user.userlastname}' == value);
                                            manager = selectedUser;
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please select Manager';
                                          }
                                          return null;
                                        },
                                      ),
                                    );
                                  }
                                  return Container(
                                    margin: const EdgeInsets.all(5),
                                    child: CustomDropdownFormField<String>(
                                        label: "Manager", value: isEdit ? editUser?.managerName : editManagerName, isMandatory: true, items: const [], onChanged: (e) {}),
                                  );
                                }),
                            Container(
                              margin: const EdgeInsets.all(5),
                              child: CustomDropdownFormField<String>(
                                label: "Role",
                                value: isEdit ? editUser?.role : role,
                                isMandatory: true,
                                items: const ["Employee", "Manager"],
                                onChanged: (value) {
                                  setState(() {
                                    role = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select role';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CustomButton(
                                  textStyle: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1),
                                  height: 39,
                                  text: "Cancel",
                                  borderColor: AppColor.primary,
                                  onPressed: backToTeamScreen,
                                  buttonColor: Colors.white,
                                  textColor: AppColor.primary,
                                ),
                                const SizedBox(width: 7),
                                CustomButton(
                                  textStyle: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1),
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
      ),
    );
  }
}
