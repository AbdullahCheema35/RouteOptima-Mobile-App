import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_optima_mobile_app/firebase_options.dart';
import 'package:route_optima_mobile_app/models/temp_trip.dart';
import 'package:route_optima_mobile_app/trip_containers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Route Optima Mobile App',
      home: TripsPage(),
    );
  }
}

class NoTripsAssigned extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 100,
        ),
        Container(
          width: double.infinity,
          height: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/images/calendar (6).png', // Replace this with your calendar image path
                width: 150,
                height: 150,
              ),
              Positioned(
                top: 175,
                left: 190,
                child: Image.asset(
                  'assets/images/bag.png', // Replace this with your shopping bag image path
                  width: 100,
                  height: 100,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        Column(
          children: [
            Text(
              'No Trips',
              style: GoogleFonts.getFont(
                'Roboto',
                fontSize: 28.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'You will be Notified for New Trips',
              style: GoogleFonts.getFont(
                'Roboto',
                fontSize: 18.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TripsPage extends StatefulWidget {
  @override
  _TripsPageState createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    // NoTripsAssigned(),
    AssignedTrips(),
    CompletedTripsScreen(),
  ];

  final tileIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Trips',
          style: TextStyle(fontSize: 24.0),
        ),
        titleSpacing: 0.0,
      ),
      drawer: Drawer(
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
              accountName: Text('Irfan Khan'),
              accountEmail: Text('IrfanKhan123@gmail.com'),
              currentAccountPicture: CircleAvatar(
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
              leading: Icon(Icons.bike_scooter),
              iconColor: Colors.black,
              title: const Text('View Trips', style: TextStyle(fontSize: 16.0)),
              selected: tileIndex == 0,
              onTap: () {
                // Close the drawer
                Navigator.pop(context);
                // Implement navigation logic for View Trips tile
              },
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              iconColor: Colors.black,
              title: const Text('Dashboard', style: TextStyle(fontSize: 16.0)),
              selected: tileIndex == 1,
              onTap: () {
                // Close the drawer
                Navigator.pop(context);
                // Implement navigation logic for Dashboard tile
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              iconColor: Colors.black,
              title: const Text('Settings', style: TextStyle(fontSize: 16.0)),
              selected: tileIndex == 2,
            ),
            // Add more ListTiles for other drawer options
          ],
        ),
      ),
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: <Widget>[
      //       DrawerHeader(
      //         decoration: BoxDecoration(
      //           gradient: LinearGradient(
      //             colors: [
      //               Colors.blue.shade900, // Dark blue color
      //               Colors.blue, // Light blue color
      //             ],
      //           ),
      //         ),
      //         child: const Text(
      //           'Route Optima',
      //           style: TextStyle(
      //             color: Colors.white,
      //             fontSize: 24,
      //           ),
      //         ),
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.bike_scooter),
      //         iconColor: Colors.black,
      //         title: const Text('View Trips', style: TextStyle(fontSize: 18.0)),
      //         selected: tileIndex == 0,
      //         onTap: () {
      //           // Close the drawer
      //           Navigator.pop(context);
      //           // // Add navigation logic here
      //           // Navigator.pop(context); // Close the drawer
      //           // // Navigate to View Trips screen
      //           // Navigator.push(
      //           //   context,
      //           //   MaterialPageRoute(builder: (context) => ()),
      //           // );
      //         },
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.dashboard),
      //         iconColor: Colors.black,
      //         title: const Text('Dashboard', style: TextStyle(fontSize: 18.0)),
      //         selected: tileIndex == 1,
      //         onTap: () {
      //           // // Add navigation logic here
      //           // Navigator.pop(context); // Close the drawer
      //           // // Navigate to Dashboard screen
      //           // Navigator.push(
      //           //   context,
      //           //   MaterialPageRoute(
      //           //       builder: (context) => const DashboardPage()),
      //           // );
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
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
              selectedLabelStyle: GoogleFonts.getFont(
                'Roboto',
                fontSize: 16.0,
              ),
              unselectedLabelStyle: GoogleFonts.getFont(
                'Roboto',
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

class CompletedTripsScreen extends StatelessWidget {
  final List<Trip> trips = [
    Trip(
        day: 'FRI',
        date: '10',
        month: 'Nov',
        year: '2023',
        startTime: '09:00 AM',
        endTime: '11:00 AM'),
    Trip(
        day: 'FRI',
        date: '10',
        month: 'Nov',
        year: '2023',
        startTime: '12:00 PM',
        endTime: '04:00 PM'),
    Trip(
        day: 'SAT',
        date: '11',
        month: 'Nov',
        year: '2023',
        startTime: '10:30 AM',
        endTime: '03:00 PM'),
    Trip(
        day: 'SAT',
        date: '09',
        month: 'Dec',
        year: '2023',
        startTime: '08:30 AM',
        endTime: '02:00 PM'),
    Trip(
        day: 'Mon',
        date: '11',
        month: 'Dec',
        year: '2023',
        startTime: '09:30 AM',
        endTime: '01:00 PM'),
    Trip(
        day: 'Mon',
        date: '11',
        month: 'Dec',
        year: '2023',
        startTime: '10:00 AM',
        endTime: '03:30 PM'),
  ];

  final isAssignedList = false;

  @override
  Widget build(BuildContext context) {
    String previousDate = '';
    String previousMonth = '';
    String previousYear = '';

    return ListView.builder(
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final currentTrip = trips[index];
        final diffYear = previousYear != currentTrip.year;
        final diffMonth = previousMonth != currentTrip.month;
        final sameDate = previousDate == currentTrip.date;
        previousDate = currentTrip.date;
        previousMonth = currentTrip.month;
        previousYear = currentTrip.year;

        if (diffMonth || diffYear) {
          return getNextMonthContainer(trips, index,
              isAssignedList: isAssignedList);
        } else {
          return getNormalContainer(trips, index, sameDate,
              isAssignedList: isAssignedList);
        }
      },
    );
  }
}

class AssignedTrips extends StatelessWidget {
  final List<Trip> trips = [
    Trip(
        day: 'TUE',
        date: '12',
        month: 'Dec',
        year: '2023',
        startTime: '09:00 AM',
        endTime: '12:00 PM'),
    Trip(
        day: 'SAT',
        date: '12',
        month: 'Dec',
        year: '2023',
        startTime: '01:00 PM',
        endTime: '06:00 PM'),
  ];

  @override
  Widget build(BuildContext context) {
    String previousDate = '';
    String previousMonth = '';
    String previousYear = '';

    if (trips.isEmpty) {
      return NoTripsAssigned();
    }

    return ListView.builder(
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final currentTrip = trips[index];
        final diffYear = previousYear != currentTrip.year;
        final diffMonth = previousMonth != currentTrip.month;
        final sameDate = previousDate == currentTrip.date;
        previousDate = currentTrip.date;
        previousMonth = currentTrip.month;
        previousYear = currentTrip.year;

        if (diffMonth || diffYear) {
          return getNextMonthContainer(trips, index);
        } else {
          return getNormalContainer(trips, index, sameDate);
        }
      },
    );
  }
}
