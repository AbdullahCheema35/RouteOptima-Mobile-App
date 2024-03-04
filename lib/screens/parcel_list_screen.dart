import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:route_optima_mobile_app/conversion/time.dart';
import 'package:route_optima_mobile_app/models/parcel.dart';
import 'package:route_optima_mobile_app/screens/parcel_details_screen.dart';
import 'package:route_optima_mobile_app/screens/navigation.dart';
import 'package:route_optima_mobile_app/services/line_painter.dart';

class ParcelListPage extends StatelessWidget {
  // // Example list of parcels
  // final List<Map<String, dynamic>> parcels = [
  //   {
  //     'delivered': true,
  //     'time': '11:30 AM',
  //   },
  //   {
  //     'delivered': false,
  //     'time': '12:00 PM',
  //   },
  //   {
  //     'delivered': true,
  //     'time': '01:00 PM',
  //   },
  //   {
  //     'delivered': false,
  //     'time': '02:00 PM',
  //   },
  //   // Add more parcels as needed
  // ];

  final List<DocumentReference> parcelRefs;

  const ParcelListPage({required this.parcelRefs, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leadingWidth: 100.0,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                // Implement the back functionality here
                Navigator.pop(context);
              },
              icon: const FaIcon(
                FontAwesomeIcons.chevronLeft,
                color: Colors.black,
              ),
            ),
            Text(
              'Back',
              style: GoogleFonts.roboto(
                fontSize: 20.0,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Parcel>>(
        future: fetchParcelsFromFirestore(parcelRefs),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No parcels found.'),
            );
          } else {
            // Display the fetched parcel data here
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return buildParcelContainer(
                      context, snapshot.data![index], index, snapshot.data!);
                },
              ),
            );
          }
        },
      ),

      // Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: ListView.builder(
      //     itemCount: parcels.length,
      //     itemBuilder: (BuildContext context, int index) {
      //       return buildParcelContainer(context, parcels[index], index);
      //     },
      //   ),
      // ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () {
          // Implement functionality for Start Trip button
          // Show Parcel Details
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NavigationPage()),
          );
        },
        label: Text(
          'Start Trip',
          style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
        ),
        // FontAwesome Icon replaced here
        icon: const FaIcon(FontAwesomeIcons.route),
        backgroundColor: Colors.black, // Customize the background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildParcelContainer(
      BuildContext context, Parcel parcel, int idx, List<Parcel> parcels) {
    return Container(
      height: 100, // Fixed height for each parcel container
      width: double.infinity, // Occupy all screen width
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Row(
        children: [
          // Left column with circles and lines
          Container(
            width: 40.0, // Width for the left column
            child: CustomPaint(
              painter: LinePainter(
                  length: parcels.length,
                  index: parcel.status == 'pending' ? -1 : idx),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 20.0,
                    height: 20.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: parcel.status == 'delivered'
                          ? Colors.green
                          : parcel.status == 'unavailable'
                              ? Colors.red
                              : Colors.black,
                    ),
                    child: Center(
                      child: FaIcon(
                        parcel.status == 'delivered'
                            ? FontAwesomeIcons.check
                            : parcel.status == 'unavailable'
                                ? FontAwesomeIcons.xmark
                                : FontAwesomeIcons.solidCircle,
                        color: Colors.white,
                        size: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 4.0), // Add spacing between the columns
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                extractTime(parcel.dueTime),
                style: TextStyle(
                    fontFamily: 'Roboto'), // Apply GoogleFont('Roboto')
              ),
            ],
          ),

          const SizedBox(width: 12.0), // Add spacing between the columns

          // Right column with parcel details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  parcel.name, // Replace with actual receiver name
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto', // Apply GoogleFont('Roboto')
                  ),
                ),
                SizedBox(height: 4.0),
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.bagShopping,
                      size: 18.0,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 4.0),
                    Text(
                      '1 item',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          color:
                              Colors.grey[600]), // Apply GoogleFont('Roboto')
                    ),
                  ],
                ),
                SizedBox(height: 4.0),
                Text(
                  parcel.address,
                  style: TextStyle(
                      fontFamily: 'Roboto'), // Apply GoogleFont('Roboto')
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  // Show Parcel Details
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ParcelDetailsScreen(parcel),
                    ),
                  );
                },
                icon: const FaIcon(
                  FontAwesomeIcons.chevronRight,
                ),
                color: Colors.black,
              ),
            ],
          ),
        ],
      ),
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
