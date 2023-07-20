import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/constants/firebase/Methods/submit_inventory.dart';

final allChipSelectedAnwersProvider =
    StateNotifierProvider<AllChipSelectedAnwers, List<Map<String, dynamic>>>(
  (ref) => AllChipSelectedAnwers(),
);

class AllChipSelectedAnwers extends StateNotifier<List<Map<String, dynamic>>> {
  AllChipSelectedAnwers() : super([]);

  void add(Map<String, dynamic> selectedValue) {
    final currentValue = state;
    if (currentValue.any((g) => g["id"] == selectedValue["id"])) {
      state = [
        ...currentValue.where((g) => g["id"] != selectedValue["id"]),
        selectedValue
      ];
    } else {
      state = [...currentValue, selectedValue];
    }
    // state = [...state, selectedValue];
    print('state, $state');
  }

  // void validate(GlobalKey<FormState> formKey)

  //    if (formKey.currentState!.validate()) {
  //     // The form is valid, proceed with the desired action.
  //     // For example, you can save the data or navigate to the next screen.
  //   }
  // }

  void remove(List<int> ids) {
    final currentValue = state;
    state = currentValue.where((item) => !ids.contains(item['id'])).toList();
    print('state: $state');
  }

  // void remove(int id) {
  //   state.retainWhere(
  //     (element) => element['id'] != id,
  //   );
  //   print('state $state');
  // }

  // void removeValue(int id) {
  //   state = state.where((item) => item["id"] != id).toList();
  // }

  // void removev(value) {
  //   state = [...state.where((g) => g["id"] != value["id"])];
  // }

  void submitInventory() async {
    submitInventoryAndcardDetails(state);
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
