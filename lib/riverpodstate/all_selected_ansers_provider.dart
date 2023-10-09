import 'package:flutter/foundation.dart';
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
    if (kDebugMode) {
      print('state, $state');
    }
  }

  void remove(List<int> ids) {
    final currentValue = state;
    state = currentValue.where((item) => !ids.contains(item['id'])).toList();
    if (kDebugMode) {
      print('state: $state');
    }
  }

  void resetState() {
    state = [];
  }

  void addAllvalues(List<Map<String, dynamic>> selectedValue) {
    state = selectedValue;
  }

  Future<String> submitInventory(bool isEdit, WidgetRef ref) async {
    final String res = await submitInventoryAndcardDetails(state, isEdit, ref);
    return res;
  }

  Future<String> submitLead(bool isEdit, WidgetRef ref) async {
    final String res = await submitLeadAndCardDetails(state, isEdit, ref);
    return res;
  }

  Future<String> submitTodo(WidgetRef ref) async {
    final String res = await submitTodoAndCardDetails(state, ref);
    return res;
  }
}
