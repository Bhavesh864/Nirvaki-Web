import '../../app_constant.dart';
import '../Hive/hive_methods.dart';
import '../userModel/broker_info.dart';
import '../userModel/user_info.dart';

Future<String> signUpMethod({required state}) async {
  print("signup method");
  String res = 'Something went wrong';
  final email = getDataById(state, 1);
  final password = getDataById(state, 2);
  final userFirstName = getDataById(state, 3);
  final userLastName = getDataById(state, 4);
  final userMobileNumber = getDataById(state, 5);
  final userWhatsAppNumber = getDataById(state, 6);
  final companyName = getDataById(state, 7);
  final companyMobileNumber = getDataById(state, 8);
  final companyWhatsAppMobileNumber = getDataById(state, 9);
  final companyAddress1 = getDataById(state, 10);
  final companyAddress2 = getDataById(state, 15);
  final companyState = getDataById(state, 11);
  final companyCity = getDataById(state, 12);
  final registerAs = getDataById(state, 13);
  final companyLogo = getDataById(state, 14);

  try {
    final authResult = await auth.createUserWithEmailAndPassword(email: email, password: password);
    final BrokerInfo item = BrokerInfo(
      brokerid: authentication.currentUser?.uid,
      role: registerAs,
      companyname: companyName,
      brokercompanynumber: companyMobileNumber,
      brokercompanywhatsapp: companyWhatsAppMobileNumber ?? companyMobileNumber,
      brokercompanyemail: email,
      brokerlogo: companyLogo ?? "",
      brokercompanyaddress: {
        "Addressline1": companyAddress1 ?? "",
        "Addressline2": companyAddress2 ?? "",
        "city": companyCity ?? "",
        "state": companyState ?? "",
      },
    );
    final User items = User(
      brokerId: authentication.currentUser!.uid,
      status: 'accepted',
      userfirstname: userFirstName,
      isOnline: false,
      whatsAppNumber: userWhatsAppNumber ?? userMobileNumber,
      userlastname: userLastName,
      userId: authentication.currentUser!.uid,
      mobile: userMobileNumber,
      email: email,
      role: registerAs,
      fcmToken: null,
      image: "",
    );

    await User.addUser(items);
    await BrokerInfo.addBrokerInfo(item);
    final uid = authResult.user!.uid;
    UserHiveMethods.addData(key: "token", data: uid);
    AppConst.setAccessToken(uid);
    await authResult.user?.sendEmailVerification();
    res = "success";
    return res;
  } catch (er) {
    // print(er);
    return er.toString();
  }
}
