import 'package:cloud_firestore/cloud_firestore.dart';

void addDataToFirestore() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Combine all parcel objects into an array
  List<Map<String, dynamic>> parcels = [
    {
      "name": "Sophia Lee",
      "address": "123 Main St, New York",
      "phone": "2123456789",
      "dueTime": "2023-12-13T13:30:00Z",
      "deliveredTime": "",
      "receivedBy": "",
      "status": "pending"
    },
    {
      "name": "Abdullah Cheema",
      "address": "H-11/4, Islamabad",
      "phone": "03334567890",
      "dueTime": "2023-12-13T14:30:00Z",
      "deliveredTime": "",
      "receivedBy": "",
      "status": "pending"
    },
    {
      "name": "Liam Martinez",
      "address": "Calle Mayor, Madrid",
      "phone": "34987654321",
      "dueTime": "2023-12-13T15:00:00Z",
      "deliveredTime": "",
      "receivedBy": "",
      "status": "pending"
    },
  ];

  List<DocumentReference> documentReferences = [];

  // Write each parcel to Firestore and store their DocumentReference
  for (var parcelData in parcels) {
    DocumentReference docRef =
        await firestore.collection('parcels').add(parcelData);
    documentReferences.add(docRef);
  }

  print('Parcel documents written to Firestore.');

  // Combine the subroute object with the list of parcels' DocumentReferences
  Map<String, dynamic> subroute = {
    "status": "assigned",
    "startTime": "2023-12-13T13:00:00Z",
    "endTime": "2023-12-13T15:00:00Z",
    "parcels": documentReferences,
  };

  // Add the subroute to Firestore
  DocumentReference subrouteRef =
      await firestore.collection('subroutes').add(subroute);
  print('Subroute document added with ID: ${subrouteRef.id}');
}
