import 'package:flutter/material.dart';
import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/utils/image_constants.dart';

import '../../Customs/custom_text.dart';
import '../../constants/utils/colors.dart';

class EmptyWorkItemList extends StatelessWidget {
  const EmptyWorkItemList({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: size.width > 1340 ? 3 : 5,
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                      color: AppColor.secondary,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    height: 50,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          title: 'To Do',
                          fontWeight: FontWeight.w600,
                        ),
                        Icon(
                          Icons.more_horiz,
                          size: 24,
                        ),
                      ],
                    ),
                  )),
            ),
            size.width > 1200
                ? Expanded(
                    flex: size.width > 1340 ? 3 : 5,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                            color: AppColor.secondary,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          height: 50,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                title: 'Work Items',
                                fontWeight: FontWeight.w600,
                              ),
                              Icon(
                                Icons.more_horiz,
                                size: 24,
                              ),
                            ],
                          ),
                        )),
                  )
                : Container(),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 70),
          child: Center(
            child: Column(
              children: [
                Image.asset(emptyListImage),
                const SizedBox(
                  height: 12,
                ),
                const AppText(
                  text: 'Nothing to see here',
                  fontsize: 19,
                  fontWeight: FontWeight.w700,
                  textColor: Colors.black,
                ),
                Container(
                  alignment: Alignment.center,
                  width: 500,
                  margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: const AppText(
                    text: 'Start creating your first Inventory, Lead or To Do...',
                    fontsize: 15,
                    fontWeight: FontWeight.w400,
                    textColor: Color(0xFF797979),
                  ),
                )
              ],
            ),
          ),
        ),
        // Container(
        //   margin: const EdgeInsets.only(top: 10),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       CustomButton(text: 'Add Work Item', onPressed: () {}),
        //       const SizedBox(width: 15),
        //       CustomButton(text: 'Add To do', onPressed: () {}),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
