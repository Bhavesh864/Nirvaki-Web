import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/firebase/questionModels/inventory_question.dart';

final allInventoryQuestion = StateNotifierProvider<AllInventoryQuestion, List<Screen>>((ref) {
  return AllInventoryQuestion();
});

class AllInventoryQuestion extends StateNotifier<List<Screen>> {
  AllInventoryQuestion() : super([]);
  void addAllQuestion(data) {
    state = data;
  }

  void updateScreenIsActive({required List<String> setTrueInScreens, required List<String> setFalseInScreens}) {
    for (var screen in state) {
      if (setTrueInScreens.contains(screen.screenId)) {
        screen.isActive = true;
      }
      if (setFalseInScreens.contains(screen.screenId)) {
        screen.isActive = false;
      }
    }
  }
}
