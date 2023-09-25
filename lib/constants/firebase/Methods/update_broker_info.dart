import '../userModel/broker_info.dart';

Future<String> updateBrokerInfo({
  required brokerId,
  required role,
  required companyName,
  required mobile,
  required whatsapp,
  required email,
  required image,
  required companyAddress,
}) async {
  var res = "pending";
  try {
    final BrokerInfo broker = BrokerInfo(
        brokerid: brokerId,
        role: role,
        companyname: companyName,
        brokercompanynumber: mobile,
        brokercompanywhatsapp: whatsapp,
        brokercompanyemail: email,
        brokerlogo: image,
        brokercompanyaddress: companyAddress);
    BrokerInfo.updateBrokerInfo(broker).then((value) => {res = "success"});
    return res;
  } catch (e) {
    return e.toString();
  }
}
