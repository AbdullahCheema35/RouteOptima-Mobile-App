import 'package:url_launcher/url_launcher.dart';

launchSMS(String phoneNumber) async {
  String url = 'sms:$phoneNumber';
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch sms: $url';
  }
}
