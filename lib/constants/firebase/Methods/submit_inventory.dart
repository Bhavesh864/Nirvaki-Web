import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import 'package:yes_broker/constants/firebase/userModel/broker_info.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart'
    as cards;
import 'package:yes_broker/constants/firebase/detailsModels/inventory_details.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';

final randomId = randomNumeric(5);
Future<String> submitInventoryAndcardDetails(state) async {
  var res = "pending";
  //  inventorycategory example =  rent ,sell
  //   propertycategory example = residental ,commerical,
  final propertyCategory = getDataById(state, 1);
  final inventoryCategory = getDataById(state, 2);
  final inventoryType = getDataById(state, 3);
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
  final carpetArea = getDataById(state, 25);
  final propertyState = getDataById(state, 26);
  final propertyCity = getDataById(state, 27);
  final addressLine1 = getDataById(state, 28);
  final addressLine2 = getDataById(state, 29);
  final floorNumber = getDataById(state, 30);
  final latlng = getDataById(state, 31);
  final propertyFacing = getDataById(state, 32);
  final comments = getDataById(state, 35);
  final User assignto = getDataById(state, 36);

  final cards.CardDetails card = cards.CardDetails(
      workitemId: "IN$randomId",
      status: "New",
      cardCategory: inventoryCategory,
      brokerid: authentication.currentUser!.uid,
      cardType: "IN",
      cardTitle: "$propertyCategory Apartment",
      cardDescription: "Want to $inventoryCategory her 1 BHK for 70 L rupees",
      customerinfo: cards.Customerinfo(
          email: email,
          firstname: firstName,
          lastname: lastName,
          mobile: mobileNo,
          title: companyNamecustomer,
          whatsapp: whatsAppNo),
      cardStatus: "New",
      createdby: cards.Createdby(
          userfirstname: "bhavesh",
          userid: authentication.currentUser!.uid,
          userlastname: "khatri"),
      createdate: Timestamp.now(),
      propertyarearange: cards.Propertyarearange(arearangestart: ""),
      roomconfig:
          cards.Roomconfig(bedroom: bedrooms, additionalroom: additionalRoom),
      propertypricerange: cards.Propertypricerange(arearangestart: '50L'));

  final InventoryDetails inventory = InventoryDetails(
      inventoryTitle: "$propertyCategory Apartment",
      inventoryDescription: "inventoryDescription",
      inventoryId: "IN$randomId",
      inventoryStatus: "New",
      propertykind: propertyKind,
      villatype: villaType,
      transactiontype: transactionType,
      brokerid: authentication.currentUser!.uid,
      inventorycategory: inventoryCategory,
      propertycategory: propertyCategory,
      inventoryType: inventoryType,
      inventorysource: inventorySource,
      possessiondate: possession,
      amenities: amenities,
      reservedparking: Reservedparking(covered: coveredparking),
      propertyarea: Propertyarea(
          unit: areaUnit, superarea: superArea, carpetarea: carpetArea),
      plotdetails:
          Plotdetails(boundarywall: boundaryWall, opensides: openSides),
      customerinfo: Customerinfo(
          email: email,
          firstname: firstName,
          lastname: lastName,
          companyname: companyNamecustomer,
          mobile: mobileNo,
          whatsapp: whatsAppNo),
      roomconfig: Roomconfig(
          bedroom: bedrooms,
          additionalroom: additionalRoom,
          balconies: balconies,
          bathroom: bathrooms),
      propertyfacing: propertyFacing,
      comments: comments,
      propertyaddress: Propertyaddress(
          state: propertyState,
          city: propertyCity,
          addressline1: addressLine1,
          addressline2: addressLine2,
          floornumber: floorNumber),
      propertylocation: latlng,
      createdate: Timestamp.now(),
      assignedto: [
        Assignedto(
            firstname: assignto.userfirstname,
            lastname: assignto.userlastname,
            assignedby: "bhavesh",
            image: assignto.image,
            userid: assignto.userId)
      ],
      createdby: Createdby(
          userfirstname: "bhavesh",
          userid: authentication.currentUser!.uid,
          userlastname: "khatri"));

  await cards.CardDetails.addCardDetails(card)
      .then((value) => {res = "success"});
  await InventoryDetails.addInventoryDetails(inventory)
      .then((value) => {res = "success"});
  return res;
}
