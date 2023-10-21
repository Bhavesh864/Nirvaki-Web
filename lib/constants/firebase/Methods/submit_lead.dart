import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:random_string/random_string.dart';

import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/firebase/detailsModels/lead_details.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart' as cards;
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/riverpodstate/user_data.dart';

import '../../functions/convertStringTorange/convert_range_string.dart';
import '../send_notification.dart';

Future<String> submitLeadAndCardDetails(state, bool isEdit, WidgetRef ref) async {
  final randomId = randomNumeric(5);
  final User? currentUserdata = ref.read(userDataProvider);
  var res = "pending";
  //  leadcategory example =  rent ,buy
  //   propertycategory example = residental ,commerical,
  final propertyCategory = getDataById(state, 1);
  final leadCategory = getDataById(state, 2);
  // final leadType = getDataById(state, 3);
  final leadSource = getDataById(state, 4);
  final firstName = getDataById(state, 5);
  final lastName = getDataById(state, 6);
  final mobileNo = getDataById(state, 7);
  final whatsAppNo = getDataById(state, 8);
  final email = getDataById(state, 9);
  final companyNamecustomer = getDataById(state, 10);
  final propertyKind = getDataById(state, 11);
  final villaType = getDataById(state, 12);
  final transactionType = getDataById(state, 13);
  final bedrooms = getDataById(state, 14);
  final additionalRoom = getDataById(state, 15);
  final bathrooms = getDataById(state, 16);
  final balconies = getDataById(state, 17);
  final boundaryWall = getDataById(state, 18);
  final openSides = getDataById(state, 19);
  final possession = getDataById(state, 20);
  final amenities = getDataById(state, 21);
  final coveredparking = getDataById(state, 22);
  final areaUnit = getDataById(state, 23);
  final superArea = getDataById(state, 24);
  // final carpetArea = getDataById(state, 25);
  // final propertyState = getDataById(state, 26);
  // final propertyCity = getDataById(state, 27);
  // final addressLine1 = getDataById(state, 28);
  // final addressLine2 = getDataById(state, 29);
  final floorNumber = getDataById(state, 30);
  final latlng = getDataById(state, 31);
  final budgetPrice = getDataById(state, 32);
  final preferredpropertyfacing = getDataById(state, 34);
  final comments = getDataById(state, 35);
  final List<User> assignto = getDataById(state, 36);
  // final locality = getDataById(state, 54);
  final furnishedStatus = getDataById(state, 55);
  final listofLocality = getDataById(state, 56);

  // commerical
  final availability = getDataById(state, 37);
  final commericialtype = getDataById(state, 38);
  final typeofoffice = getDataById(state, 39);
  final typeofretail = getDataById(state, 40);
  final typeofhospitality = getDataById(state, 41);
  final typeofhealthcare = getDataById(state, 42);
  final approvedbeds = getDataById(state, 43);
  final typeofschool = getDataById(state, 44);
  final hospitalrooms = getDataById(state, 45);
  final widthofRoad = getDataById(state, 46);
  final widthofRoadft = getDataById(state, 47);
  final attachments = getDataById(state, 100);
  final existingLeadId = getDataById(state, 101);
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
      workitemId: isEdit ? existingLeadId : "LD$randomId",
      status: "New",
      cardCategory: leadCategory,
      linkedItemType: "LD",
      brokerid: currentUserdata?.brokerId,
      cardType: "LD",
      cardTitle: "$propertyCategory $propertyKind",
      cardDescription: "Want to $leadCategory her $bedrooms BHK for ${formatValue(budgetPrice?.start)}-${formatValue(budgetPrice?.end)} rupees",
      customerinfo: cards.Customerinfo(email: email, firstname: firstName, lastname: lastName, mobile: mobileNo, title: companyNamecustomer, whatsapp: whatsAppNo ?? mobileNo),
      cardStatus: "New",
      assignedto: assignedToList,
      createdby: cards.Createdby(
          userfirstname: currentUserdata?.userfirstname, userid: currentUserdata?.userId, userlastname: currentUserdata?.userlastname, userimage: currentUserdata?.image),
      createdate: Timestamp.now(),
      managerid: currentUserdata?.managerid,
      propertyarearange: cards.Propertyarearange(arearangestart: "${formatValueforOnlyNumbers(superArea.start)}-${formatValueforOnlyNumbers(superArea.end)}", unit: areaUnit),
      roomconfig: cards.Roomconfig(bedroom: bedrooms, additionalroom: additionalRoom),
      propertypricerange: cards.Propertypricerange(arearangestart: "${formatValue(budgetPrice.start)}-${formatValue(budgetPrice.end)}"));
  final List<Assignedto> assignedListInLead = assignto.map((user) {
    return Assignedto(
      firstname: user.userfirstname,
      lastname: user.userlastname,
      assignedby: AppConst.getAccessToken(),
      image: user.image,
      userid: user.userId,
    );
  }).toList();
  bool isResidential = propertyCategory == "Residential";
  var title = isResidential ? "" : commericialtype;
  final LeadDetails lead = LeadDetails(
      leadTitle: "$propertyCategory $title $propertyKind",
      leadDescription: "lead",
      leadId: isEdit ? existingLeadId : "LD$randomId",
      leadStatus: "New",
      typeofoffice: typeofoffice,
      approvedbeds: approvedbeds,
      typeofhospitality: typeofhospitality,
      hospitalrooms: hospitalrooms,
      propertykind: propertyKind,
      managerid: currentUserdata?.managerid,
      commericialtype: commericialtype,
      availability: availability,
      typeofretail: typeofretail,
      typeofhealthcare: typeofhealthcare,
      preferredroadwidth: widthofRoad,
      propertylocation: latlng,
      preferredroadwidthAreaUnit: widthofRoadft,
      villatype: villaType,
      preferredlocation: latlng,
      typeofschool: typeofschool,
      transactiontype: transactionType,
      attachments: attachments ?? [],
      brokerid: currentUserdata?.brokerId,
      leadcategory: leadCategory,
      propertycategory: propertyCategory,
      leadType: leadSource == "Broker" ? "Broker" : leadSource,
      preferredpropertyfacing: preferredpropertyfacing,
      leadsource: leadSource,
      possessiondate: possession,
      plotdetails: Plotdetails(boundarywall: boundaryWall, opensides: openSides),
      amenities: amenities ?? [],
      propertyarea: Propertyarea(unit: areaUnit),
      preferredlocality: Preferredlocality(listofLocality: listofLocality, prefferedfloornumber: floorNumber),
      propertyarearange: Propertyarearange(unit: areaUnit, arearangestart: formatValueforOnlyNumbers(superArea.start), arearangeend: formatValueforOnlyNumbers(superArea.end)),
      propertypricerange: Propertypricerange(arearangestart: formatValue(budgetPrice.start), arearangeend: formatValue(budgetPrice.end)),
      reservedparking: Reservedparking(covered: coveredparking),
      customerinfo: Customerinfo(email: email, firstname: firstName, lastname: lastName, companyname: companyNamecustomer, mobile: mobileNo, whatsapp: whatsAppNo ?? mobileNo),
      roomconfig: Roomconfig(bedroom: bedrooms, additionalroom: additionalRoom ?? [], balconies: balconies, bathroom: bathrooms),
      comments: comments,
      furnishedStatus: furnishedStatus,
      updatedby: AppConst.getAccessToken(),
      createdate: Timestamp.now(),
      assignedto: assignedListInLead,
      createdby: Createdby(
          userfirstname: currentUserdata?.userfirstname, userid: currentUserdata?.userId, userlastname: currentUserdata?.userlastname, userimage: currentUserdata?.image));

  isEdit
      ? await cards.CardDetails.updateCardDetails(id: existingLeadId, cardDetails: card).then((value) => {res = "success"})
      : await cards.CardDetails.addCardDetails(card).then((value) => {res = "success"});

  isEdit
      ? await LeadDetails.updateLeadDetails(id: existingLeadId, leadDetails: lead).then((value) => {res = "success"})
      : await LeadDetails.addLeadDetails(lead).then((value) => {res = "success"});
  for (var user in assignedListInLead) {
    if (!isEdit) {
      notifyToUser(
          assignedto: user.userid,
          title: "Assign new LD$randomId",
          content: "LD$randomId New Lead assigned to ${user.firstname} ${user.lastname}",
          assigntofield: true,
          itemid: "LD$randomId",
          currentuserdata: currentUserdata!);
    } else {
      notifyToUser(
          assignedto: user.userid,
          title: "Lead detail Updated",
          content: "$existingLeadId Lead detail Updated",
          assigntofield: true,
          itemid: existingLeadId,
          currentuserdata: currentUserdata!);
    }
  }
  return res;
}
