// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/constants/colors.dart';

import '../../Customs/responsive.dart';
import '../../constants/constants.dart';
import '../app/app_bar.dart';
import '../custom_chip.dart';

class CardHeader extends StatelessWidget {
  final int index;
  final bool? showWorkItem;
  final bool? showTask;
  final bool? showTag1;
  final bool? showTag2;
  final bool? showTag3;
  final bool? showTag4;
  final bool? showTag5;
  final bool? showTag6;
  final bool? showStatus;
  final bool? showDate;
  const CardHeader({
    Key? key,
    required this.index,
    this.showWorkItem = true,
    this.showTask = true,
    this.showTag1 = false,
    this.showTag2 = false,
    this.showTag3 = false,
    this.showTag4 = false,
    this.showTag5 = false,
    this.showTag6 = false,
    this.showStatus = true,
    this.showDate = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 30,
          width: Responsive.isMobile(context) ? 170 : 150,
          child: ListView(
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: [
              CustomChip(
                label: Icon(
                  userData[index].isLead
                      ? Icons.person_pin_outlined
                      : Icons.person_outline,
                  color: userData[index].isLead ? Colors.pink : Colors.purple,
                  size: 18,
                ),
                color: userData[index].isLead
                    ? Colors.pink.withOpacity(0.1)
                    : Colors.purple.withOpacity(0.1),
              ),
              CustomChip(
                label: CustomText(
                  title: userData[index].todoType,
                  size: 10,
                  color: AppColor.primary,
                ),
                color: AppColor.primary.withOpacity(0.1),
              ),
              PopupMenuButton(
                initialValue: selectedOption,
                splashRadius: 0,
                padding: EdgeInsets.zero,
                color: Colors.white.withOpacity(1),
                offset: const Offset(10, 40),
                itemBuilder: (context) => dropDownListData
                    .map((e) => popupMenuItem(e.toString()))
                    .toList(),
                child: CustomChip(
                  label: Row(
                    children: [
                      CustomText(
                        title: selectedOption,
                        color: taskStatusColor(selectedOption),
                        size: 10,
                      ),
                      Icon(
                        Icons.expand_more,
                        size: 18,
                        color: taskStatusColor(selectedOption),
                      ),
                    ],
                  ),
                  color: taskStatusColor(selectedOption).withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        const Row(
          children: [
            CustomChip(
              label: Row(
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.black,
                    size: 12,
                  ),
                  FittedBox(
                    child: CustomText(
                      title: '23 May 2023',
                      size: 10,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
            )
          ],
        )
      ],
    );
  }
}
