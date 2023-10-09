import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// final areaRangeProvider = StateProvider<RangeValues>((_) => const RangeValues(500, 10000));
//
// final selectedOptionProvider = StateProvider<String>((_) => '');
//
// void createAreaRange(RangeValues newAreaRange) {
//   state = newAreaRange;
// }
//
// void createDefaultAreaRangeValues() {
//   ref.read(defaultAreaRangeValuesProvider.notifier).state = ref.read(areaRangeProvider.state);
// }
//
// void createSelectedOption(String newSelectedOption) {
//   ref.read(selectedOptionProvider.notifier).state = newSelectedOption;
// }
//
// RangeValues readAreaRange() {
//   return ref.read(areaRangeProvider.state);
// }
//
// RangeValues readDefaultAreaRangeValues() {
//   return ref.read(defaultAreaRangeValuesProvider.state);
// }
//
// String readSelectedOption() {
//   return ref.read(selectedOptionProvider.state);
// }

final areaRangeSelectorState = StateNotifierProvider<AreaRangeSelectorState, RangeValues>((ref) {
  return AreaRangeSelectorState();
});

class AreaRangeSelectorState extends StateNotifier<RangeValues> {
  AreaRangeSelectorState() : super(const RangeValues(500, 10000));

  void setRange(RangeValues rangeValues) {
    state = rangeValues;
  }
}

final defaultAreaRangeValuesNotifier = StateNotifierProvider<DefaultAreaRangeSelectorState, RangeValues>((ref) {
  return DefaultAreaRangeSelectorState();
});

class DefaultAreaRangeSelectorState extends StateNotifier<RangeValues> {
  DefaultAreaRangeSelectorState() : super(const RangeValues(500, 10000));

  void setRange(RangeValues rangeValues) {
    state = rangeValues;
  }
}

final selectedOptionNotifier = StateNotifierProvider<SelectedOptionState, String>((ref) {
  return SelectedOptionState();
});

class SelectedOptionState extends StateNotifier<String> {
  SelectedOptionState() : super('Sq ft');

  void setRange(String rangeValues) {
    state = rangeValues;
  }
}
