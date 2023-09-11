import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/Customs/small_custom_profile_image.dart';
import 'package:yes_broker/constants/utils/constants.dart';

import '../../constants/app_constant.dart';
import '../../constants/firebase/userModel/user_info.dart';
import '../../constants/functions/assingment_methods.dart';
import '../../constants/utils/colors.dart';
import '../../riverpodstate/user_data.dart';

class AssignmentWidget extends ConsumerStatefulWidget {
  final List<dynamic> assignto;
  final String createdBy;
  final String imageUrlCreatedBy;
  final String id;

  const AssignmentWidget({
    super.key,
    required this.createdBy,
    required this.imageUrlCreatedBy,
    required this.id,
    required this.assignto,
  });

  @override
  AssignmentWidgetState createState() => AssignmentWidgetState();
}

class AssignmentWidgetState extends ConsumerState<AssignmentWidget> {
  void assign(List<User> assignedUser) {
    setState(() {
      user = assignedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = ref.read(userDataProvider);
    return Column(
      children: [
        if (!AppConst.getPublicView())
          Padding(
            padding: const EdgeInsets.only(top: 17),
            child: Row(
              children: [
                const Icon(Icons.add),
                const Padding(
                    padding: EdgeInsets.only(left: 4, top: 1, bottom: 1),
                    child: Text("Added by ",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ))),
                Padding(
                  padding: const EdgeInsets.only(left: 6, top: 2),
                  child: Row(
                    children: [
                      SmallCustomCircularImage(imageUrl: widget.imageUrlCreatedBy),
                      Text(
                        widget.createdBy,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: AppColor.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 18, bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.person_add_alt_outlined),
              const Padding(
                padding: EdgeInsets.only(left: 6),
                child: Text(
                  "Assigned to",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: widget.assignto.map((item) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 7),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(color: AppColor.secondary, borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SmallCustomCircularImage(imageUrl: item.image!.isNotEmpty ? item.image! : noImg),
                              Text(
                                "${item.firstname!} ${item.lastname}",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  color: AppColor.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(width: 3),
                              if (widget.assignto.length > 1)
                                user.role != "Employee"
                                    ? GestureDetector(
                                        onTap: () {
                                          deleteassignUser(item.userid, widget.id);
                                          if (Responsive.isMobile(context)) {
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        child: const Icon(Icons.close),
                                      )
                                    : const SizedBox.shrink(),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    user.role != "Employee"
                        ? GestureDetector(
                            onTap: () {
                              assginUserToTodo(context, assign, widget.assignto, widget.id, () {
                                Navigator.of(context).pop();
                              }, user);
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(top: 14),
                              child: Row(
                                children: [
                                  Icon(Icons.add),
                                  Padding(
                                    padding: EdgeInsets.only(left: 6),
                                    child: Text("Add More",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: AppColor.primary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
