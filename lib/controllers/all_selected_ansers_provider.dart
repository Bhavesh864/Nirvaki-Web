import 'package:flutter_riverpod/flutter_riverpod.dart';

final allChipSelectedAnwersProvider =
    StateNotifierProvider<AllChipSelectedAnwers, List<Map<String, dynamic>>>(
  (ref) => AllChipSelectedAnwers(),
);

class AllChipSelectedAnwers extends StateNotifier<List<Map<String, dynamic>>> {
  AllChipSelectedAnwers() : super([]);

  void add(Map<String, dynamic> selectedValue) {
    state = [...state, selectedValue];
    print('state, $state');
  }

  void remove(int id) {
    state.retainWhere(
      (element) => element['id'] != id,
    );
    print(state);
  }

  void submitInventoryDetails() {
    print('state $state');
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
