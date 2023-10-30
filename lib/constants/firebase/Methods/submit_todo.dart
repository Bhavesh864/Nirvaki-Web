import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_string/random_string.dart';
import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/firebase/detailsModels/todo_details.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart' as cards;
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/riverpodstate/user_data.dart';

import '../send_notification.dart';
import 'add_activity.dart';

Future<String> submitTodoAndCardDetails(state, WidgetRef ref) async {
  final User? currentUserdata = ref.read(userDataProvider);
  final randomId = randomNumeric(5);
  final idForNewTodo = "TD$randomId";
  var res = "pending";
  final todotype = getDataById(state, 1);
  final todoTitle = getDataById(state, 2);
  final todoDescription = getDataById(state, 3);
  final dueDate = getDataById(state, 4);
  final cardDetail = getDataById(state, 6);
  final List<User> assignto = getDataById(state, 12);
  final dueDataTime = getDataById(state, 13);

  final List<cards.Assignedto> assignedToList = assignto.map((user) {
    return cards.Assignedto(
      firstname: user.userfirstname,
      lastname: user.userlastname,
      assignedby: AppConst.getAccessToken(),
      image: user.image,
      userid: user.userId,
    );
  }).toList();

  final cards.CardDetails card = cards.CardDetails(
    workitemId: idForNewTodo,
    status: "New",
    brokerid: currentUserdata?.brokerId,
    cardType: todotype,
    duedate: dueDate,
    managerid: currentUserdata?.managerid,
    cardTitle: todoTitle,
    cardDescription: todoDescription,
    linkedItemType: checkNotNUllItem(cardDetail) ? cardDetail.cardType : "",
    customerinfo: cardDetail != null
        ? cards.Customerinfo(
            email: cardDetail.customerinfo?.email,
            firstname: cardDetail.customerinfo?.firstname,
            lastname: cardDetail.customerinfo?.lastname,
            mobile: cardDetail.customerinfo?.mobile,
            title: cardDetail.customerinfo?.title,
            whatsapp: cardDetail.customerinfo?.whatsapp)
        : cards.Customerinfo(),
    cardStatus: "New",
    linkedItemId: checkNotNUllItem(cardDetail) ? cardDetail.workitemId : "",
    assignedto: assignedToList,
    dueTime: dueDataTime,
    createdby: cards.Createdby(
        userfirstname: currentUserdata?.userfirstname, userid: currentUserdata?.userId, userlastname: currentUserdata?.userlastname, userimage: currentUserdata?.image),
    createdate: Timestamp.now(),
  );
  final List<Assignedto> assignedListTodo = assignto.map((user) {
    return Assignedto(
      firstname: user.userfirstname,
      lastname: user.userlastname,
      assignedby: AppConst.getAccessToken(),
      image: user.image,
      userid: user.userId,
    );
  }).toList();

  final TodoDetails todo = TodoDetails(
    todoId: idForNewTodo,
    managerId: currentUserdata?.managerid,
    todoType: todotype,
    brokerId: currentUserdata?.brokerId,
    dueDate: dueDate,
    todoName: todoTitle,
    todoDescription: todoDescription,
    dueTime: dueDataTime,
    customerinfo: checkNotNUllItem(cardDetail)
        ? Customerinfo(
            email: cardDetail.customerinfo?.email,
            firstname: cardDetail.customerinfo?.firstname,
            lastname: cardDetail.customerinfo?.lastname,
            mobile: cardDetail.customerinfo?.mobile,
            title: cardDetail.customerinfo?.title,
            whatsapp: cardDetail.customerinfo?.whatsapp)
        : Customerinfo(),
    assignedto: assignedListTodo,
    createdby: Createdby(
      userfirstname: currentUserdata?.userfirstname,
      userid: currentUserdata?.userId,
      userlastname: currentUserdata?.userlastname,
      userimage: currentUserdata?.image,
    ),
    attachments: [],
    createdate: Timestamp.now(),
    linkedWorkItem: [
      checkNotNUllItem(cardDetail)
          ? LinkedWorkItem(
              workItemId: cardDetail.workitemId, workItemTitle: cardDetail.cardTitle, workItemDescription: cardDetail.cardDescription, workItemType: cardDetail.cardType)
          : LinkedWorkItem()
    ],
    todoStatus: "New",
  );
  await cards.CardDetails.addCardDetails(card).then((value) => {res = "success"});
  await TodoDetails.addTodoDetails(todo).then((value) => {res == "success"});
  final userNames = assignedListTodo.map((user) => "${user.firstname} ${user.lastname}").join(", ");
  submitActivity(itemid: idForNewTodo, activitytitle: "New $todotype assigned to $userNames", user: currentUserdata!);
  for (var user in assignedListTodo) {
    notifyToUser(
        assignedto: user.userid,
        title: "New Todo Created",
        content: "$idForNewTodo New $todotype assigned to ${user.firstname} ${user.lastname}",
        assigntofield: true,
        itemid: idForNewTodo,
        currentuserdata: currentUserdata);
    if (cardDetail != null) {
      notifyToUser(
          assignedto: user.userid,
          title: "New Todo created for ${cardDetail.workitemId}",
          content: "$idForNewTodo New $todotype created for ${cardDetail.workitemId}",
          assigntofield: true,
          itemid: idForNewTodo,
          currentuserdata: currentUserdata);
    }
  }
  return res;
}
