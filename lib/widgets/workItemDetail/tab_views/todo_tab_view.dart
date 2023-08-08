import 'package:flutter/material.dart';

import '../../../constants/firebase/detailsModels/card_details.dart';
import '../../card/custom_card.dart';

class TodoTabView extends StatelessWidget {
  final List<CardDetails> cardDetails;
  const TodoTabView({super.key, required this.cardDetails});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      child: ListView.builder(
          itemCount: cardDetails.length,
          itemBuilder: (context, index) {
            return CustomCard(index: index, cardDetails: cardDetails);
          }),
    );
  }
}
