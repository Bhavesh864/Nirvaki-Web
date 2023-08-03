import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedSignupItems extends StateNotifier<List<Map<String, dynamic>>> {
  SelectedSignupItems() : super([]);

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
}
