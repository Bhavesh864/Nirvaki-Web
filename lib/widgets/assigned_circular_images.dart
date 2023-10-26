// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../Customs/custom_text.dart';
import '../constants/app_constant.dart';
import '../constants/firebase/userModel/user_info.dart';
import '../constants/utils/constants.dart';

class AssignedCircularImages extends StatefulWidget {
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
  State<AssignedCircularImages> createState() => _AssignedCircularImagesState();
}

class _AssignedCircularImagesState extends State<AssignedCircularImages> {
  List<User> assigned = [];

  void setassignedData() async {
    final userids = [];
    for (var data in widget.cardData.assignedto) {
      userids.add(data.userid);
    }
    if (userids.isNotEmpty) {
      final List<User> userdata = await User.getListOfUsersByIds(userids);
      if (mounted) {
        setState(() {
          assigned = userdata;
        });
      }
    }
  }

  @override
  void initState() {
    setassignedData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: checkNotNUllItem(assigned) && assigned.isNotEmpty
          ? assigned
              .sublist(
                0,
                assigned.length < 2
                    ? 1
                    : assigned.length < 3
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
                  width: widget.widthOfCircles,
                  height: widget.heightOfCircles,
                  decoration: index > 1
                      ? BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1.5),
                          color: index > 1 ? const Color.fromARGB(255, 234, 234, 249) : null,
                          borderRadius: BorderRadius.circular(40),
                        )
                      : BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1.5),
                          image: DecorationImage(
                            image: NetworkImage(
                              user.image.isEmpty ? noImg : user.image,
                              scale: 1,
                            ),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.circular(40),
                        ),
                  child: index > 1
                      ? Center(
                          child: CustomText(
                            title: '+${assigned.length - 2}',
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
