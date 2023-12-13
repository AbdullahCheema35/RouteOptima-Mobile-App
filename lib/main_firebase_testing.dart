import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:route_optima_mobile_app/scripts/assigned_subroute.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  addDataToFirestore();

  // // Access Firestore collection 'subroute'
  // CollectionReference subrouteCollection =
  //     FirebaseFirestore.instance.collection('subroute');

  // // Get all documents from the 'subroute' collection
  // QuerySnapshot subrouteSnapshot = await subrouteCollection.get();

  // // Loop through each document in the collection
  // subrouteSnapshot.docs.forEach((DocumentSnapshot document) async {
  //   // Retrieve data from each document
  //   Map<String, dynamic> data = document.data() as Map<String, dynamic>;

  //   // Extracting individual fields and printing them to the console
  //   String endTime =
  //       data['endTime'] ?? ''; // Replace with the correct field name
  //   String startTime =
  //       data['startTime'] ?? ''; // Replace with the correct field name
  //   DocumentReference riderRef = data['riderRef']
  //       as DocumentReference; // Replace with the correct field name
  //   List<DocumentReference> parcelsRefs = List<DocumentReference>.from(
  //       data['parcels'] ?? []); // Replace with the correct field name

  //   // Get the fields of the rider document
  //   final riderData = await riderRef.get();
  //   final riderName = riderData.get('name');
  //   final riderAddress = riderData.get('address');

  //   print('EndTime: $endTime');
  //   print('StartTime: $startTime');
  //   print('RiderName: $riderName');
  //   print('RiderAddress: $riderAddress');
  //   // print('RiderRef: ${riderRef.get().}'); // Print the ID of the rider reference
  //   print('Parcels:');
  //   parcelsRefs.forEach((parcelRef) async {
  //     final parcelData = await parcelRef.get();

  //     final arrivalTime = parcelData.get('arrival_time');
  //     final dueTime = parcelData.get('due_time');
  //     final weight = parcelData.get('weight');

  //     print('- ParcelRef: ${parcelRef.id}');
  //     print('  ArrivalTime: $arrivalTime');
  //     print('  DueTime: $dueTime');
  //     print('  Weight: $weight');
  //   });

  //   // Print a separator for each document
  //   print('-----------------------------\n');
  // });
}
