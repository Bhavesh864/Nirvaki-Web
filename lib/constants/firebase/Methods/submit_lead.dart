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
import 'add_activity.dart';

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
  var villaType = getDataById(state, 12);
  var transactionType = getDataById(state, 13);
  var bedrooms = getDataById(state, 14);
  var additionalRoom = getDataById(state, 15);
  var bathrooms = getDataById(state, 16);
  var balconies = getDataById(state, 17);
  var boundaryWall = getDataById(state, 18);
  var openSides = getDataById(state, 19);
  var possession = getDataById(state, 20);
  final amenities = getDataById(state, 21);
  var coveredparking = getDataById(state, 22);
  final areaUnit = getDataById(state, 23);
  final superArea = getDataById(state, 24);
  // final carpetArea = getDataById(state, 25);
  // final propertyState = getDataById(state, 26);
  // final propertyCity = getDataById(state, 27);
  // final addressLine1 = getDataById(state, 28);
  // final addressLine2 = getDataById(state, 29);
  final floorNumber = getDataById(state, 30);
  // final latlng = getDataById(state, 31);
  final budgetPrice = getDataById(state, 32);
  final preferredpropertyfacing = getDataById(state, 34);
  final comments = getDataById(state, 35);
  final List<User> assignto = getDataById(state, 36);
  // final locality = getDataById(state, 54);
  var furnishedStatus = getDataById(state, 55);
  final listofLocality = getDataById(state, 56);

  // commerical
  var availability = getDataById(state, 37);
  final commericialtype = getDataById(state, 38);
  var typeofoffice = getDataById(state, 39);
  var typeofretail = getDataById(state, 40);
  var typeofhospitality = getDataById(state, 41);
  var typeofhealthcare = getDataById(state, 42);
  var approvedbeds = getDataById(state, 43);
  var typeofschool = getDataById(state, 44);
  var hospitalityrooms = getDataById(state, 45);
  final widthofRoad = getDataById(state, 46);
  final widthofRoadft = getDataById(state, 47);
  final attachments = getDataById(state, 100);
  final existingLeadId = getDataById(state, 101);
  final existingCardStatus = getDataById(state, 102);
  if (propertyCategory == "Residential") {
    if (leadCategory == "Rent") {
      availability = boundaryWall = openSides = transactionType = null;
    } else if (leadCategory == "Buy") {}
    switch (propertyKind) {
      case "Apartment":
      case "Builder Floor":
      case "Independent House/Villa":
        boundaryWall = openSides = null;
        if (propertyKind != "Independent House/Villa") {
          villaType = null;
        }
        break;
      case "Farm House":
        villaType = coveredparking = boundaryWall = openSides = null;
        break;
      case "Plot":
        bedrooms = bathrooms = balconies = additionalRoom = villaType = coveredparking = furnishedStatus = null;
        break;
    }
  }

  void resetAllFields() {
    typeofoffice = typeofschool = typeofretail = typeofhospitality = typeofhealthcare = approvedbeds = hospitalityrooms = null;
  }

  void resetAllFieldsForOffice() {
    typeofschool = typeofretail = typeofhospitality = typeofhealthcare = approvedbeds = hospitalityrooms = null;
  }

  void resetAllFieldsForSchool() {
    typeofoffice = typeofretail = typeofhospitality = typeofhealthcare = approvedbeds = hospitalityrooms = null;
  }

  if (propertyCategory == "Commercial") {
    if (leadCategory == "Rent") {
      transactionType = null;
    } else if (leadCategory == "Buy") {}
    switch (propertyKind) {
      case "Land":
        if (commericialtype == "Shop Cum Office" || commericialtype == "Mall" || commericialtype == "Shopping Complex" || commericialtype == "Warehouse") {
          resetAllFields();
          possession = null;
        }
        if (commericialtype == "Office") {
          resetAllFieldsForOffice();
        }
        if (commericialtype == "School") {
          resetAllFieldsForSchool();
        }
        break;
      case "Constructed Property":
      case "Under Construction":
        if (propertyKind == "Constructed Property") {
          possession = null;
        }
        if (commericialtype == "Office") {
          resetAllFieldsForOffice();
        }
        if (commericialtype == "School") {
          resetAllFieldsForSchool();
        }
        if (commericialtype == "Retail") {
          typeofoffice = typeofschool = typeofhospitality = typeofhealthcare = approvedbeds = hospitalityrooms = null;
        }
        if (commericialtype == "Industrial") {
          resetAllFields();
        }
        if (commericialtype == "Hospitality") {
          typeofoffice = typeofschool = typeofretail = typeofhealthcare = approvedbeds = null;
        }
        if (commericialtype == "Healthcare") {
          if (typeofhealthcare == "Clinic") {
            approvedbeds = null;
          }
          typeofoffice = typeofschool = typeofretail = typeofhospitality = hospitalityrooms = null;
        }
        if (commericialtype == "Institutional" || commericialtype == "Warehouse") {
          resetAllFields();
        }
        break;
    }
  }
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
      status: isEdit ? existingCardStatus : "New",
      cardCategory: leadCategory,
      linkedItemType: "LD",
      cardStatus: isEdit ? existingCardStatus : "New",
      brokerid: currentUserdata?.brokerId,
      cardType: "LD",
      cardTitle: "$propertyCategory $propertyKind",
      cardDescription: "Want to $leadCategory her $bedrooms BHK for ${formatValue(budgetPrice?.start)}-${formatValue(budgetPrice?.end)} rupees",
      customerinfo: cards.Customerinfo(email: email, firstname: firstName, lastname: lastName, mobile: mobileNo, title: companyNamecustomer, whatsapp: whatsAppNo ?? mobileNo),
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
      leadStatus: isEdit ? existingCardStatus : "New",
      typeofoffice: typeofoffice,
      approvedbeds: approvedbeds,
      typeofhospitality: typeofhospitality,
      hospitalityrooms: hospitalityrooms,
      propertykind: propertyKind,
      managerid: currentUserdata?.managerid,
      commericialtype: commericialtype,
      availability: availability,
      typeofretail: typeofretail,
      typeofhealthcare: typeofhealthcare,
      preferredroadwidth: widthofRoad,
      // propertylocation: latlng,
      preferredroadwidthAreaUnit: widthofRoadft,
      villatype: villaType,
      // preferredlocation: latlng,
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
  // for (var user in assignedListInLead) {
  //   if (!isEdit) {
  //     submitActivity(itemid: "IN$randomId", activitytitle: "New Lead assigned to ${user.firstname} ${user.lastname}", user: currentUserdata!);
  //     notifyToUser(
  //         assignedto: user.userid,
  //         title: "Assign new LD$randomId",
  //         content: "LD$randomId New Lead assigned to ${user.firstname} ${user.lastname}",
  //         assigntofield: true,
  //         itemid: "LD$randomId",
  //         currentuserdata: currentUserdata);
  //   } else {
  //     submitActivity(itemid: existingLeadId, activitytitle: "Lead detail updated", user: currentUserdata!);
  //     notifyToUser(
  //         assignedto: user.userid,
  //         title: "Lead detail Updated",
  //         content: "$existingLeadId Lead detail Updated",
  //         assigntofield: true,
  //         itemid: existingLeadId,
  //         currentuserdata: currentUserdata);
  //   }
  // }
  return res;
}
