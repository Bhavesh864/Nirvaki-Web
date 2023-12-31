import 'package:flutter/material.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/Customs/snackbar.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/firebase/detailsModels/inventory_details.dart' as inventory;
import 'package:yes_broker/constants/firebase/detailsModels/lead_details.dart' as lead;
import 'package:yes_broker/constants/firebase/detailsModels/todo_details.dart' as todo;
import 'package:yes_broker/constants/firebase/send_notification.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/widgets/questionaries/assign_user.dart';
import '../app_constant.dart';
import '../firebase/Methods/add_activity.dart';
import '../firebase/userModel/user_info.dart';

List<User>? user;
void submitAssignUser(String id, BuildContext context, List<User> users, User currentuserdata) async {
  if (users.isNotEmpty) {
    final List<Assignedto> assigncard = users.map((user) {
      return Assignedto(
        firstname: user.userfirstname,
        lastname: user.userlastname,
        assignedby: AppConst.getAccessToken(),
        image: user.image,
        userid: user.userId,
      );
    }).toList();

    if (id.contains(ItemCategory.isTodo)) {
      final List<todo.Assignedto> assign = users.map((user) {
        return todo.Assignedto(
          firstname: user.userfirstname,
          lastname: user.userlastname,
          assignedby: AppConst.getAccessToken(),
          image: user.image,
          userid: user.userId,
        );
      }).toList();
      todo.TodoDetails.updateAssignUser(itemid: id, assignedtoList: assign);
    }
    if (id.contains(ItemCategory.isInventory)) {
      final List<inventory.Assignedto> assign = users.map((user) {
        return inventory.Assignedto(
          firstname: user.userfirstname,
          lastname: user.userlastname,
          assignedby: AppConst.getAccessToken(),
          image: user.image,
          userid: user.userId,
        );
      }).toList();
      inventory.InventoryDetails.updateAssignUser(itemid: id, assignedtoList: assign);
    }

    if (id.contains(ItemCategory.isLead)) {
      final List<lead.Assignedto> assign = users.map((user) {
        return lead.Assignedto(
          firstname: user.userfirstname,
          lastname: user.userlastname,
          assignedby: AppConst.getAccessToken(),
          image: user.image,
          userid: user.userId,
        );
      }).toList();
      lead.LeadDetails.updateAssignUser(itemid: id, assignedtoList: assign);
    }
    CardDetails.updateAssignUser(itemid: id, assignedtoList: assigncard);
    final typeofWorkitem = calculateTypeOfWorkitem(id);
    final userNames = user?.map((user) => "${user.userfirstname} ${user.userlastname}").join(", ");
    if (userNames!.isNotEmpty) {
      submitActivity(itemid: id, activitytitle: "$typeofWorkitem assigned to $userNames", user: currentuserdata);
    }
    for (var user in users) {
      notifyToUser(
          assignedto: user.userId,
          title: "Assign new $id",
          content: "$id $typeofWorkitem assigned to ${user.userfirstname} ${user.userlastname}",
          assigntofield: true,
          itemid: id,
          currentuserdata: currentuserdata);
    }
  } else {
    customSnackBar(context: context, text: "Please select user");
  }
}

void deleteassignUser(userid, String id) {
  if (id.contains(ItemCategory.isTodo)) {
    todo.TodoDetails.deleteTodoAssignUser(itemId: id, userid: userid);
  } else if (id.contains(ItemCategory.isInventory)) {
    inventory.InventoryDetails.deleteInventoryAssignUser(itemId: id, userid: userid);
  } else if (id.contains(ItemCategory.isLead)) {
    lead.LeadDetails.deleteInventoryAssignUser(itemId: id, userid: userid);
  }
  CardDetails.deleteCardAssignUser(itemId: id, userid: userid);
}

void assginUserToTodo(BuildContext context, Function assign, List<dynamic> assignto, String id, Function popBottomSheet, User currentuserdata) {
  showDialog(
    context: context,
    builder: (context) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Dialog(
          insetPadding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                // height: 200,
                constraints: const BoxConstraints(maxHeight: 400, minHeight: 200),
                width: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AssignUser(
                        status: true,
                        addUser: (user) {
                          assign(user);
                          FocusScope.of(context).unfocus();
                        },
                        assignedUserIds: assignto.map((item) => item.userid).toList(),
                      ),
                      const SizedBox(height: 35),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: () {
                            submitAssignUser(id, context, user!, currentuserdata);
                            // assigned.addAll(user!);
                            if (user!.isNotEmpty) {
                              Navigator.of(context).pop();
                              if (Responsive.isMobile(context)) {
                                popBottomSheet();
                              }
                              user = [];
                            }
                          },
                          child: const Text("Add"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

String calculateTypeOfWorkitem(String id) {
  if (id.contains(ItemCategory.isInventory)) {
    return "Inventory";
  } else if (id.contains(ItemCategory.isLead)) {
    return "Lead";
  } else {
    return "Todo";
  }
}
