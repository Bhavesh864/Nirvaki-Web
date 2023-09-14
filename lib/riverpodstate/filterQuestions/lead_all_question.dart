import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/firebase/questionModels/lead_question.dart';

final allLeadQuestion = StateNotifierProvider<AllLeadQuestion, List<Screen>>((ref) {
  return AllLeadQuestion();
});

class AllLeadQuestion extends StateNotifier<List<Screen>> {
  AllLeadQuestion() : super([]);
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
