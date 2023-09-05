import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:random_string/random_string.dart';
import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/firebase/detailsModels/todo_details.dart';

import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart' as cards;
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';

Future<String> submitTodoAndCardDetails(state) async {
  final randomId = randomNumeric(5);
  var res = "pending";
  //  leadcategory example =  rent ,buy
  //   propertycategory example = residental ,commerical,
  final todotype = getDataById(state, 1);
  final todoTitle = getDataById(state, 2);
  final todoDescription = getDataById(state, 3);
  final dueDate = getDataById(state, 4);
  final cards.CardDetails cardDetail = getDataById(state, 6);
  final User assignto = getDataById(state, 12);
  Box box = Hive.box("users");
  final currentUser = box.get(AppConst.getAccessToken());
  final cards.CardDetails card = cards.CardDetails(
    workitemId: "TD$randomId",
    status: "New",
    brokerid: currentUser["brokerId"],
    cardType: todotype,
    duedate: dueDate,
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
    assignedto: [
      cards.Assignedto(
        firstname: assignto.userfirstname,
        lastname: assignto.userlastname,
        assignedby: currentUser["userfirstname"],
        image: assignto.image,
        userid: assignto.userId,
      )
    ],
    createdby:
        cards.Createdby(userfirstname: currentUser["userfirstname"], userid: currentUser["userId"], userlastname: currentUser["userlastname"], userimage: currentUser["image"]),
    createdate: Timestamp.now(),
  );
  final TodoDetails todo = TodoDetails(
    todoId: "TD$randomId",
    todoType: todotype,
    brokerId: currentUser["brokerId"],
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
    assignedto: [
      Assignedto(
        firstname: assignto.userfirstname,
        lastname: assignto.userlastname,
        assignedby: currentUser["userfirstname"],
        image: assignto.image,
        userid: assignto.userId,
      ),
    ],
    createdBy: AppConst.getAccessToken(),
    attachments: [],
    createDate: Timestamp.now(),
    linkedWorkItem: [
      LinkedWorkItem(workItemId: cardDetail.workitemId, workItemTitle: cardDetail.cardTitle, workItemDescription: cardDetail.cardDescription, workItemType: cardDetail.cardType)
    ],
    todoStatus: "New",
  );

  await cards.CardDetails.addCardDetails(card).then((value) => {res = "success"});
  await TodoDetails.addTodoDetails(todo).then((value) => {res == "success"});
  return res;
}
