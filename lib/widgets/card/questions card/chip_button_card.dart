import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/constants/firebase/questionModels/inventory_question.dart';

import 'package:yes_broker/controllers/all_selected_ansers_provider.dart';
import 'package:yes_broker/widgets/card/questions%20card/chip_button.dart';

import '../../../Customs/custom_text.dart';
import '../../../Customs/responsive.dart';

class ChipButtonCard extends StatelessWidget {
  final String question;
  final List<String> options;
  final int currentIndex;
  final List<InventoryQuestions> data;
  final void Function(String) onSelect;

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
                    onSelect(option),
                  },
                ),
              const SizedBox(
                height: 10,
              ),
              data.length == currentIndex + 1
                  ? Consumer(
                      builder: (context, ref, child) {
                        return CustomButton(
                          text: 'Save',
                          onPressed: () {
                            ref
                                .watch(allChipSelectedAnwersProvider.notifier)
                                .submitInventoryDetails();
                          },
                          height: 40,
                        );
                      },
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}