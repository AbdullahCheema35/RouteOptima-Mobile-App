import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_optima_mobile_app/screens/emergency_request_dialog.dart';
import 'package:route_optima_mobile_app/services/assignment_stream_provider.dart';

Future<Map<String, dynamic>> updateFirestoreParcelStatus(
  String status,
  Map<String, dynamic> result,
  String userId,
  int parcelId,
  WidgetRef ref, {
  String receiverName = "null",
}) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference assignments = firestore.collection('assignments');

  DocumentReference documentRef = assignments.doc(userId);

  final assignmentsData = (await ref.read(assignmentStreamProvider.future))
      .data() as Map<String, dynamic>;

  final parcelToUpdate = assignmentsData['parcels'][parcelId];

  parcelToUpdate['status'] = status;
  parcelToUpdate['actualStartTime'] = result['actualStartTime'];
  parcelToUpdate['actualEndTime'] = result['actualEndTime'];
  parcelToUpdate['deliveryProofLink'] = result['deliveryProofLink'];
  parcelToUpdate['receiverName'] = receiverName;

  // Update other fields as well
  assignmentsData['parcelsRemaining']--;

  Map<String, dynamic> toUploadObject = {
    'parcels': assignmentsData['parcels'],
    'parcelsRemaining': assignmentsData['parcelsRemaining'],
  };

  if (status == 'delivered') {
    assignmentsData['parcelsDelivered']++;
    toUploadObject['parcelsDelivered'] = assignmentsData['parcelsDelivered'];
  } else if (status == 'unavailable') {
    assignmentsData['unableToDeliver']++;
    toUploadObject['unableToDeliver'] = assignmentsData['unableToDeliver'];
  }

  // Update the database
  documentRef.update(toUploadObject);

  return assignmentsData;
}

Future<void> updateFirestoreAssignmentStatus(
    String status, String userId, Map<String, dynamic> assignmentsData) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference assignments = firestore.collection('assignments');

  DocumentReference documentRef = assignments.doc(userId);

  final totalParcels = assignmentsData['parcels'].length;

  final actualStartTime = assignmentsData['parcels'][0]['actualStartTime'];
  final actualEndTime =
      assignmentsData['parcels'][totalParcels - 1]['actualEndTime'];

  print("Actual Start Time: $actualStartTime");
  print("Actual End Time: $actualEndTime");
  print("Total Parcels - 1: ${totalParcels - 1}");

  Map<String, dynamic> toUploadObject = {
    'status': status,
    'actualStartTime': actualStartTime,
    'actualEndTime': actualEndTime,
  };

  // Update the database
  documentRef.update(toUploadObject);
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

Future<void> uploadEmergencyRequest(
    String userId, EmergencyRequestType request, WidgetRef ref) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference assignments = firestore.collection('assignments');
  DocumentReference assignmentDocRef = assignments.doc(userId);
  final assignmentsFuture = ref.read(assignmentStreamProvider.future);

  CollectionReference emergencyRequests =
      firestore.collection('emergencyRequest');

  request.timestamp = DateTime.now();

  // Add emergency report data to Firestore in 'emergencyRequests' collection
  emergencyRequests.add(request.toJson());

  // Now back to the assignment document
  final assignmentsData =
      (await assignmentsFuture).data() as Map<String, dynamic>;

  // Update the assignment document
  assignmentDocRef.update({
    'alertsGenerated': assignmentsData['alertsGenerated'] + 1,
  });
}
