import 'package:firebase_auth/firebase_auth.dart';
import '../../app_constant.dart';
import '../Hive/hive_methods.dart';
import '../userModel/user_info.dart' as userinfo;

Future<String?> signinMethod({required email, required password}) async {
  String res = 'Something went wrong';
  try {
    final authResult = await userinfo.auth.signInWithEmailAndPassword(email: email, password: password);
    final uid = authResult.user?.uid;
    UserHiveMethods.addData(key: "token", data: uid);
    final userinfo.User? user = await userinfo.User.getUser(uid!);
    UserHiveMethods.addData(key: "brokerId", data: user?.brokerId);
    print("+++++++++++++++++++++++++${UserHiveMethods.getdata("brokerId")}");
    AppConst.setAccessToken(uid);
    res = "success";
    return res;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      return 'No user found for that email.';
    } else if (e.code == 'wrong-password') {
      return 'Wrong password provided for that user.';
    } else if (e.code == "email-already-in-use") {
      return "The account already exists for that email";
    } else if (e.code == "weak-password") {
      return "The password provided is too weak.";
    }
    return e.toString();
  } catch (E) {
    return E.toString();
  }
  // return null;
}
