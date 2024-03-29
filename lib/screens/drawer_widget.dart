import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_optima_mobile_app/screens/dashboard.dart';
import 'package:route_optima_mobile_app/screens/rider_selection.dart';
import 'package:route_optima_mobile_app/screens/trips_page.dart';

Widget routeOptimaDrawerWidget(
    BuildContext context, int tileIndex, String riderName) {
  // tileIndex: 0 -> ViewTrips
  // tileIndex: 1 -> Dashboard
  // tileIndex: 2 -> Settings/RiderSelection

  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade900, // Dark blue color
                Colors.blue, // Light blue color
              ],
            ),
          ),
          accountName: Text(
            riderName,
            style: GoogleFonts.roboto(
                fontSize: 20.0), // Apply GoogleFont('Roboto')
          ),
          accountEmail: Text(
            'example@gmail.com',
            style: GoogleFonts.roboto(), // Apply GoogleFont('Roboto')
          ),
          currentAccountPicture: const CircleAvatar(
            backgroundImage: AssetImage(
                'assets/images/uifaces-popular-image (1).jpg'), // Replace with user's profile picture
          ),
          margin: EdgeInsets.zero,
        ),
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.motorcycle),
          iconColor: Colors.black,
          title: Text(
            'View Trips',
            style: GoogleFonts.roboto(
                fontSize: 16.0), // Apply GoogleFont('Roboto')
          ),
          selected: tileIndex == 0,
          onTap: () {
            Navigator.pop(context); // Close the drawer
            // Check if we're already on ViewTrips page
            if (tileIndex != 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TripsPage(),
                ),
              );
            }
          },
        ),
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.chartLine),
          iconColor: Colors.black,
          title: Text(
            'Dashboard',
            style: GoogleFonts.roboto(
                fontSize: 16.0), // Apply GoogleFont('Roboto')
          ),
          selected: tileIndex == 1,
          onTap: () {
            Navigator.pop(context); // Close the drawer
            // Navigate to Dashboard screen if we're not already on that page
            if (tileIndex != 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DashboardPage()),
              );
            }
          },
        ),
        const Divider(),
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.gear),
          iconColor: Colors.black,
          title: Text(
            'Settings',
            style: GoogleFonts.roboto(
                fontSize: 16.0), // Apply GoogleFont('Roboto')
          ),
          selected: tileIndex == 2,
          onTap: () {
            Navigator.pop(context); // Close the drawer
            // Navigate to Settings/RiderSelection screen if we're not already on that page
            if (tileIndex != 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RiderSelectionPage()),
              );
            }
          },
        ),
        // Add more ListTiles for other drawer options
      ],
    ),
  );
}
