import 'package:cloud_firestore/cloud_firestore.dart';

void addDataToFirestore() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Combine all parcel objects into an array
  List<Map<String, dynamic>> parcels = [
    {
      "name": "Elijah Kim",
      "address": "Seoul, South Korea",
      "phone": "821012345678",
      "dueTime": "2023-12-13T09:00:00Z",
      "deliveredTime": "2023-12-13T09:00:00Z",
      "receivedBy": "Hannah Kim",
      "status": "delivered"
    },
    {
      "name": "Emma Johnson",
      "address": "B-22, London",
      "phone": "07456789012",
      "dueTime": "2023-12-13T10:00:00Z",
      "deliveredTime": "2023-12-13T10:00:00Z",
      "receivedBy": "Oliver Johnson",
      "status": "delivered"
    },
    {
      "name": "Isabella Garcia",
      "address": "Av. Paulista, Sao Paulo",
      "phone": "5511987654321",
      "dueTime": "2023-12-13T10:30:00Z",
      "deliveredTime": "",
      "receivedBy": "",
      "status": "pending"
    },
    {
      "name": "Sophia Lee",
      "address": "123 Main St, New York",
      "phone": "2123456789",
      "dueTime": "2023-12-13T11:15:00Z",
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
    "startTime": "2023-12-13T08:30:00Z",
    "endTime": "2023-12-13T12:00:00Z",
    "parcels": documentReferences,
  };

  // Add the subroute to Firestore
  DocumentReference subrouteRef =
      await firestore.collection('subroutes').add(subroute);
  print('Subroute document added with ID: ${subrouteRef.id}');
}
