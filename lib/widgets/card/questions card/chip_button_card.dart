import 'package:flutter/material.dart';
import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/constants/firebase/inventory_questions.dart';
import 'package:yes_broker/widgets/card/questions%20card/chip_button.dart';

import '../../../Customs/custom_text.dart';
import '../../../Customs/responsive.dart';

class ChipButtonCard extends StatelessWidget {
  final String question;
  final List<String> options;
  final int currentIndex;
  final List<InventoryQuestions> data;
  final void Function(String, List<InventoryQuestions>) onSelect;

  const ChipButtonCard({
    super.key,
    required this.onSelect,
    required this.question,
    required this.options,
    required this.data,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
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
          width: Responsive.isMobile(context) ? w * 0.9 : 650,
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                softWrap: true,
                textAlign: TextAlign.center,
                size: 30,
                title: question,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 15,
              ),
              for (var option in options)
                ChipButton(
                  text: option,
                  onSelect: () => {
                    onSelect(option, data),
                  },
                ),
              const SizedBox(
                height: 10,
              ),
              data.length == currentIndex + 1
                  ? CustomButton(
                      text: 'Save',
                      onPressed: () {},
                      height: 40,
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
