import 'package:flutter_riverpod/flutter_riverpod.dart';

final allSelectedAnswersProvider =
    StateNotifierProvider<AllSelectedAnwersNotifier, List<String>>(
  (ref) => AllSelectedAnwersNotifier(),
);

class AllSelectedAnwersNotifier extends StateNotifier<List<String>> {
  AllSelectedAnwersNotifier() : super([]);

  void add(String selectedValue) {
    state = [...state, selectedValue];
  }
}
