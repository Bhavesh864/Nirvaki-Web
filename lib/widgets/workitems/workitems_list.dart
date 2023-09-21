import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/widgets/card/custom_card.dart';

import '../../constants/functions/navigation/navigation_functions.dart';

class WorkItemsList extends ConsumerStatefulWidget {
  final String title;
  final List<CardDetails> getCardDetails;

  const WorkItemsList({
    super.key,
    required this.title,
    required this.getCardDetails,
  });

  @override
  WorkItemsListState createState() => WorkItemsListState();
}

class WorkItemsListState extends ConsumerState<WorkItemsList> {
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 8, right: 3),
          child: SafeArea(
            right: false,
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: AppColor.secondary,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  height: 40,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                  ),
                ),
                if (widget.getCardDetails.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                    decoration: const BoxDecoration(
                      color: AppColor.secondary,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      addRepaintBoundaries: false,
                      physics: const ScrollPhysics(),
                      children: List.generate(
                        widget.getCardDetails.length,
                        (index) {
                          return GestureDetector(
                            onTap: () {
                              final id = widget.getCardDetails[index].workitemId;
                              navigateBasedOnId(context, id!, ref);
                            },
                            child: CustomCard(index: index, cardDetails: widget.getCardDetails),
                          );
                        },
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
