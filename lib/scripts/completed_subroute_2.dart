import 'package:cloud_firestore/cloud_firestore.dart';

void addDataToFirestore() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // List of different parcels (intelligently generated)
  List<Map<String, dynamic>> parcels = [
    {
      "name": "John Smith",
      "address": "456 Oak St, Los Angeles",
      "phone": "2135559876",
      "dueTime": "2023-12-07T09:15:00Z",
      "deliveredTime": "2023-12-07T09:30:00Z",
      "receivedBy": "Sarah Smith",
      "status": "delivered"
    },
    {
      "name": "Emily Watson",
      "address": "789 Elm St, Chicago",
      "phone": "3125556543",
      "dueTime": "2023-12-07T10:30:00Z",
      "deliveredTime": "2023-12-07T10:45:00Z",
      "receivedBy": "James Watson",
      "status": "delivered"
    },
    {
      "name": "Michael Brown",
      "address": "101 Pine St, San Francisco",
      "phone": "4155553210",
      "dueTime": "2023-12-07T11:45:00Z",
      "deliveredTime": "2023-12-07T12:00:00Z",
      "receivedBy": "Emma Brown",
      "status": "delivered"
    },
    {
      "name": "Olivia Wilson",
      "address": "202 Maple Ave, Seattle",
      "phone": "2065557890",
      "dueTime": "2023-12-07T13:00:00Z",
      "deliveredTime": "2023-12-07T13:15:00Z",
      "receivedBy": "Noah Wilson",
      "status": "unavailable"
    },
    {
      "name": "Aiden Taylor",
      "address": "303 Cedar St, Boston",
      "phone": "6175554567",
      "dueTime": "2023-12-07T14:15:00Z",
      "deliveredTime": "2023-12-07T14:30:00Z",
      "receivedBy": "Ava Taylor",
      "status": "unavailable"
    },
    {
      "name": "Sophie Brown",
      "address": "404 Elm St, Dallas",
      "phone": "2145552345",
      "dueTime": "2023-12-07T15:30:00Z",
      "deliveredTime": "2023-12-07T15:45:00Z",
      "receivedBy": "Jack Brown",
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
    "startTime": "2023-12-07T09:00:00Z",
    "endTime": "2023-12-07T15:30:00Z",
    "parcels": documentReferences,
  };

  // Adding the subroute to Firestore
  DocumentReference subrouteRef =
      await firestore.collection('subroutes').add(subroute);
  print('Subroute document added with ID: ${subrouteRef.id}');
}
