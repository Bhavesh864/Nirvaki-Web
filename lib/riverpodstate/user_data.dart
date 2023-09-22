import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';

final userDataProvider = StateNotifierProvider<UserDataState, User?>((ref) {
  return UserDataState();
});

class UserDataState extends StateNotifier<User?> {
  UserDataState() : super(null);

  void storeUserData(User userData) {
    state = userData;
  }

  void resetState() {
    state = null;
  }
}
