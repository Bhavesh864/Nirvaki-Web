import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_string/random_string.dart';
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

  void remove(int id) {
    state.retainWhere(
      (element) => element['id'] != id,
    );
    // print(state);
  }

  void removeValue(int id) {
    state = state.where((item) => item["id"] != id).toList();
  }

  void addOrReplaceGender(gender) {
    final currentGenders = state;
    if (currentGenders.any((g) => g["id"] == gender["id"])) {
      state = [...currentGenders.where((g) => g["id"] != gender["id"]), gender];
    } else {
      state = [...currentGenders, gender];
    }
  }

  void removeGender(gender) {
    state = [...state.where((g) => g["id"] != gender["id"])];
  }

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
