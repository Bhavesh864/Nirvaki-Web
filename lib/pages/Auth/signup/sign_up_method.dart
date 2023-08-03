import '../../../constants/firebase/userModel/broker_info.dart';
import '../../../constants/firebase/userModel/user_info.dart';

//  Future<String> sign
Future<void> signUp({required email, required password}) async {
  try {
    await auth.createUserWithEmailAndPassword(email: email, password: password);
    final BrokerInfo item = BrokerInfo(
      brokerid: authentication.currentUser?.uid,
      role: 'broker',
      companyname: 'bhavesh',
      brokercompanynumber: 1234567890,
      brokercompanywhatsapp: 1234567890,
      brokercompanyemail: email,
      brokerlogo: "",
      brokercompanyaddress: {"Addressline1": 'pawan-puri', "Addressline2": 'nursing home', "city": "bikaner", "state": "rajasthan"},
    );
    final User items = User(
      brokerId: authentication.currentUser!.uid,
      status: 'accepted',
      userfirstname: 'bhavesh',
      userlastname: 'khatri',
      userId: authentication.currentUser!.uid,
      mobile: 1234567890,
      email: email,
      role: 'broker',
      image: '',
    );
    await User.addUser(items);
    await BrokerInfo.addBrokerInfo(item);
  } catch (er) {
    print(er.toString());
  }
}
