import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/constants/firebase/Methods/submit_inventory.dart';
import 'package:yes_broker/constants/firebase/Methods/submit_lead.dart';
import 'package:yes_broker/constants/firebase/Methods/submit_todo.dart';

final allChipSelectedAnwersProvider = StateNotifierProvider<AllChipSelectedAnwers, List<Map<String, dynamic>>>(
  (ref) => AllChipSelectedAnwers(),
);

class AllChipSelectedAnwers extends StateNotifier<List<Map<String, dynamic>>> {
  AllChipSelectedAnwers() : super([]);

  void add(Map<String, dynamic> selectedValue) {
    final currentValue = state;
    if (currentValue.any((g) => g["id"] == selectedValue["id"])) {
      state = [...currentValue.where((g) => g["id"] != selectedValue["id"]), selectedValue];
    } else {
      state = [...currentValue, selectedValue];
    }
    print('state, $state');
  }

  void remove(List<int> ids) {
    final currentValue = state;
    state = currentValue.where((item) => !ids.contains(item['id'])).toList();
    print('state: $state');
  }

  Future<String> submitInventory() async {
    final String res = await submitInventoryAndcardDetails(state);
    return res;
  }

  Future<String> submitLead() async {
    final String res = await submitLeadAndCardDetails(state);
    return res;
  }

  Future<String> submitTodo() async {
    final String res = await submitTodoAndCardDetails(state);
    return res;
  }
}

final allDropDownSelectedAnswers = StateNotifierProvider<AllDropdownSelectedAnwers, List<String>>(
  (ref) => AllDropdownSelectedAnwers(),
);

class AllDropdownSelectedAnwers extends StateNotifier<List<String>> {
  AllDropdownSelectedAnwers() : super([]);

  void add(String selectedValue) {
    state = [...state, selectedValue];
  }
}
