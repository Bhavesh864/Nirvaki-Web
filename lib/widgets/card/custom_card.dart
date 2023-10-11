// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/widgets/card/card_footer.dart';
import 'package:yes_broker/widgets/card/card_header.dart';

class CustomCard extends StatelessWidget {
  final int index;
  final List<CardDetails> cardDetails;
  const CustomCard({super.key, required this.index, required this.cardDetails});

  // getdata() async {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 9),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardHeader(index: index, cardDetails: cardDetails),
            const SizedBox(height: 10),
            Text(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              cardDetails[index].cardTitle!,
              style: const TextStyle(
                fontSize: 14,
                letterSpacing: 0.5,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              cardDetails[index].cardDescription!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            CardFooter(index: index, cardDetails: cardDetails),
          ],
        ),
      ),
    );
  }
}
