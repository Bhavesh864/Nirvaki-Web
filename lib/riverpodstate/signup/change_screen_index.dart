import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangeScreenIndex extends StateNotifier<int> {
  ChangeScreenIndex() : super(0);

  void update(int selectedValue) {
    state = selectedValue;
  }

  void emptyAllFields() {
    state = 0;
  }

  // void remove(List<int> ids) {
  //   final currentValue = state;
  //   state = currentValue.where((item) => !ids.contains(item['id'])).toList();
  //   print('state: $state');
  // }
}

class LoadingStatus extends StateNotifier<bool> {
  LoadingStatus() : super(false);

  void setLoadingstatus(bool item) {
    state = item;
  }
}
