import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/firebase/userModel/user_info.dart';

class AddMemberScreenStateNotifier extends StateNotifier<bool> {
  AddMemberScreenStateNotifier() : super(false);

  void setAddMemberScreenState(bool isAddMemberScreen) {
    state = isAddMemberScreen;
  }
}

final editAddMemberState = StateNotifierProvider<AddMemberEditState, bool>((ref) {
  return AddMemberEditState();
});

class AddMemberEditState extends StateNotifier<bool> {
  AddMemberEditState() : super(false);

  void isEdit(bool isEdit) {
    state = isEdit;
  }
}

final userForEditScreen = StateNotifierProvider<UserIdForEditScreen, User?>((ref) {
  return UserIdForEditScreen();
});

class UserIdForEditScreen extends StateNotifier<User?> {
  UserIdForEditScreen() : super(null);

  void setUserForEdit(User? user) {
    state = user;
  }
}
