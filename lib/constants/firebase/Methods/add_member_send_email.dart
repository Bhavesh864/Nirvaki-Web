import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart' as user;
import 'package:yes_broker/riverpodstate/user_data.dart';
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
        url: 'https://brokr-in.web.app/#/login_screen',
        handleCodeInApp: true,
        iOSBundleId: 'com.example.yesBroker',
        androidPackageName: 'com.example.yes_broker',
        androidInstallApp: false,
        androidMinimumVersion: '8',
      ),
    );
    final token = AppConst.getAccessToken();
    final user.User items = user.User(
        brokerId: token!,
        status: 'accepted',
        userfirstname: firstname,
        whatsAppNumber: mobile,
        userlastname: lastname,
        isOnline: false,
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

Future<String> updateTeamMember(
    {required email,
    required firstname,
    required lastname,
    required mobile,
    required managerName,
    required managerid,
    required role,
    required brokerId,
    required userId,
    required fcmToken,
    required imageUrl,
    required status,
    required isOnline,
    required WidgetRef ref}) async {
  final existingUser = ref.read(userDataProvider.notifier);
  var res = "pending";
  try {
    final user.User items = user.User(
        brokerId: brokerId,
        status: status,
        userfirstname: firstname,
        whatsAppNumber: mobile,
        userlastname: lastname,
        isOnline: isOnline,
        userId: userId,
        managerName: managerName,
        managerid: managerid,
        mobile: mobile,
        email: email,
        role: role,
        fcmToken: fcmToken,
        image: imageUrl);
    await user.User.updateUser(items).then((value) => {
          res = "success",
          if (ref.read(userDataProvider)?.userId == userId)
            {
              existingUser.storeUserData(items),
            }
        });
    return res;
  } catch (e) {
    print(e.toString());
    return e.toString();
  }
}
