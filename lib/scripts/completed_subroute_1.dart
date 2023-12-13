import 'package:cloud_firestore/cloud_firestore.dart';

void addDataToFirestore() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Combine all parcel objects into an array
  List<Map<String, dynamic>> parcels = [
    {
      "name": "Elijah Kim",
      "address": "Seoul, South Korea",
      "phone": "821012345678",
      "dueTime": "2023-12-06T09:45:00Z",
      "deliveredTime": "2023-12-06T10:00:00Z",
      "receivedBy": "Hannah Kim",
      "status": "delivered"
    },
    {
      "name": "Emma Johnson",
      "address": "B-22, London",
      "phone": "07456789012",
      "dueTime": "2023-12-06T10:00:00Z",
      "deliveredTime": "2023-12-06T10:15:00Z",
      "receivedBy": "Oliver Johnson",
      "status": "unavailable"
    },
    {
      "name": "Isabella Garcia",
      "address": "Av. Paulista, Sao Paulo",
      "phone": "5511987654321",
      "dueTime": "2023-12-06T11:20:00Z",
      "deliveredTime": "2023-12-06T11:35:00Z",
      "receivedBy": "Lucas Garcia",
      "status": "delivered"
    },
    {
      "name": "Sophia Lee",
      "address": "123 Main St, New York",
      "phone": "2123456789",
      "dueTime": "2023-12-06T13:45:00Z",
      "deliveredTime": "2023-12-06T14:00:00Z",
      "receivedBy": "Emily Lee",
      "status": "unavailable"
    },
    {
      "name": "Abdullah Cheema",
      "address": "H-11/4, Islamabad",
      "phone": "03334567890",
      "dueTime": "2023-12-06T14:30:00Z",
      "deliveredTime": "2023-12-06T14:35:00Z",
      "receivedBy": "Ahmed Cheema",
      "status": "delivered"
    },
    {
      "name": "Liam Martinez",
      "address": "Calle Mayor, Madrid",
      "phone": "34987654321",
      "dueTime": "2023-12-06T16:30:00Z",
      "deliveredTime": "2023-12-06T16:45:00Z",
      "receivedBy": "Sofia Martinez",
      "status": "delivered"
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
    "status": "completed",
    "startTime": "2023-12-06T09:15:00Z",
    "endTime": "2023-12-06T16:30:00Z",
    "parcels": documentReferences,
  };

  // Add the subroute to Firestore
  DocumentReference subrouteRef =
      await firestore.collection('subroutes').add(subroute);
  print('Subroute document added with ID: ${subrouteRef.id}');
}
