import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_optima_mobile_app/gmapPages/map_page.dart';
import 'package:route_optima_mobile_app/services/location_stream_provider.dart';

class NavigationPage extends ConsumerWidget {
  const NavigationPage({required this.userId, super.key});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      body: FutureBuilder<Map<String, dynamic>>(
        future: getDataFromFirebase(ref),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While data is loading, display a loading indicator
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there's an error, display an error message
            return Text('Error: ${snapshot.error}');
          } else {
            // Once the data is loaded, display the map page
            return MapPage(
              userId: userId,
              riderLocationData: snapshot.data!,
            );
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> getDataFromFirebase(WidgetRef ref) async {
    final locationDocSnapshot = await ref.read(locationStreamProvider.future);

    return locationDocSnapshot.data() as Map<String, dynamic>;
  }
}
