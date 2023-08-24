import 'package:firebase_auth/firebase_auth.dart';

import 'package:yes_broker/constants/firebase/userModel/user_info.dart' as user;

import '../../app_constant.dart';

Future<String> sendInvitationEmail({
  required email,
  required firstname,
  required lastname,
  required mobile,
  required managerName,
  required managerid,
  required role,
}) async {
  var res = "something went wrong";
  try {
    final authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: "brokr123",
    );
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: email,
      actionCodeSettings: ActionCodeSettings(
        url: 'http://localhost:50281/#/home_screen', // Replace with your dynamic link URL
        handleCodeInApp: true,
        iOSBundleId: 'com.example.yesBroker', // Replace with your iOS bundle ID
        androidPackageName: 'com.example.yes_broker', // Replace with your Android package name
        androidInstallApp: true,
        androidMinimumVersion: '10',
      ),
    );
    final token = AppConst.getAccessToken();
    final user.User items = user.User(
        brokerId: token!,
        status: 'accepted',
        userfirstname: firstname,
        whatsAppNumber: mobile,
        userlastname: lastname,
        userId: authResult.user!.uid,
        managerName: managerName,
        managerid: managerid,
        mobile: mobile,
        email: email,
        role: role,
        fcmToken: null,
        image: "");
    await user.User.addUser(items);
    print('Invitation email sent successfully.');
    res = "success";
    return res;
  } catch (e) {
    print('Failed to send invitation email: $e');
    return e.toString();
  }
}
