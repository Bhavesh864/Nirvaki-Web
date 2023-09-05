import 'package:flutter_riverpod/flutter_riverpod.dart';

final leadFilterRentQuestion =
    StateNotifierProvider<FilterRentQuestionary, bool>(
  (ref) => FilterRentQuestionary(),
);

class FilterRentQuestionary extends StateNotifier<bool> {
  FilterRentQuestionary() : super(false);

  void toggleRentQuestionary(bool selectedValue) {
    state = selectedValue;
  }
}

final leadFilterVillaQuestion =
    StateNotifierProvider<FilterVillaQuestionary, bool>(
  (ref) => FilterVillaQuestionary(),
);

class FilterVillaQuestionary extends StateNotifier<bool> {
  FilterVillaQuestionary() : super(false);

  void toggleVillaQuestionary(bool selectedValue) {
    state = selectedValue;
  }
}

final leadFilterPlotQuestion =
    StateNotifierProvider<FilterPlotQuestionary, bool>(
  (ref) => FilterPlotQuestionary(),
);

class FilterPlotQuestionary extends StateNotifier<bool> {
  FilterPlotQuestionary() : super(true);

  void togglePlotQuestionary(bool selectedValue) {
    state = selectedValue;
  }
}

final leadFilterCommercialQuestion =
    StateNotifierProvider<FilterCommercialQuestionary, bool>(
  (ref) => FilterCommercialQuestionary(),
);

class FilterCommercialQuestionary extends StateNotifier<bool> {
  FilterCommercialQuestionary() : super(true);

  void toggleCommericalQuestionary(bool selectedValue) {
    state = selectedValue;
  }
}
