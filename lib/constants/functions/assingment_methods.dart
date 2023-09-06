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

void submitAssignUser(String id, BuildContext context, dynamic assignto) async {
  if (user != null) {
    for (var i = 0; i < user!.length; i++) {
      if (id.contains(ItemCategory.isTodo)) {
        todo.Assignedto assign = todo.Assignedto(
          firstname: user![i].userfirstname,
          lastname: user![i].userlastname,
          assignedby: AppConst.getAccessToken(),
          userid: user![i].userId,
          image: user![i].image,
        );
        todo.TodoDetails.updateAssignUser(itemid: id, assignedto: assign);
      } else if (id.contains(ItemCategory.isInventory)) {
        inventory.Assignedto assign = inventory.Assignedto(
          firstname: user![i].userfirstname,
          lastname: user![i].userlastname,
          assignedby: AppConst.getAccessToken(),
          userid: user![i].userId,
          image: user![i].image,
        );
        inventory.InventoryDetails.updateAssignUser(itemid: id, assignedto: assign);
      } else if (id.contains(ItemCategory.isLead)) {
        lead.Assignedto assign = lead.Assignedto(
          firstname: user![i].userfirstname,
          lastname: user![i].userlastname,
          assignedby: AppConst.getAccessToken(),
          userid: user![i].userId,
          image: user![i].image,
        );
        lead.LeadDetails.updateAssignUser(itemid: id, assignedto: assign);
      }
      Assignedto assigncard = Assignedto(
        firstname: user![i].userfirstname,
        lastname: user![i].userlastname,
        assignedby: AppConst.getAccessToken(),
        userid: user![i].userId,
        image: user![i].image,
      );
      CardDetails.updateAssignUser(itemid: id, assignedto: assigncard);
      notifyToUser(assignedto: user?[i].userId, title: "Assign new $id", content: "New $id Assign To You", assigntofield: true, itemid: id);
      user = null;
    }
  } else {
    customSnackBar(context: context, text: "please select user");
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

void assginUserToTodo(BuildContext context, Function assign, List<dynamic> assignto, String id, Function popBottomSheet) {
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
                    assign(user);
                    FocusScope.of(context).unfocus();
                  },
                  assignedUserIds: assignto.map((item) => item.userid).toList(),
                ),
                const SizedBox(height: 50),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      submitAssignUser(id, context, assignto);
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
