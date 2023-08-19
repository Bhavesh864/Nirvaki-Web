import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedWorkItemId = StateNotifierProvider<SelectedWorkItemId, String>(
  (ref) => SelectedWorkItemId(),
);

class SelectedWorkItemId extends StateNotifier<String> {
  SelectedWorkItemId() : super('');

  void addItemId(String id) {
    print('state $id');
    state = id;
  }

  void clear() {
    state = '';
  }
}
