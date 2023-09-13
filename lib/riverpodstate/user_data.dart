import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';

final userDataProvider = StateNotifierProvider<UserDataState, User>((ref) {
  return UserDataState();
});

class UserDataState extends StateNotifier<User> {
  UserDataState()
      : super(
          User(
            brokerId: "brokerId",
            status: "status",
            isOnline: false,
            userfirstname: "userfirstname",
            userlastname: "userlastname",
            userId: "userId",
            mobile: "mobile",
            fcmToken: "fcmToken",
            email: "email",
            role: "role",
            whatsAppNumber: "whatsAppNumber",
            image: "image",
          ),
        );

  void storeUserData(User userData) {
    state = userData;
  }

  User getUser() {
    return state;
  }

  void resetState() {
    state = User(
      isOnline: false,
      brokerId: "",
      status: "",
      userfirstname: "",
      userlastname: "",
      userId: "",
      mobile: "",
      fcmToken: "",
      email: "",
      role: "",
      whatsAppNumber: "",
      image: "",
    );
  }
}
