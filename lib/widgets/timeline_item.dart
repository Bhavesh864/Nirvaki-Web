import 'package:flutter/material.dart';

import 'package:yes_broker/constants/constants.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/widgets/custom_chip.dart';

class TimeLineItem extends StatelessWidget {
  final int index;
  const TimeLineItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    var timeLine = timelineData[index];
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 5),
      height: 88,
      width: 100,
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomChip(
                label: CustomText(
                  title: timeLine['id'],
                  size: 12,
                ),
                color: timeLine['isInventory']
                    ? Colors.purple.withOpacity(0.1)
                    : Colors.pink.withOpacity(0.1),
                avatar: Icon(
                  timeLine['isInventory']
                      ? Icons.person_pin_outlined
                      : Icons.person_outline,
                  color: timeLine['isInventory'] ? Colors.purple : Colors.pink,
                  size: 16,
                ),
              ),
              CustomText(
                title: timeLine['title'],
                size: 12,
              )
            ],
          ),
          ListTile(
            horizontalTitleGap: 6,
            titleAlignment: ListTileTitleAlignment.center,
            leading: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                image: const DecorationImage(image: AssetImage(profileImage)),
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            title: CustomText(
              title: timeLine['name'],
              size: 12,
            ),
          ),
        ],
      ),
    );
  }
}
