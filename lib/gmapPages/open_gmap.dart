import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleMapsButton extends StatelessWidget {
  const GoogleMapsButton({required this.destCoord, super.key});

  final LatLng destCoord;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      onPressed: () {
        // Open Google Maps with the source and destination coordinates
        openGoogleMaps(destCoord.latitude, destCoord.longitude);
      },
      tooltip: 'Open Google Maps',
      child: const FaIcon(
        FontAwesomeIcons.locationArrow,
      ),
    );
  }
}

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
