import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:route_optima_mobile_app/models/parcel.dart';
import 'package:route_optima_mobile_app/utility/build_parcel_container.dart';

class CompletedParceslList extends StatelessWidget {
  const CompletedParceslList({required this.parcelRefs, super.key});
  final List<DocumentReference> parcelRefs;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Parcel>>(
      future: fetchParcelsFromFirestore(parcelRefs),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            // Bigger and stylish font for the message
            child: Text(
              'No Parcels Found :)',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else {
          // Display the fetched parcel data here
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: snapshot.data!.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return const SizedBox(height: 20.0);
                }
                return buildParcelContainer(
                  context,
                  snapshot.data![index - 1],
                  index - 1,
                  snapshot.data!,
                );
              },
            ),
          );
        }
      },
    );
  }
}

Future<List<Parcel>> fetchParcelsFromFirestore(
    List<DocumentReference> references) async {
  List<Parcel> parcels = [];

  try {
    // Fetch each parcel document using its reference and add data to the list
    for (DocumentReference reference in references) {
      DocumentSnapshot snapshot = await reference.get();
      if (snapshot.exists) {
        final snapshotData = snapshot.data() as Map<String, dynamic>;
        final parcel = Parcel.fromFirestore(snapshotData);
        parcels.add(parcel);
      }
    }
    return parcels;
  } catch (e) {
    // Handle any errors that might occur during the fetching process
    print('Error fetching parcels: $e');
    return []; // Return an empty list if an error occurs
  }
}
