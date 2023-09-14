import 'package:flutter_riverpod/flutter_riverpod.dart';

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

final filterOfficeQuestion = StateNotifierProvider<FilterOfficeQuestionary, bool>(
  (ref) => FilterOfficeQuestionary(),
);

class FilterOfficeQuestionary extends StateNotifier<bool> {
  FilterOfficeQuestionary() : super(false);

  void toggleFilterOfficeQuestionary(bool selectedValue) {
    state = selectedValue;
  }
}

final filterRetailQuestion = StateNotifierProvider<FilterRetailQuestionary, bool>(
  (ref) => FilterRetailQuestionary(),
);

class FilterRetailQuestionary extends StateNotifier<bool> {
  FilterRetailQuestionary() : super(false);

  void toggleFilterRetailQuestionary(bool selectedValue) {
    state = selectedValue;
  }
}

final filterIndustrialQuestion = StateNotifierProvider<FilterIndustrialQuestionary, bool>(
  (ref) => FilterIndustrialQuestionary(),
);

class FilterIndustrialQuestionary extends StateNotifier<bool> {
  FilterIndustrialQuestionary() : super(false);

  void toggleFilterIndustrialQuestionary(bool selectedValue) {
    state = selectedValue;
  }
}
