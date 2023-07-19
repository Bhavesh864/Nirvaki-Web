import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_string/random_string.dart';
import 'package:yes_broker/constants/firebase/broker_info.dart';
import 'package:yes_broker/constants/firebase/card_details.dart' as cards;
import 'package:yes_broker/constants/firebase/inventory_details.dart';

import 'package:yes_broker/constants/firebase/user_info.dart';

final allChipSelectedAnwersProvider =
    StateNotifierProvider<AllChipSelectedAnwers, List<Map<String, dynamic>>>(
  (ref) => AllChipSelectedAnwers(),
);

class AllChipSelectedAnwers extends StateNotifier<List<Map<String, dynamic>>> {
  AllChipSelectedAnwers() : super([]);

  void add(Map<String, dynamic> selectedValue) {
    state = [...state, selectedValue];
    // print('state, $state');
  }

  void remove(int id) {
    state.retainWhere(
      (element) => element['id'] != id,
    );
  }

  final randomId = randomNumeric(5);
  void submitInventoryDetails() async {
    //   propertycategory example = residental ,commerical,
    //  inventorycategory example =  rent ,sell
    final String propertyCategory = getDataById(state, 1);
    final String inventoryCategory = getDataById(state, 2);
    final String inventoryType = getDataById(state, 3);
    final String inventorySource = getDataById(state, 4);
    final String propertyKind = getDataById(state, 6);
    final String villaType = getDataById(state, 7);
    final String transactionType = getDataById(state, 8);

    final cards.CardDetails card = cards.CardDetails(
        workitemId: "IN$randomId",
        status: "New",
        cardCategory: inventoryCategory,
        brokerid: authentication.currentUser!.uid,
        cardType: "IN",
        cardTitle: "$propertyCategory Apartment",
        cardDescription: "Want to $inventoryCategory her 1 BHK for 70 L rupees",
        customerinfo: cards.Customerinfo(),
        cardStatus: "New",
        createdby: cards.Createdby(
            userfirstname: "jack",
            userid: authentication.currentUser!.uid,
            userlastname: "adam"),
        propertyarearange: cards.Propertyarearange(arearangestart: ""),
        roomconfig: cards.Roomconfig(bedroom: ''),
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
        createdby: Createdby(
            userfirstname: "jack",
            userid: authentication.currentUser!.uid,
            userlastname: "adam"));
    // await InventoryDetails.addInventoryDetails(inventory);
    // print('category $inventoryCategory');
    // print('type $propertyCategory');
  }
}

final allDropDownSelectedAnswers =
    StateNotifierProvider<AllDropdownSelectedAnwers, List<String>>(
  (ref) => AllDropdownSelectedAnwers(),
);

class AllDropdownSelectedAnwers extends StateNotifier<List<String>> {
  AllDropdownSelectedAnwers() : super([]);

  void add(String selectedValue) {
    state = [...state, selectedValue];
  }
}
