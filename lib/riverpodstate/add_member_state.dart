import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddMemberScreenStateNotifier extends StateNotifier<bool> {
  AddMemberScreenStateNotifier() : super(false);

  void setAddMemberScreenState(bool isAddMemberScreen) {
    state = isAddMemberScreen;
  }
}
