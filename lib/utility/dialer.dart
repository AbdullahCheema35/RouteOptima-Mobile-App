import 'package:url_launcher/url_launcher.dart';

launchDialer(String phoneNumber) async {
  String url = 'tel:$phoneNumber';

  final uri = Uri.parse(url);

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch dialer: $url';
  }
}
