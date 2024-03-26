import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<void> updateFirestoreParcelStatus(
    String status, Map<String, dynamic> result, String userId) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference assignments = firestore.collection('assignments');

  DocumentReference documentRef = assignments.doc(userId);

  documentRef.update({
    'status': status,
  });
}

Future<void> updateFirestorePolylineId(int newPolylineId, String userId) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference locations = firestore.collection('riderLocation');

  DocumentReference documentRef = locations.doc(userId);

  documentRef.update({
    'polylineId': newPolylineId,
  });
}

Future<void> updateFirestoreLocation(
    LatLng currentLocation, String userId) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference locations = firestore.collection('riderLocation');

  DocumentReference documentRef = locations.doc(userId);

  documentRef.update({
    'riderCoordinates': {
      'lat': currentLocation.latitude,
      'long': currentLocation.longitude,
    },
  });
}
