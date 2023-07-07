import 'package:flutter/material.dart';

import '../../Customs/custom_text.dart';
import '../../Customs/responsive.dart';
import '../../constants/colors.dart';

class ChipButtonCard extends StatelessWidget {
  final List<String> questions;
  final int currentQuestionIndex;
  final List answers;
  final void Function(String) onSelect;
  const ChipButtonCard(
      {super.key,
      required this.questions,
      required this.answers,
      required this.onSelect,
      required this.currentQuestionIndex});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
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
                title: questions[currentQuestionIndex],
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 15,
              ),
              for (var answer in answers[currentQuestionIndex])
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: InkWell(
                    onTap: () => {
                      onSelect(answer),
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColor.secondary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CustomText(
                          title: answer,
                        )),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
