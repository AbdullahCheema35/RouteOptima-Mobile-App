import 'package:cloud_firestore/cloud_firestore.dart';

void addDataToFirestore() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // List of different parcels with a specific date (30 Nov 2023)
  List<Map<String, dynamic>> parcels = [
    {
      "name": "Adam Smith",
      "address": "456 Oak St, Los Angeles",
      "phone": "2135559876",
      "dueTime": "2023-11-30T09:15:00Z",
      "deliveredTime": "2023-11-30T09:15:00Z",
      "receivedBy": "Sarah Smith",
      "status": "unavailable"
    },
    {
      "name": "Eva Johnson",
      "address": "789 Elm St, Chicago",
      "phone": "3125556543",
      "dueTime": "2023-11-30T10:15:00Z",
      "deliveredTime": "2023-11-30T10:30:00Z",
      "receivedBy": "James Johnson",
      "status": "delivered"
    },
    {
      "name": "David Garcia",
      "address": "101 Pine St, San Francisco",
      "phone": "4155553210",
      "dueTime": "2023-11-30T11:30:00Z",
      "deliveredTime": "2023-11-30T11:45:00Z",
      "receivedBy": "Emma Garcia",
      "status": "delivered"
    },
    {
      "name": "Sophie Lee",
      "address": "202 Maple Ave, Seattle",
      "phone": "2065557890",
      "dueTime": "2023-11-30T12:45:00Z",
      "deliveredTime": "2023-11-30T13:00:00Z",
      "receivedBy": "Noah Lee",
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
    "startTime": "2023-11-30T08:45:00Z",
    "endTime": "2023-11-30T13:30:00Z",
    "parcels": documentReferences,
  };

  // Adding the subroute to Firestore
  DocumentReference subrouteRef =
      await firestore.collection('subroutes').add(subroute);
  print('Subroute document added with ID: ${subrouteRef.id}');
}
