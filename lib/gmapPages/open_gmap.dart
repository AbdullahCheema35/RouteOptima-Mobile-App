import 'package:url_launcher/url_launcher.dart';

// Function to open Google Maps with specific coordinates
Future<void> openGoogleMaps(double destLat, double destLong) async {
  String url = 'google.navigation:q=$destLat,$destLong';

  // String url =
  //     'https://www.google.com/maps/dir/?api=1&origin=$sourceLatitude,$sourceLongitude&destination=$destLatitude,$destLongitude&d=l';

  Uri encodedUrl = Uri.parse(url);

  // Check if the URL/App can be launched
  if (await canLaunchUrl(encodedUrl)) {
    // Launch the URL/App
    await launchUrl(encodedUrl);
  } else {
    throw 'Could not launch $url';
  }
}
