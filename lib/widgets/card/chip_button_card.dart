import 'package:flutter/material.dart';
import 'package:yes_broker/constants/firebase/inventory_questions.dart';

import '../../Customs/custom_text.dart';
import '../../Customs/responsive.dart';
import '../../constants/colors.dart';

class ChipButtonCard extends StatelessWidget {
  final List<InventoryQuestions> data;
  final int currentQuestionIndex;
  final void Function(String, List<InventoryQuestions>) onSelect;

  const ChipButtonCard({
    super.key,
    required this.onSelect,
    required this.currentQuestionIndex,
    required this.data,
  });

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
                title: data[currentQuestionIndex].question,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 15,
              ),
              for (var answer in data[currentQuestionIndex].options)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: InkWell(
                    onTap: () => {
                      onSelect(answer, data),
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
