// ignore: file_names
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupMembersIds extends StateNotifier<List<String>> {
  GroupMembersIds() : super([]);
  void toggleId(id) {
    final userIsFavorite = state.contains(id);
    if (userIsFavorite) {
      state = state.where((m) => m != id).toList();
    } else {
      state = [...state, id];
    }
  }

  void emptyList() {
    state = [];
  }

  void addAll(List<String> id) {
    state = [...id];
  }

  void addIds(List<String> id) {
    state = [...state, ...id];
  }
}

final groupMemberIds = StateNotifierProvider<GroupMembersIds, List<String>>((ref) {
  return GroupMembersIds();
});
