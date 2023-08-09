// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/firebase/detailsModels/inventory_details.dart';

import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/widgets/card/card_footer.dart';
import 'package:yes_broker/widgets/card/card_header.dart';

class CustomCard extends StatefulWidget {
  final int index;
  final List<CardDetails> cardDetails;

  const CustomCard({super.key, required this.index, required this.cardDetails});

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  void initState() {
    super.initState();
    getdata();
  }

  getdata() async {
    final InventoryDetails? item = await InventoryDetails.getInventoryDetails(widget.cardDetails[0].workitemId);
    print("==========>${item?.customerinfo?.firstname}");
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      // margin: EdgeInsets.only(
      //   left: width! < 1280 && width! > 1200 ? 0 : 10,
      //   right: width! < 1280 && width! > 1200 ? 0 : 10,
      //   bottom: 15,
      // ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardHeader(index: widget.index, cardDetails: widget.cardDetails),
            const SizedBox(height: 10),
            Text(
              widget.cardDetails[widget.index].cardTitle!,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.cardDetails[widget.index].cardDescription!,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            CardFooter(index: widget.index, cardDetails: widget.cardDetails),
          ],
        ),
      ),
    );
  }
}
