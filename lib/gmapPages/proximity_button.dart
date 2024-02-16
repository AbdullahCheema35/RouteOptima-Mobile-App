import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Widget renderProximityButton() {
  return Positioned(
    bottom: 16,
    right: 16,
    child: ElevatedButton(
      onPressed: () {
        // Handle the "Ready to Deliver?" button press
        // Add your logic here
      },
      child: Text("Ready to Deliver?"),
    ),
  );
}

// double calculateDistance(LatLng point1, LatLng point2) {
//   const double earthRadius = 6371000; // meters

//   double lat1 = radians(point1.latitude);
//   double lon1 = radians(point1.longitude);
//   double lat2 = radians(point2.latitude);
//   double lon2 = radians(point2.longitude);

//   double dLat = lat2 - lat1;
//   double dLon = lon2 - lon1;

//   double a = sin(dLat / 2) * sin(dLat / 2) +
//       cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
//   double c = 2 * atan2(sqrt(a), sqrt(1 - a));

//   double distance = earthRadius * c;

//   return distance;
// }

// double radians(double degrees) {
//   return degrees * pi / 180;
// }

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
