import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_optima_mobile_app/screens/assigned_trips.dart';
import 'package:route_optima_mobile_app/screens/completed_trips.dart';
import 'package:route_optima_mobile_app/screens/drawer_widget.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  TripsPageState createState() => TripsPageState();
}

class TripsPageState extends State<TripsPage> {
  int _currentIndex = 0;
  final _drawerTileIndex = 0;

  final List<Widget> _tabs = [
    const AssignedTrips(),
    const CompletedTripsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'View Trips',
          style:
              GoogleFonts.roboto(fontSize: 24.0, fontWeight: FontWeight.w600),
        ),
      ),
      drawer: routeOptimaDrawerWidget(context, _drawerTileIndex),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
        child: _tabs[_currentIndex],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Styled Divider
          Container(
            height: 1.0,
            decoration: BoxDecoration(
              color: Colors.grey[300], // Adjust color as needed
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
          // Padding for bottom navigation bar
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 16.0),
            child: BottomNavigationBar(
              elevation: 0.0,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.grey,
              backgroundColor: Colors.white,
              selectedLabelStyle: GoogleFonts.roboto(
                fontSize: 16.0,
              ),
              unselectedLabelStyle: GoogleFonts.roboto(
                fontSize: 14.0,
              ),
              currentIndex: _currentIndex,
              onTap: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.clipboardList),
                  label: 'Current Trips',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.listCheck),
                  label: 'Completed Trips',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
