import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yes_broker/Customs/responsive.dart';

import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/widgets/custom_chip.dart';

import '../constants/utils/image_constants.dart';

class AppImage {
  String? image;
  String? task;
  String? subtitle;
  String? name;
  String? time;

  AppImage({this.image, this.task, this.subtitle, this.name, this.time});
}

class WorkItem extends StatefulWidget {
  const WorkItem({super.key});

  @override
  State<WorkItem> createState() => _WorkItemState();
}

class _WorkItemState extends State<WorkItem> {
  PopupMenuItem popupMenuItem(String title) {
    return PopupMenuItem(
      onTap: () {
        setState(() {
          selectedOption = title;
        });
      },
      height: 5,
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Center(
        child: Container(
          width: 200,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColor.secondary,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(title),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: Responsive.isMobile(context)
          ? const NeverScrollableScrollPhysics()
          : const ClampingScrollPhysics(),
      itemCount: workItemData.length,
      itemBuilder: ((context, index) => Card(
            color: AppColor.cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            margin: EdgeInsets.only(
              left: width! < 1280 && width! > 1200 ? 0 : 10,
              right: width! < 1280 && width! > 1200 ? 0 : 10,
              bottom: 15,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              child: SizedBox(
                height: Responsive.isMobile(context) ? 170 : 140,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            // height: 30,
                            width: 260,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              children: [
                                CustomChip(
                                  label: Icon(
                                    userData[index].isLead
                                        ? Icons.person_pin_outlined
                                        : Icons.person_outline,
                                    color: userData[index].isLead
                                        ? AppColor.inventoryIconColor
                                        : AppColor.leadIconColor,
                                    size: 18,
                                    // weight: 10.12,
                                  ),
                                  color: userData[index].isLead
                                      ? AppColor.inventoryChipColor
                                      : AppColor.leadChipColor,
                                ),
                                CustomChip(
                                  label: CustomText(
                                    title: workItemData[index].bhk,
                                    size: 10,
                                  ),
                                ),
                                CustomChip(
                                  label: CustomText(
                                    title: workItemData[index].area,
                                    size: 10,
                                  ),
                                ),
                                CustomChip(
                                  label: CustomText(
                                    title: workItemData[index].price,
                                    size: 10,
                                  ),
                                ),
                                CustomChip(
                                  label: CustomText(
                                    title: workItemData[index].type,
                                    size: 10,
                                  ),
                                ),
                                PopupMenuButton(
                                  tooltip: '',
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
                                          color:
                                              taskStatusColor(selectedOption),
                                          size: 10,
                                        ),
                                        Icon(
                                          Icons.expand_more,
                                          size: 18,
                                          color:
                                              taskStatusColor(selectedOption),
                                        ),
                                      ],
                                    ),
                                    color: taskStatusColor(selectedOption)
                                        .withOpacity(0.1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.chevron_right,
                            size: 20,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomText(
                      title: workItemData[index].title!,
                      size: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CustomText(
                      title: workItemData[index].subtitle!,
                      size: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomText(
                          title: workItemData[index].name!,
                          size: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        const CustomChip(
                          label: Icon(
                            Icons.call_outlined,
                            color: Colors.black,
                            size: 14,
                          ),
                          paddingHorizontal: 4,
                        ),
                        const CustomChip(
                          label: FaIcon(
                            FontAwesomeIcons.whatsapp,
                            color: Colors.black,
                            size: 14,
                          ),
                          paddingHorizontal: 4,
                        ),
                        const CustomChip(
                          label: Icon(
                            Icons.edit_outlined,
                            color: Colors.black,
                            size: 14,
                          ),
                          paddingHorizontal: 4,
                        ),
                        const CustomChip(
                          label: Icon(
                            Icons.share_outlined,
                            color: Colors.black,
                            size: 14,
                          ),
                          paddingHorizontal: 4,
                        ),
                        const Spacer(),
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                                image: AssetImage(profileImage)),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          // child: Text(width.toString()),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget customChipWidget(Widget label, Color color,
      {double paddingHorizontal = 3}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
      child: Chip(
          padding:
              EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: 0),
          labelPadding: const EdgeInsets.all(0),
          side: BorderSide.none,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          label: label),
    );
  }
}
