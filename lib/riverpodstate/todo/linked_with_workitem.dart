import 'package:flutter_riverpod/flutter_riverpod.dart';

final linkedWithWorkItem = StateNotifierProvider<LinkedWithWorkItemStateNotifier, bool>((ref) {
  return LinkedWithWorkItemStateNotifier();
});

class LinkedWithWorkItemStateNotifier extends StateNotifier<bool> {
  LinkedWithWorkItemStateNotifier() : super(false);

  void setgotToDetailsScreenState(bool status) {
    state = status;
  }
}
