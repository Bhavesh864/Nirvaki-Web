import 'package:flutter/material.dart';
import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/Customs/dropdown_field.dart';
import 'package:yes_broker/Customs/label_text_field.dart';
import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/utils/colors.dart';

import '../../../../constants/utils/constants.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(20),
      child: Container(
        width: width,
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
                  DropDownField(title: "Role", optionsList: const ["Employe", "Manager"], onchanged: (e) {}),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButton(
                        height: 39,
                        text: "cancel",
                        borderColor: AppColor.primary,
                        onPressed: () {},
                        buttonColor: Colors.white,
                        textColor: AppColor.primary,
                      ),
                      const SizedBox(width: 7),
                      CustomButton(
                        text: "Send Invite",
                        borderColor: AppColor.primary,
                        height: 39,
                        onPressed: () {},
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
