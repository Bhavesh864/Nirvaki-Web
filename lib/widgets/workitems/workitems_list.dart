import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/widgets/card/custom_card.dart';

class WorkItemsList extends StatefulWidget {
  final bool headerShow;
  final String title;
  final List<CardDetails> getCardDetails;
  const WorkItemsList({super.key, this.headerShow = true, required this.title, required this.getCardDetails});

  @override
  State<WorkItemsList> createState() => _WorkItemsListState();
}

class _WorkItemsListState extends State<WorkItemsList> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          constraints: BoxConstraints(
            minHeight: height,
          ),
          decoration: BoxDecoration(
            color: AppColor.secondary,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: SafeArea(
            right: false,
            child: Column(
              children: [
                widget.headerShow
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              title: widget.title,
                              fontWeight: FontWeight.w600,
                            ),
                            const Icon(
                              Icons.more_horiz,
                              size: 24,
                            ),
                          ],
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: Responsive.isMobile(context) ? height * 0.75 : height * 0.8,
                  child: ListView(
                    shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    children: List.generate(
                      widget.getCardDetails.length,
                      (index) => CustomCard(index: index, cardDetails: widget.getCardDetails),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
