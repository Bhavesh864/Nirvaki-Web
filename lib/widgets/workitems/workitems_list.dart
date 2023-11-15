import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/Customs/loader.dart';

import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/riverpodstate/common_index_state.dart';
import 'package:yes_broker/widgets/card/custom_card.dart';

import '../../constants/functions/navigation/navigation_functions.dart';

class WorkItemsList extends ConsumerStatefulWidget {
  final bool isScrollable;
  final bool headerShow;
  final String title;
  final List<CardDetails> getCardDetails;
  final ScrollController? scrollercontroller;
  final bool loading;
  const WorkItemsList({
    super.key,
    this.headerShow = true,
    required this.title,
    required this.getCardDetails,
    this.isScrollable = true,
    this.scrollercontroller,
    this.loading = false,
  });

  @override
  WorkItemsListState createState() => WorkItemsListState();
}

class WorkItemsListState extends ConsumerState<WorkItemsList> {
  @override
  Widget build(BuildContext context) {
    if (Responsive.isMobile(context)) {
      return SafeArea(
        right: false,
        child: Column(
          children: [
            if (widget.headerShow)
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: AppColor.secondary,
                ),
                padding: const EdgeInsets.only(left: 10, right: 15, top: 10),
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      title: widget.title,
                      fontWeight: FontWeight.w600,
                      size: 15,
                    ),
                    const Icon(
                      Icons.more_horiz,
                      size: 22,
                    ),
                  ],
                ),
              ),
            if (widget.getCardDetails.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 0),
                decoration: const BoxDecoration(
                  color: AppColor.secondary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  }),
                  child: ListView(
                    shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    addRepaintBoundaries: false,
                    children: List.generate(
                      widget.getCardDetails.length,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                            final id = widget.getCardDetails[index].workitemId;
                            ref.read(detailsPageIndexTabProvider.notifier).update(
                                  (state) => 0,
                                );
                            navigateBasedOnId(context, id!, ref);
                          },
                          child: CustomCard(index: index, cardDetails: widget.getCardDetails),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ]
          ],
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColor.secondary,
        ),
        padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 10),
        child: Column(
          children: [
            if (widget.headerShow)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, left: 4),
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
            Expanded(
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(scrollbars: false),
                child: ListView.builder(
                  controller: widget.scrollercontroller,
                  itemCount: widget.getCardDetails.length,
                  shrinkWrap: true,
                  addRepaintBoundaries: false,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        final id = widget.getCardDetails[index].workitemId;
                        ref.read(detailsPageIndexTabProvider.notifier).update(
                              (state) => 0,
                            );
                        navigateBasedOnId(context, id!, ref, fromHome: true);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: CustomCard(
                          index: index,
                          cardDetails: widget.getCardDetails,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            widget.loading ? Loader() : SizedBox(),
          ],
        ),
      );
    }
  }
}
