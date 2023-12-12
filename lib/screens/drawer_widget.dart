import 'package:flutter/material.dart';
import 'package:route_optima_mobile_app/screens/dashboard.dart';
import 'package:route_optima_mobile_app/screens/trips_page.dart';
import 'package:route_optima_mobile_app/test_main.dart';

Widget routeOptimaDrawerWidget(BuildContext context, int tileIndex) {
  // tileIndex: 0 -> ViewTrips
  // tileIndex: 1 -> Dashboard

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
          accountName: const Text('Irfan Khan'),
          accountEmail: const Text('IrfanKhan123@gmail.com'),
          currentAccountPicture: const CircleAvatar(
            backgroundImage: AssetImage(
                'assets/images/uifaces-popular-image (1).jpg'), // Replace with user's profile picture
          ),
          // otherAccountsPictures: [
          //   CircleAvatar(
          //     child: Text('JD'),
          //     backgroundColor: Colors.white,
          //   ),
          //   // Add more profile pictures if needed
          // ],
          margin: EdgeInsets.zero,
        ),
        ListTile(
          leading: const Icon(Icons.bike_scooter),
          iconColor: Colors.black,
          title: const Text('View Trips', style: TextStyle(fontSize: 16.0)),
          selected: tileIndex == 0,
          onTap: () {
            // Close the drawer
            Navigator.pop(context);
            // Check if we're already on ViewTrips page
            if (tileIndex != 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TripsPage()),
              );
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.dashboard),
          iconColor: Colors.black,
          title: const Text('Dashboard', style: TextStyle(fontSize: 16.0)),
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
          leading: const Icon(Icons.settings),
          iconColor: Colors.black,
          title: const Text('Settings', style: TextStyle(fontSize: 16.0)),
          selected: tileIndex == 2,
        ),
        // Add more ListTiles for other drawer options
      ],
    ),
  );
}
