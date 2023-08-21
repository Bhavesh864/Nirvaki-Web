import 'package:flutter/material.dart';
import 'package:yes_broker/Customs/small_custom_profile_image.dart';
import 'package:yes_broker/Customs/snackbar.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/firebase/detailsModels/inventory_details.dart' as inventory;
import 'package:yes_broker/constants/firebase/detailsModels/lead_details.dart' as lead;
import 'package:yes_broker/constants/firebase/detailsModels/todo_details.dart' as todo;
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/widgets/questionaries/assign_user.dart';

import '../../constants/app_constant.dart';
import '../../constants/firebase/userModel/user_info.dart';
import '../../constants/utils/colors.dart';

class AssignmentWidget extends StatefulWidget {
  final List<dynamic> assignto;
  final String createdBy;
  final String imageUrlCreatedBy;
  final String id;

  const AssignmentWidget({super.key, required this.createdBy, required this.imageUrlCreatedBy, required this.id, required this.assignto});

  @override
  State<AssignmentWidget> createState() => _AssignmentWidgetState();
}

class _AssignmentWidgetState extends State<AssignmentWidget> {
  User? user;

  void assign(User assignedUser) {
    setState(() {
      user = assignedUser;
    });
  }

  void submitAssignUser() {
    print(widget.id);
    if (user != null) {
      if (widget.id!.contains("TD")) {
        todo.Assignedto assign = todo.Assignedto(
          firstname: user?.userfirstname,
          lastname: user?.userlastname,
          assignedby: AppConst.getAccessToken(),
          userid: user?.userId,
          image: user?.image,
        );
        todo.TodoDetails.updateAssignUser(itemid: widget.id!, assignedto: assign);
      } else if (widget.id!.contains("IN")) {
        print("object");
        inventory.Assignedto assign = inventory.Assignedto(
          firstname: user?.userfirstname,
          lastname: user?.userlastname,
          assignedby: AppConst.getAccessToken(),
          userid: user?.userId,
          image: user?.image,
        );
        inventory.InventoryDetails.updateAssignUser(itemid: widget.id!, assignedto: assign);
      } else if (widget.id!.contains("LD")) {
        lead.Assignedto assign = lead.Assignedto(
          firstname: user?.userfirstname,
          lastname: user?.userlastname,
          assignedby: AppConst.getAccessToken(),
          userid: user?.userId,
          image: user?.image,
        );
        lead.LeadDetails.updateAssignUser(itemid: widget.id!, assignedto: assign);
      }
      Assignedto assigncard = Assignedto(
        firstname: user?.userfirstname,
        lastname: user?.userlastname,
        assignedby: AppConst.getAccessToken(),
        userid: user?.userId,
        image: user?.image,
      );
      CardDetails.updateAssignUser(itemid: widget.id!, assignedto: assigncard);
      user = null;
    } else {
      customSnackBar(context: context, text: "please select user");
    }
  }

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
                        status: true,
                        addUser: (user) {
                          assign(user);
                        },
                        assignedUserIds: widget.assignto.map((item) => item.userid).toList(),
                      ),
                      const SizedBox(height: 50),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: submitAssignUser,
                          child: const Text("Add"),
                        ),
                      )
                    ],
                  ),
                )));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // print('user ------ $user');
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
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: widget.assignto.map((item) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SmallCustomCircularImage(imageUrl: item.image!.isNotEmpty ? item.image! : noImg),
                            Padding(
                              padding: const EdgeInsets.only(left: 4, top: 4),
                              child: Text(
                                "${item.firstname!} ${item.lastname}",
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
                        );
                      }).toList(),
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
