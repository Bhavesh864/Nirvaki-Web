// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../Customs/custom_text.dart';
import '../constants/app_constant.dart';
import '../constants/firebase/Hive/hive_methods.dart';
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

  void getdataFromLocalStorage() async {
    List<User> retrievedUsers = await UserListPreferences.getUserList();
    if (mounted) {
      setState(() {
        assigned = retrievedUsers;
      });
    }
  }

  User getNamesMatchWithid(id) {
    final User userArr = assigned.firstWhere((element) => id == element.userId);
    return userArr;
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1)).then((value) => getdataFromLocalStorage());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: checkNotNUllItem(widget.cardData.assignedto) && widget.cardData.assignedto.isNotEmpty
          ? widget.cardData.assignedto
              .sublist(
                0,
                widget.cardData.assignedto.length < 2
                    ? 1
                    : widget.cardData.assignedto.length < 3
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
                              assigned.isNotEmpty
                                  ? getNamesMatchWithid(user.userid).image.isEmpty
                                      ? noImg
                                      : getNamesMatchWithid(user.userid).image
                                  : noImg,
                              scale: 1,
                            ),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.circular(40),
                        ),
                  child: index > 1
                      ? Center(
                          child: CustomText(
                            title: '+${widget.cardData.assignedto.length - 2}',
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
