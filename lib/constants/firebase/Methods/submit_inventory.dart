import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_string/random_string.dart';
import 'package:yes_broker/constants/app_constant.dart';

import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart' as cards;
import 'package:yes_broker/constants/firebase/detailsModels/inventory_details.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';

import '../../../riverpodstate/user_data.dart';
import '../../functions/convertStringTorange/convert_number_to_string.dart';

Future<String> submitInventoryAndcardDetails(state, bool isEdit, WidgetRef ref) async {
  final User? currentUserdata = ref.read(userDataProvider);
  final randomId = randomNumeric(5);
  var res = "pending";
  //  inventorycategory example =  rent ,sell
  //   propertycategory example = residental ,commerical,
  final propertyCategory = getDataById(state, 1);
  final inventoryCategory = getDataById(state, 2);
  // final inventoryType = getDataById(state, 3);
  final inventorySource = getDataById(state, 4);
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
  final propertyState = getDataById(state, 26);
  final propertyCity = getDataById(state, 27);
  final addressLine1 = getDataById(state, 28);
  final addressLine2 = getDataById(state, 29);
  final floorNumber = getDataById(state, 30);
  final latlng = getDataById(state, 31);
  final propertyFacing = getDataById(state, 32);
  final photos = getDataById(state, 33);
  final video = getDataById(state, 34);
  final comments = getDataById(state, 35);
  final List<User> assignto = getDataById(state, 36);
  final availability = getDataById(state, 37);
  final commericialtype = getDataById(state, 38);
  final typeofoffice = getDataById(state, 39);
  final typeofretail = getDataById(state, 40);
  final typeofhospitality = getDataById(state, 41);
  final typeofhealthcare = getDataById(state, 42);
  final approvedbeds = getDataById(state, 43);
  final typeofschool = getDataById(state, 44);
  final hospitalrooms = getDataById(state, 45);
  final price = getDataById(state, 46);
  // final priceunit = getDataById(state, 47);
  final rentamount = getDataById(state, 48);
  // final rentunit = getDataById(state, 49);
  final securityamount = getDataById(state, 50);
  final securityunit = getDataById(state, 51);
  final lockinperiod = getDataById(state, 52);
  final commercialphotos = getDataById(state, 53);
  final locality = getDataById(state, 54);
  final furnishedStatus = getDataById(state, 55);
  final attachments = getDataById(state, 100);
  final existingInventoryId = getDataById(state, 101);

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
      workitemId: isEdit ? existingInventoryId : "IN$randomId",
      status: "New",
      cardCategory: inventoryCategory,
      linkedItemType: "IN",
      brokerid: currentUserdata?.brokerId,
      managerid: currentUserdata?.managerid,
      cardType: "IN",
      cardTitle: "$propertyCategory $propertyKind-$propertyCity",
      cardDescription:
          "Want to $inventoryCategory her $bedrooms BHK for ${inventoryCategory == "Rent" ? convertToCroresAndLakhs(rentamount) : convertToCroresAndLakhs(price)} rupees",
      customerinfo: cards.Customerinfo(email: email, firstname: firstName, lastname: lastName, mobile: mobileNo, title: companyNamecustomer, whatsapp: whatsAppNo ?? mobileNo),
      cardStatus: "New",
      assignedto: assignedToList,
      createdby: cards.Createdby(
          userfirstname: currentUserdata?.userfirstname, userid: currentUserdata?.userId, userlastname: currentUserdata?.userlastname, userimage: currentUserdata?.image),
      createdate: Timestamp.now(),
      propertyarearange: cards.Propertyarearange(arearangestart: superArea, unit: areaUnit),
      roomconfig: cards.Roomconfig(bedroom: bedrooms, additionalroom: additionalRoom),
      propertypricerange: cards.Propertypricerange(arearangestart: inventoryCategory == "Rent" ? convertToCroresAndLakhs(rentamount) : convertToCroresAndLakhs(price)));
  final List<Assignedto> assignedListInInventory = assignto.map((user) {
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
  final InventoryDetails inventory = InventoryDetails(
      inventoryTitle: "$propertyCategory $title $propertyKind",
      inventoryDescription: "Want to $inventoryCategory her $bedrooms BHK for $price rupees",
      inventoryId: isEdit ? existingInventoryId : "IN$randomId",
      inventoryStatus: "New",
      typeofoffice: typeofoffice,
      approvedbeds: approvedbeds,
      managerid: currentUserdata?.managerid,
      typeofhospitality: typeofhospitality,
      hospitalrooms: hospitalrooms,
      propertykind: propertyKind,
      commericialtype: commericialtype,
      typeofretail: typeofretail,
      typeofhealthcare: typeofhealthcare,
      villatype: villaType,
      typeofschool: typeofschool,
      transactiontype: transactionType,
      brokerid: currentUserdata?.brokerId,
      inventorycategory: inventoryCategory,
      propertycategory: propertyCategory,
      inventoryType: inventorySource == "Broker" ? "Broker" : inventorySource,
      inventorysource: inventorySource,
      possessiondate: possession,
      amenities: amenities ?? [],
      attachments: attachments ?? [],
      commercialphotos: commercialphotos,
      propertyrent: Propertyrent(rentamount: rentamount, securityamount: securityamount, securityunit: securityunit, lockinperiod: lockinperiod),
      availability: availability,
      propertyprice: Propertyprice(price: price),
      reservedparking: Reservedparking(covered: coveredparking),
      propertyarea: Propertyarea(unit: areaUnit, superarea: superArea),
      plotdetails: Plotdetails(boundarywall: boundaryWall, opensides: openSides),
      customerinfo: Customerinfo(email: email, firstname: firstName, lastname: lastName, companyname: companyNamecustomer, mobile: mobileNo, whatsapp: whatsAppNo ?? mobileNo),
      roomconfig: Roomconfig(bedroom: bedrooms, additionalroom: additionalRoom ?? [], balconies: balconies, bathroom: bathrooms),
      propertyfacing: propertyFacing,
      comments: comments,
      furnishedStatus: furnishedStatus,
      plotarea: Plotarea(area: superArea, unit: areaUnit),
      propertyaddress:
          Propertyaddress(state: propertyState, city: propertyCity, addressline1: addressLine1, addressline2: addressLine2, floornumber: floorNumber, locality: locality),
      propertylocation: latlng,
      propertyvideo: video,
      propertyphotos: photos,
      createdate: Timestamp.now(),
      updatedby: AppConst.getAccessToken(),
      assignedto: assignedListInInventory,
      createdby: Createdby(
          userfirstname: currentUserdata?.userfirstname, userid: currentUserdata?.userId, userlastname: currentUserdata?.userlastname, userimage: currentUserdata?.image));

  isEdit
      ? await cards.CardDetails.updateCardDetails(id: existingInventoryId, cardDetails: card).then((value) => {res = "success"})
      : await cards.CardDetails.addCardDetails(card).then((value) => {res = "success"});
  isEdit
      ? await InventoryDetails.updateInventoryDetails(id: existingInventoryId, inventoryDetails: inventory).then((value) => {res = "success"})
      : await InventoryDetails.addInventoryDetails(inventory).then((value) => {res = "success"});
  return res;
}
