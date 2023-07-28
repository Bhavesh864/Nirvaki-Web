import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/widgets/timeline_item.dart';

class CustomTimeLineView extends StatelessWidget {
  const CustomTimeLineView({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Row(
              children: [],
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: ListView.builder(
                  itemCount: timelineData.length + 1,
                  itemBuilder: (context, index) {
                    return index < timelineData.length
                        ? TimelineTile(
                            isFirst: index == 0 ? true : false,
                            indicatorStyle: const IndicatorStyle(
                              color: AppColor.primary,
                              height: 8,
                              width: 8,
                              padding: EdgeInsets.only(
                                left: 15,
                              ),
                            ),
                            beforeLineStyle: const LineStyle(
                              color: AppColor.primary,
                              thickness: 2,
                            ),
                            alignment: TimelineAlign.start,
                            endChild: TimeLineItem(index: index),
                          )
                        : TimelineTile(
                            isLast: true,
                            indicatorStyle: const IndicatorStyle(
                              indicator: CircleAvatar(
                                backgroundColor: AppColor.primary,
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                              padding: EdgeInsets.only(
                                left: 9,
                              ),
                            ),
                            beforeLineStyle: const LineStyle(
                              color: AppColor.primary,
                              thickness: 2,
                            ),
                            alignment: TimelineAlign.start,
                          );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
