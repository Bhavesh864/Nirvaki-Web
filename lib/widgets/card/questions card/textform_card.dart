import 'package:flutter/material.dart';
import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/constants/colors.dart';
import 'package:yes_broker/constants/constants.dart';

import '../../../Customs/label_text_field.dart';
import '../../../Customs/responsive.dart';

class TextFormCard extends StatefulWidget {
  final List<String> fieldsPlaceholder;
  const TextFormCard({super.key, required this.fieldsPlaceholder});

  @override
  State<TextFormCard> createState() => _TextFormCardState();
}

class _TextFormCardState extends State<TextFormCard> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    TextEditingController inputController = TextEditingController();
    // final w = MediaQuery.of(context).size.width;

    return Center(
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 0,
            maxHeight: double.infinity,
          ),
          width: Responsive.isMobile(context) ? width! * 0.9 : 650,
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomText(
                title: 'Coustmer Details',
                fontWeight: FontWeight.w700,
                size: 22,
              ),
              LabelTextInputField(
                  inputController: inputController,
                  labelText: widget.fieldsPlaceholder[0]),
              LabelTextInputField(
                  inputController: inputController,
                  labelText: widget.fieldsPlaceholder[1]),
              LabelTextInputField(
                  inputController: inputController,
                  labelText: widget.fieldsPlaceholder[2]),
              Padding(
                padding: const EdgeInsets.only(bottom: 7.0),
                child: CustomCheckbox(
                  fillColor: AppColor.primary,
                  value: isChecked,
                  label: 'Use Same number for whatsapp',
                  onChanged: (newVal) {
                    setState(() {
                      isChecked = newVal;
                    });
                  },
                ),
              ),
              !isChecked
                  ? LabelTextInputField(
                      inputController: inputController,
                      labelText: 'Whatsapp Number')
                  : Container(),
              LabelTextInputField(
                  inputController: inputController, labelText: 'Email'),
              LabelTextInputField(
                  inputController: inputController, labelText: 'Company Name'),
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(top: 8),
                child: CustomButton(
                  width: 73,
                  text: 'Next',
                  onPressed: () {},
                  height: 39,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
