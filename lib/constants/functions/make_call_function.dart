import 'package:url_launcher/url_launcher.dart';
import 'package:yes_broker/Customs/snackbar.dart';

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}

Future<void> launchWhatsapp(whatsapp, buildContext) async {
  var url = Uri.parse("https://wa.me/$whatsapp?text=${Uri.parse('Hello')}");
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    customSnackBar(context: buildContext, text: "WhatsApp is not installed on the device");
  }
}
