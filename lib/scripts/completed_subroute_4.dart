import 'package:cloud_firestore/cloud_firestore.dart';

void addDataToFirestore() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // List of different parcels with a specific date (30 Nov 2023)
  List<Map<String, dynamic>> parcels = [
    {
      "name": "Olivia Lee",
      "address": "101 Maple Ave, Seattle",
      "phone": "2065552345",
      "dueTime": "2023-11-30T14:30:00Z",
      "deliveredTime": "2023-11-30T14:30:00Z",
      "receivedBy": "Noah Lee",
      "status": "unavailable"
    },
    {
      "name": "Michael Cheema",
      "address": "303 Cedar St, Boston",
      "phone": "6175557890",
      "dueTime": "2023-11-30T15:15:00Z",
      "deliveredTime": "2023-11-30T15:00:00Z",
      "receivedBy": "Ava Cheema",
      "status": "delivered"
    },
    {
      "name": "Sophia Martinez",
      "address": "404 Elm St, Dallas",
      "phone": "2145554567",
      "dueTime": "2023-11-30T16:00:00Z",
      "deliveredTime": "2023-11-30T15:45:00Z",
      "receivedBy": "Jack Martinez",
      "status": "delivered"
    },
  ];

  List<DocumentReference> documentReferences = [];

  // Writing each parcel to Firestore and storing their DocumentReference
  for (var parcelData in parcels) {
    DocumentReference docRef =
        await firestore.collection('parcels').add(parcelData);
    documentReferences.add(docRef);
  }

  print('Parcel documents written to Firestore.');

  // Combining the subroute object with the list of parcels' DocumentReferences
  Map<String, dynamic> subroute = {
    "status": "completed",
    "startTime": "2023-11-30T14:00:00Z",
    "endTime": "2023-11-30T16:00:00Z",
    "parcels": documentReferences,
  };

  // Adding the subroute to Firestore
  DocumentReference subrouteRef =
      await firestore.collection('subroutes').add(subroute);
  print('Subroute document added with ID: ${subrouteRef.id}');
}
