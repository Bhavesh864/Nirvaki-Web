import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddMemberScreenStateNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  AddMemberScreenStateNotifier() : super([]);

  void addUser(user) {
    final userIsFavorite = state.contains(user);
    if (userIsFavorite) {
      state = state.where((m) => m["id"] != user["id"]).toList();
    } else {
      state = [...state, user];
    }
  }

  void emptyList() {
    state = [];
  }
}

final chatUserProvider = StateNotifierProvider<AddMemberScreenStateNotifier, List<Map<String, dynamic>>>((ref) {
  return AddMemberScreenStateNotifier();
});
