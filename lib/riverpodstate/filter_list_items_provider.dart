import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/firebase/detailsModels/card_details.dart';

final filterOptionsForTodo = StateNotifierProvider<SelectedFilterForTodo, List<String>>(
  (ref) => SelectedFilterForTodo(),
);

class SelectedFilterForTodo extends StateNotifier<List<String>> {
  SelectedFilterForTodo() : super([]);

  void addTodoFilter(String selectedFilterOption) {
    List<String> currentState = state;
    currentState.add(selectedFilterOption);
    state = currentState;
  }

  void removeTodoFilter(String selectedFilterOption) {
    state.remove(selectedFilterOption);
  }
}

final selectedFilterInventory = StateNotifierProvider<SelectedFilterInventory, List<String>>(
  (ref) => SelectedFilterInventory(),
);

class SelectedFilterInventory extends StateNotifier<List<String>> {
  SelectedFilterInventory() : super([]);

  void addInventoryFilter(String selectedFilterOption) {
    state.add(selectedFilterOption);
  }

  void removeInventoryFilter(String selectedFilterOption) {
    state.remove(selectedFilterOption);
  }
}

final selectedFilterLead = StateNotifierProvider<SelectedFilterForLead, List<String>>(
  (ref) => SelectedFilterForLead(),
);

class SelectedFilterForLead extends StateNotifier<List<String>> {
  SelectedFilterForLead() : super([]);
}

final filteredCardListProvider = StateNotifierProvider<FilteredCardListNotifier, List<CardDetails>>((ref) {
  return FilteredCardListNotifier();
});

class FilteredCardListNotifier extends StateNotifier<List<CardDetails>> {
  FilteredCardListNotifier() : super([]);

  void updateFilteredList(List<CardDetails> filteredList) {
    state = filteredList;
  }
}

///////////////////////////////
///
final appliedTodoFiltersProvider = StateProvider<List<String>>((ref) => []);



//  print(list);

//                               list.map((e) {
//                                 filterTodoList = todoItemsList.where((item) {
//                                   if (list.isEmpty) {
//                                     return true;
//                                   } else {
//                                     final status = item.cardStatus!.toLowerCase();
//                                     final linkedItem = item.linkedItemType!.toLowerCase();
//                                     final todoType = item.cardType!.toLowerCase();

//                                     print(status);

//                                     return status.contains(e.toLowerCase()) || linkedItem.contains(e.toLowerCase()) || todoType.contains(e.toLowerCase());
//                                   }
//                                 }).toList();
//                               });
//                               setState(() {});