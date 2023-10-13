import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final areaRangeSelectorState = StateNotifierProvider<AreaRangeSelectorState, RangeValues>((ref) {
  return AreaRangeSelectorState();
});

class AreaRangeSelectorState extends StateNotifier<RangeValues> {
  AreaRangeSelectorState() : super(const RangeValues(100, 10000));

  void setRange(RangeValues rangeValues) {
    state = rangeValues;
  }
}

final defaultAreaRangeValuesNotifier = StateNotifierProvider<DefaultAreaRangeSelectorState, RangeValues>((ref) {
  return DefaultAreaRangeSelectorState();
});

class DefaultAreaRangeSelectorState extends StateNotifier<RangeValues> {
  DefaultAreaRangeSelectorState() : super(const RangeValues(100, 10000));

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
