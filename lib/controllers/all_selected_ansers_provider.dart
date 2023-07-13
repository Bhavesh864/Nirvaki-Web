import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_string/random_string.dart';
import 'package:yes_broker/constants/firebase/broker_info.dart';
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
  }

  void remove(String selectedValue) {
    final index = state
        .indexWhere((element) => element['selectedAnswer'] == selectedValue);
    state.removeAt(index);
  }

  final randomId = randomNumeric(5);
  void submitInventoryDetails() async {
    final String propertyCategory = getDataById(state, 1);
    final String inventoryCategory = getDataById(state, 2);
    final InventoryDetails inventory = InventoryDetails(
        inventoryTitle: "$propertyCategory Apartment",
        inventoryDescription: "inventoryDescription",
        inventoryId: "IN$randomId",
        inventoryStatus: "New",
        brokerid: authentication.currentUser!.uid,
        inventorycategory: inventoryCategory,
        propertycategory: propertyCategory,
        createdby: Createdby(
            userfirstname: "bhavesh",
            userid: authentication.currentUser!.uid,
            userlastname: "khatri"));
    await InventoryDetails.addInventoryDetails(inventory);
    print('category $inventoryCategory');
    print('type $propertyCategory');
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
