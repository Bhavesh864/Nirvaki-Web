import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedWorkItemId = StateNotifierProvider<SelectedWorkItemId, String>(
  (ref) => SelectedWorkItemId(),
);

class SelectedWorkItemId extends StateNotifier<String> {
  SelectedWorkItemId() : super("");

  void addItemId(String id) {
    state = id;
  }

  // void clear() {
  //   state = '';
  // }
}

// final selectedTodoItemId = StateNotifierProvider<SelectedTodoItemId, String>(
//   (ref) => SelectedTodoItemId(),
// );

// class SelectedTodoItemId extends StateNotifier<String> {
//   SelectedTodoItemId() : super("");

//   void addItemId(String id) {
//     state = id;
//   }
// }

// final selectedInventoryItemId = StateNotifierProvider<SelectedInventoryItemId, String>(
//   (ref) => SelectedInventoryItemId(),
// );

// class SelectedInventoryItemId extends StateNotifier<String> {
//   SelectedInventoryItemId() : super("");

//   void addItemId(String id) {
//     state = id;
//   }
// }

// final selectedLeadItemId = StateNotifierProvider<SelectedLeadItemId, String>(
//   (ref) => SelectedLeadItemId(),
// );

// class SelectedLeadItemId extends StateNotifier<String> {
//   SelectedLeadItemId() : super("");

//   void addItemId(String id) {
//     state = id;
//   }
// }
