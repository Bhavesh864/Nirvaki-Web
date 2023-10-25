// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../Customs/custom_text.dart';
import '../constants/app_constant.dart';
import '../constants/utils/constants.dart';

class AssignedCircularImages extends StatelessWidget {
  final dynamic cardData;
  final double heightOfCircles;
  final double widthOfCircles;

  const AssignedCircularImages({
    Key? key,
    required this.cardData,
    required this.heightOfCircles,
    required this.widthOfCircles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: checkNotNUllItem(cardData.assignedto) && cardData.assignedto!.isNotEmpty
          ? cardData.assignedto!
              .sublist(
                0,
                cardData.assignedto!.length < 2
                    ? 1
                    : cardData.assignedto!.length < 3
                        ? 2
                        : 3,
              )
              .asMap()
              .entries
              .map<Widget>((entry) {
              final index = entry.key;
              final user = entry.value;
              return Transform.translate(
                offset: Offset(index * -10.0, 0),
                child: Container(
                  margin: EdgeInsets.zero,
                  width: widthOfCircles,
                  height: heightOfCircles,
                  decoration: index > 1
                      ? BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1.5),
                          color: index > 1 ? Color.fromARGB(255, 234, 234, 249) : null,
                          borderRadius: BorderRadius.circular(40),
                        )
                      : BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1.5),
                          image: DecorationImage(
                            image: NetworkImage(
                              user.image!.isEmpty ? noImg : user.image!,
                              scale: 1,
                            ),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.circular(40),
                        ),
                  child: index > 1
                      ? Center(
                          child: CustomText(
                            title: '+${cardData.assignedto!.length - 2}',
                            color: Colors.black,
                            size: 9,
                            // textAlign: TextAlign.center,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : null,
                ),
              );
            }).toList()
          : [],
    );
  }
}
