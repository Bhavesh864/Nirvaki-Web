import 'package:random_string/random_string.dart';
import 'package:yes_broker/constants/firebase/userModel/broker_info.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart'
    as cards;
import 'package:yes_broker/constants/firebase/detailsModels/inventory_details.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';

final randomId = randomNumeric(5);
void submitInventoryAndcardDetails(state) async {
  //  inventorycategory example =  rent ,sell
  //   propertycategory example = residental ,commerical,
  final String propertyCategory = getDataById(state, 1);
  final String inventoryCategory = getDataById(state, 2);
  final String inventoryType = getDataById(state, 3);
  final String inventorySource = getDataById(state, 4);
  final String firstName = getDataById(state, 5);
  final String lastName = getDataById(state, 6);
  final String mobileNo = getDataById(state, 7);
  final String whatsAppNo = getDataById(state, 8);
  final String email = getDataById(state, 9);
  final String companyNamecustomer = getDataById(state, 10);
  final String propertyKind = getDataById(state, 11);
  final String villaType = getDataById(state, 12);
  final String transactionType = getDataById(state, 13);
  final String bedrooms = getDataById(state, 14);
  final List<String> additionalRoom = getDataById(state, 15);
  final String bathrooms = getDataById(state, 16);
  final String balconies = getDataById(state, 17);
  final String boundaryWall = getDataById(state, 18);
  final String openSides = getDataById(state, 19);
  final String possession = getDataById(state, 20);
  final List<String> amenities = getDataById(state, 21);
  final String coveredparking = getDataById(state, 22);
  final String areaUnit = getDataById(state, 23);
  final String superArea = getDataById(state, 24);
  final String carpetArea = getDataById(state, 25);
  final String propertyState = getDataById(state, 26);
  final String propertyCity = getDataById(state, 27);
  final String addressLine1 = getDataById(state, 28);
  final String addressLine2 = getDataById(state, 29);
  final String floorNumber = getDataById(state, 30);
  final String propertyFacing = getDataById(state, 32);
  final String comments = getDataById(state, 35);
  final List<Map<String, dynamic>> assignto = getDataById(state, 36);

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
      assignedto: [
        Assignedto(
            firstname: assignto[0]["userfirstname"],
            lastname: assignto[0]["userlastname"],
            assignedby: "bhavesh",
            image: assignto[0]["image"].toString(),
            userid: assignto[0]["userId"])
      ],
      createdby: Createdby(
          userfirstname: "bhavesh",
          userid: authentication.currentUser!.uid,
          userlastname: "khatri"));
  // await InventoryDetails.addInventoryDetails(inventory);
  // print('category $inventoryCategory');
  // print('type $propertyCategory');
}
