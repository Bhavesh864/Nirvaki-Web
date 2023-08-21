import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/riverpodstate/selected_workitem.dart';
import 'package:yes_broker/widgets/card/custom_card.dart';
import '../../routes/routes.dart';

class WorkItemsList extends ConsumerStatefulWidget {
  final bool isScrollable;
  final bool headerShow;
  final String title;
  final List<CardDetails> getCardDetails;
  const WorkItemsList({super.key, this.headerShow = true, required this.title, required this.getCardDetails, this.isScrollable = true});

  @override
  WorkItemsListState createState() => WorkItemsListState();
}

class WorkItemsListState extends ConsumerState<WorkItemsList> {
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
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
          margin: const EdgeInsets.only(left: 8, right: 3),
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
                  height: Responsive.isMobile(context) ? height : height * 0.79,
                  child: ListView(
                    shrinkWrap: true,
                    addRepaintBoundaries: false,
                    physics: widget.isScrollable ? const ScrollPhysics() : const NeverScrollableScrollPhysics(),
                    children: List.generate(
                      widget.getCardDetails.length,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                            final id = widget.getCardDetails[index].workitemId;
                            if (id!.contains('IN')) {
                              if (Responsive.isMobile(context)) {
                                Navigator.of(context).pushNamed(AppRoutes.inventoryDetailsScreen, arguments: id);
                                ref.read(selectedWorkItemId.notifier).addItemId(id);
                              } else {
                                ref.read(selectedWorkItemId.notifier).addItemId(id);

                                context.beamToNamed('/inventory/inventory-details/$id');
                              }
                            } else if (id.contains('LD')) {
                              if (Responsive.isMobile(context)) {
                                Navigator.of(context).pushNamed(AppRoutes.leadDetailsScreen, arguments: id);
                                ref.read(selectedWorkItemId.notifier).addItemId(id);
                              } else {
                                ref.read(selectedWorkItemId.notifier).addItemId(id);
                                context.beamToNamed('/lead/lead-details/$id');
                              }
                            } else if (id.contains('TD')) {
                              if (Responsive.isMobile(context)) {
                                Navigator.of(context).pushNamed(AppRoutes.todoDetailsScreen, arguments: id);
                                ref.read(selectedWorkItemId.notifier).addItemId(id);
                              } else {
                                ref.read(selectedWorkItemId.notifier).addItemId(id);
                                context.beamToNamed('/todo/todo-details/$id');
                              }
                            }
                          },
                          child: CustomCard(index: index, cardDetails: widget.getCardDetails),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
