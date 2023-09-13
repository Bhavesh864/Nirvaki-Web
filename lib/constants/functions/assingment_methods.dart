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
    for (var user in users) {
      notifyToUser(assignedto: user.userId, title: "Assign new $id", content: "New $id Assign To You", assigntofield: true, itemid: id, currentuserdata: currentuserdata);
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(15),
            height: 250,
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
                    assign();
                    FocusScope.of(context).unfocus();
                  },
                  assignedUserIds: assignto.map((item) => item.userid).toList(),
                ),
                const SizedBox(height: 50),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      submitAssignUser(id, context, user!, currentuserdata);
                      Navigator.of(context).pop();
                      if (Responsive.isMobile(context)) {
                        popBottomSheet();
                      }
                    },
                    child: const Text("Add"),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}
