import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import 'package:yes_broker/constants/firebase/detailsModels/lead_details.dart';

import 'package:yes_broker/constants/firebase/userModel/broker_info.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart' as cards;

import 'package:yes_broker/constants/firebase/userModel/user_info.dart';

final randomId = randomNumeric(5);
Future<String> submitLeadAndCardDetails(state) async {
  var res = "pending";
  //  leadcategory example =  rent ,buy
  //   propertycategory example = residental ,commerical,
  final propertyCategory = getDataById(state, 1);
  final leadCategory = getDataById(state, 2);
  final leadType = getDataById(state, 3);
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
  final expectedArea = getDataById(state, 24);
  final propertyState = getDataById(state, 26);
  final propertyCity = getDataById(state, 27);
  final addressLine1 = getDataById(state, 28);
  final addressLine2 = getDataById(state, 29);
  final floorNumber = getDataById(state, 30);
  final latlng = getDataById(state, 31);
  final budgetPrice = getDataById(state, 32);
  final budgetFigures = getDataById(state, 33);
  final preferredpropertyfacing = getDataById(state, 34);
  final comments = getDataById(state, 35);
  final User assignto = getDataById(state, 36);

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

  final cards.CardDetails card = cards.CardDetails(
      workitemId: "LD$randomId",
      status: "New",
      cardCategory: leadCategory,
      linkedItemType: "LD",
      brokerid: authentication.currentUser!.uid,
      cardType: "LD",
      cardTitle: "$propertyCategory $propertyKind-$propertyCity",
      cardDescription: "Want to $leadCategory her $bedrooms BHK for $budgetPrice $budgetFigures rupees",
      customerinfo: cards.Customerinfo(email: email, firstname: firstName, lastname: lastName, mobile: mobileNo, title: companyNamecustomer, whatsapp: whatsAppNo),
      cardStatus: "New",
      assignedto: [cards.Assignedto(firstname: assignto.userfirstname, lastname: assignto.userlastname, assignedby: "bhavesh", image: assignto.image, userid: assignto.userId)],
      createdby: cards.Createdby(userfirstname: "bhavesh", userid: authentication.currentUser!.uid, userlastname: "khatri"),
      createdate: Timestamp.now(),
      propertyarearange: cards.Propertyarearange(arearangestart: expectedArea, unit: areaUnit),
      roomconfig: cards.Roomconfig(bedroom: bedrooms, additionalroom: additionalRoom),
      propertypricerange: cards.Propertypricerange(arearangestart: budgetPrice, unit: budgetFigures));

  final LeadDetails lead = LeadDetails(
      leadTitle: "$propertyCategory $propertyKind-$propertyCity",
      leadDescription: "lead",
      leadId: "LD$randomId",
      leadStatus: "New",
      typeofoffice: typeofoffice,
      approvedbeds: approvedbeds,
      typeofhospitality: typeofhospitality,
      hospitalrooms: hospitalrooms,
      propertykind: propertyKind,
      commericialtype: commericialtype,
      availability: availability,
      typeofretail: typeofretail,
      typeofhealthcare: typeofhealthcare,
      preferredroadwidth: widthofRoad,
      propertylocation: latlng,
      villatype: villaType,
      preferredlocation: latlng,
      typeofschool: typeofschool,
      transactiontype: transactionType,
      brokerid: authentication.currentUser!.uid,
      leadcategory: leadCategory,
      propertycategory: propertyCategory,
      leadType: leadType,
      preferredpropertyfacing: preferredpropertyfacing,
      leadsource: leadSource,
      possessiondate: possession,
      plotdetails: Plotdetails(boundarywall: boundaryWall, opensides: openSides),
      amenities: amenities,
      preferredlocality: Preferredlocality(state: propertyState, city: propertyCity, addressline1: addressLine1, addressline2: addressLine2, prefferedfloornumber: floorNumber),
      propertyarearange: Propertyarearange(unit: areaUnit, arearangestart: expectedArea),
      propertypricerange: Propertypricerange(unit: budgetFigures, arearangestart: budgetPrice),
      reservedparking: Reservedparking(covered: coveredparking),
      customerinfo: Customerinfo(email: email, firstname: firstName, lastname: lastName, companyname: companyNamecustomer, mobile: mobileNo, whatsapp: whatsAppNo),
      roomconfig: Roomconfig(bedroom: bedrooms, additionalroom: additionalRoom, balconies: balconies, bathroom: bathrooms),
      comments: comments,
      createdate: Timestamp.now(),
      assignedto: [Assignedto(firstname: assignto.userfirstname, lastname: assignto.userlastname, assignedby: "bhavesh", image: assignto.image, userid: assignto.userId)],
      createdby: Createdby(userfirstname: "bhavesh", userid: authentication.currentUser!.uid, userlastname: "khatri"));

  await cards.CardDetails.addCardDetails(card).then((value) => {res = "success"});
  await LeadDetails.addLeadDetails(lead).then((value) => {res = "success"});
  return res;
}
