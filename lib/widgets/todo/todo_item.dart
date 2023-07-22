// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';

import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/widgets/custom_chip.dart';

import '../../constants/utils/image_constants.dart';

class TodoItem extends StatefulWidget {
  const TodoItem({super.key});

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
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
    final textTheme = Theme.of(context).textTheme;

    return ListView.builder(
      shrinkWrap: true,
      physics: Responsive.isMobile(context) ? const NeverScrollableScrollPhysics() : const ClampingScrollPhysics(),
      itemCount: userData.length,
      itemBuilder: ((context, index) => Card(
            margin: EdgeInsets.only(
              left: width! < 1280 && width! > 1200 ? 0 : 10,
              right: width! < 1280 && width! > 1200 ? 0 : 10,
              bottom: 15,
            ),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
              ),
              height: 155,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(
                          // height: 30,
                          width: Responsive.isMobile(context) ? 170 : 150,
                          child: ListView(
                            physics: const ClampingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            children: [
                              CustomChip(
                                label: Icon(
                                  userData[index].isLead ? MaterialSymbols.location_home_outlined : MaterialSymbols.location_away,
                                  color: userData[index].isLead ? AppColor.inventoryIconColor : AppColor.leadIconColor,
                                  size: 18,
                                ),
                                color: userData[index].isLead ? AppColor.inventoryChipColor : AppColor.leadChipColor,
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
                                itemBuilder: (context) => dropDownListData.map((e) => popupMenuItem(e.toString())).toList(),
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
                              avatar: Icon(
                                Icons.calendar_month_outlined,
                                color: Colors.black,
                                size: 14,
                              ),
                              label: FittedBox(
                                child: CustomText(
                                  title: '23 May 2023',
                                  size: 10,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 20,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    userData[index].task!,
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    userData[index].subtitle!,
                    style: textTheme.titleSmall,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 3),
                        child: Text(
                          userData[index].name!,
                          style: textTheme.titleMedium,
                        ),
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
                        label: Icon(
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
                        margin: const EdgeInsets.only(right: 5),
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                          image: const DecorationImage(image: AssetImage(profileImage)),
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
