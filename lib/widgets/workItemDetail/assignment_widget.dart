import 'package:flutter/material.dart';
import 'package:yes_broker/Customs/small_custom_profile_image.dart';
import 'package:yes_broker/widgets/questionaries/assign_user.dart';

import '../../constants/app_constant.dart';
import '../../constants/firebase/userModel/user_info.dart';
import '../../constants/utils/colors.dart';

class AssignmentWidget extends StatefulWidget {
  final String createdBy;
  final String assignTo;
  final String imageUrlAssignTo;
  final String imageUrlCreatedBy;

  const AssignmentWidget({
    super.key,
    required this.createdBy,
    required this.assignTo,
    required this.imageUrlAssignTo,
    required this.imageUrlCreatedBy,
  });

  @override
  State<AssignmentWidget> createState() => _AssignmentWidgetState();
}

class _AssignmentWidgetState extends State<AssignmentWidget> {
  User? user;

  void assginUserToTodo() {
    showDialog(
      context: context,
      builder: (context) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Container(
                padding: const EdgeInsets.all(15),
                height: 200,
                width: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AssignUser(
                      addUser: (user) {
                        user = user;
                      },
                    ),
                    const SizedBox(height: 50),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                            onPressed: () {
                              print(user);
                            },
                            child: const Text("Add")))
                  ],
                ),
              )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.only(left: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SmallCustomCircularImage(imageUrl: widget.imageUrlAssignTo),
                        Padding(
                          padding: const EdgeInsets.only(left: 4, top: 4),
                          child: Text(
                            widget.assignTo,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: AppColor.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => assginUserToTodo(),
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
                    ),
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
