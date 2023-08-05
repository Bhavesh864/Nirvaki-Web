import '../../../constants/firebase/userModel/broker_info.dart';
import '../../../constants/firebase/userModel/user_info.dart';

Future<String> signUpMethod({required state}) async {
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
  final companyAddress = getDataById(state, 10);
  final companyState = getDataById(state, 11);
  final companyCity = getDataById(state, 12);
  final registerAs = getDataById(state, 13);
  final companyLogo = getDataById(state, 14);

  try {
    await auth.createUserWithEmailAndPassword(email: email, password: password);
    final BrokerInfo item = BrokerInfo(
      brokerid: authentication.currentUser?.uid,
      role: registerAs,
      companyname: companyName,
      brokercompanynumber: companyMobileNumber,
      brokercompanywhatsapp: companyWhatsAppMobileNumber ?? companyMobileNumber,
      brokercompanyemail: email,
      brokerlogo: companyLogo,
      brokercompanyaddress: {"address": companyAddress, "city": companyCity, "state": companyState},
    );
    final User items = User(
        brokerId: authentication.currentUser!.uid,
        status: 'accepted',
        userfirstname: userFirstName,
        whatsAppNumber: userWhatsAppNumber ?? userMobileNumber,
        userlastname: userLastName,
        userId: authentication.currentUser!.uid,
        mobile: userMobileNumber,
        email: email,
        role: registerAs,
        image: "");
    await User.addUser(items);
    await BrokerInfo.addBrokerInfo(item);
    res = "success";
    return res;
  } catch (er) {
    // print(er);
    return er.toString();
  }
}
