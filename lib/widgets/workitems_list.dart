import 'package:flutter/material.dart';

import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/widgets/work_items.dart';

class WorkItemsList extends StatelessWidget {
  final bool headerShow;
  const WorkItemsList({super.key, this.headerShow = true});

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        child: Container(
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
                headerShow
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        height: 50,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              title: 'Work Items',
                              fontWeight: FontWeight.w600,
                            ),
                            Icon(Icons.more_horiz),
                          ],
                        ),
                      )
                    : Container(),
                const SizedBox(
                  // height: height! * 0.8,
                  // child: ListView.builder(
                  //   shrinkWrap: true,
                  //   physics: Responsive.isMobile(context)
                  //       ? const NeverScrollableScrollPhysics()
                  //       : const ClampingScrollPhysics(),
                  //   itemCount: workItemData.length,
                  //   itemBuilder: (context, index) {
                  //     return CustomCard(
                  //       index: index,
                  //       isTodoItem: false,
                  //     );
                  //   },
                  // ),
                  child: WorkItem(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
