import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/constants/firebase/Methods/sign_up_method.dart';

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

  Future<String?> signup() async {
    final res = await signUpMethod(state: state);

    return res;
  }

  void remove(List<int> ids) {
    final currentValue = state;
    state = currentValue.where((item) => !ids.contains(item['id'])).toList();
    print('state: $state');
  }
}

class LoadingStatus extends StateNotifier<bool> {
  LoadingStatus() : super(false);

  void setLoadingstatus(bool item) {
    state = item;
  }
}
