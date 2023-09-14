import 'package:flutter_riverpod/flutter_riverpod.dart';

final filterComRentQuestion = StateNotifierProvider<FilterComRentQuestionary, bool>(
  (ref) => FilterComRentQuestionary(),
);

class FilterComRentQuestionary extends StateNotifier<bool> {
  FilterComRentQuestionary() : super(false);

  void toggleComRentQuestionary(bool selectedValue) {
    state = selectedValue;
  }
}

final filterLandQuestion = StateNotifierProvider<FilterLandQuestionary, bool>(
  (ref) => FilterLandQuestionary(),
);

class FilterLandQuestionary extends StateNotifier<bool> {
  FilterLandQuestionary() : super(false);

  void toggleLandQuestionary(bool selectedValue) {
    state = selectedValue;
  }
}

final filterConstructedPropertyQuestion = StateNotifierProvider<FilterConstructedPropertyQuestionary, bool>(
  (ref) => FilterConstructedPropertyQuestionary(),
);

class FilterConstructedPropertyQuestionary extends StateNotifier<bool> {
  FilterConstructedPropertyQuestionary() : super(false);

  void toggleContructedPropertyQuestionary(bool selectedValue) {
    state = selectedValue;
  }
}

final filterUnderConstructionPropertyQuestion = StateNotifierProvider<FilterUnderConstructionPropertyQuestionary, bool>(
  (ref) => FilterUnderConstructionPropertyQuestionary(),
);

class FilterUnderConstructionPropertyQuestionary extends StateNotifier<bool> {
  FilterUnderConstructionPropertyQuestionary() : super(false);

  void toggleUnderContructionPropertyQuestionary(bool selectedValue) {
    state = selectedValue;
  }
}
