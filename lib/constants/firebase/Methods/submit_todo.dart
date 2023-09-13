import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_string/random_string.dart';
import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/firebase/detailsModels/todo_details.dart';

import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart' as cards;
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/riverpodstate/user_data.dart';

Future<String> submitTodoAndCardDetails(state, WidgetRef ref) async {
  final User currentUserdata = ref.read(userDataProvider);
  final randomId = randomNumeric(5);
  var res = "pending";
  final todotype = getDataById(state, 1);
  final todoTitle = getDataById(state, 2);
  final todoDescription = getDataById(state, 3);
  final dueDate = getDataById(state, 4);
  final cards.CardDetails cardDetail = getDataById(state, 6);
  final List<User> assignto = getDataById(state, 12);

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
    workitemId: "TD$randomId",
    status: "New",
    brokerid: currentUserdata.brokerId,
    cardType: todotype,
    duedate: dueDate,
    managerid: currentUserdata.managerid,
    cardTitle: todoTitle,
    cardDescription: todoDescription,
    linkedItemType: cardDetail.cardType,
    customerinfo: cards.Customerinfo(
        email: cardDetail.customerinfo?.email,
        firstname: cardDetail.customerinfo?.firstname,
        lastname: cardDetail.customerinfo?.lastname,
        mobile: cardDetail.customerinfo?.mobile,
        title: cardDetail.customerinfo?.title,
        whatsapp: cardDetail.customerinfo?.whatsapp),
    cardStatus: "New",
    linkedItemId: cardDetail.workitemId,
    assignedto: assignedToList,
    createdby: cards.Createdby(
        userfirstname: currentUserdata.userfirstname, userid: currentUserdata.userId, userlastname: currentUserdata.userlastname, userimage: currentUserdata.image),
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
    todoId: "TD$randomId",
    managerId: currentUserdata.managerid,
    todoType: todotype,
    brokerId: currentUserdata.brokerId,
    dueDate: dueDate,
    todoName: todoTitle,
    todoDescription: todoDescription,
    customerinfo: Customerinfo(
        email: cardDetail.customerinfo?.email,
        firstname: cardDetail.customerinfo?.firstname,
        lastname: cardDetail.customerinfo?.lastname,
        mobile: cardDetail.customerinfo?.mobile,
        title: cardDetail.customerinfo?.title,
        whatsapp: cardDetail.customerinfo?.whatsapp),
    assignedto: assignedListTodo,
    createdBy: AppConst.getAccessToken(),
    attachments: [],
    createDate: Timestamp.now(),
    linkedWorkItem: [
      LinkedWorkItem(
          workItemId: cardDetail.workitemId, workItemTitle: cardDetail.cardTitle, workItemDescription: cardDetail.cardDescription, workItemType: cardDetail.cardType)
    ],
    todoStatus: "New",
  );
  await cards.CardDetails.addCardDetails(card).then((value) => {res = "success"});
  await TodoDetails.addTodoDetails(todo).then((value) => {res == "success"});

  return res;
}
