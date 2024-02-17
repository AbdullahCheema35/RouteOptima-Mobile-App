import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_optima_mobile_app/gmapPages/upload_image.dart';
import 'package:route_optima_mobile_app/gmapPages/upload_sign.dart';

Widget renderProximityButton(context) {
  return Positioned(
    bottom: 16,
    right: 16,
    child: ElevatedButton(
      onPressed: () {
        _showDeliveryOptionsDialog(context);
      },
      child: const Text("Ready to Deliver?"),
    ),
  );
}

Future<void> _showDeliveryOptionsDialog(context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Delivery Options"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                // Open the camera to capture the unavailability proof
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TakePictureScreen(),
                  ),
                );
              },
              child: const Text("Capture Unavailability Proof"),
            ),
            ElevatedButton(
              onPressed: () {
                // Open the signature page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SignaturePage()),
                );
              },
              child: const Text("Take Signature from Receiver"),
            ),
          ],
        ),
      );
    },
  );
}

double calculateDistance(LatLng point1, LatLng point2) {
  double lat1 = point1.latitude;
  double lon1 = point1.longitude;
  double lat2 = point2.latitude;
  double lon2 = point2.longitude;

  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  double distKm = 12742 * asin(sqrt(a));
  return distKm * 1000; // return distance in meters
}
