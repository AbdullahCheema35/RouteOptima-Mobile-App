import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:route_optima_mobile_app/gmapPages/map_page.dart';

class NavigationPage extends StatelessWidget {
  const NavigationPage({required this.userId, super.key});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
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
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<dynamic>>(
        future: getDataFromFirebase(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While data is loading, display a loading indicator
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there's an error, display an error message
            return Text('Error: ${snapshot.error}');
          } else {
            // Data is successfully loaded, pass it to MapPage
            final Map<String, dynamic> locationData =
                snapshot.data![0].data() as Map<String, dynamic>;
            final Map<String, dynamic> assignmentsData =
                snapshot.data![1].data() as Map<String, dynamic>;
            return MapPage(
              userId: userId,
              riderLocationData: locationData,
              assignmentsData: assignmentsData,
            );
          }
        },
      ),
    );
  }

  Future<List<dynamic>> getDataFromFirebase(String userId) async {
    final locationDocSnapshot = FirebaseFirestore.instance
        .collection('riderLocation')
        .doc(userId)
        .get();
    final assignmentDocSnapshot =
        FirebaseFirestore.instance.collection('assignments').doc(userId).get();

    // await on both Futures to get the data
    return await Future.wait([locationDocSnapshot, assignmentDocSnapshot]);
  }
}
