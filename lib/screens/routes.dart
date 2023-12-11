import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:route_optima_mobile_app/models/trip.dart';
import 'package:route_optima_mobile_app/screens/dashboard.dart';
import 'package:route_optima_mobile_app/screens/subroutes_screen.dart';
import 'package:route_optima_mobile_app/services/firestore_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trips = ref.watch(tripsNotifierProvider);

    return Scaffold(
      // Also show the number of trips (length of the list)
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        centerTitle: true,
        title: const Text('Current Assigned Trips'),
      ),
      // body: ListView.builder(
      //   itemCount: trips.length,
      //   itemBuilder: (context, index) {
      //     final trip = trips[index];
      //     return ListTile(
      //       title: Text('Departure Time: ${trip.departureTime}'),
      //       subtitle: Text('Number of Deliveries: ${trip.subroutes.length}'),
      //       trailing: Text('Finish Time: ${trip.arrivalTime}'),
      //       onTap: () {
      //         // Navigate to the Route Details Screen
      //         Navigator.of(context).push(
      //           MaterialPageRoute(
      //             builder: (BuildContext context) {
      //               return SubRoutesScreen(trip: trip);
      //             },
      //           ),
      //         );
      //       },
      //     );
      //   },
      // ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue.shade900,
              ),
              child: const Text(
                'Route Optima',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('View Trips'),
              onTap: () {
                // Close the drawer
                Navigator.pop(context);
                // // Add navigation logic here
                // Navigator.pop(context); // Close the drawer
                // // Navigate to View Trips screen
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => ()),
                // );
              },
            ),
            ListTile(
              title: const Text('Dashboard'),
              onTap: () {
                // Add navigation logic here
                Navigator.pop(context); // Close the drawer
                // Navigate to Dashboard screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DashboardPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // subRoutesBodyHeading(trip),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 24),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: trips.map((trip) {
                  return singleTripContainer(trip, context);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildTripsBody(List<Trip> trips, BuildContext context) {
  return SingleChildScrollView(
    child: Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // subRoutesBodyHeading(trip),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 24),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: trips.map((trip) {
              return Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
                child: InkWell(
                  onTap: () {
                    // Navigate to the Route Details Screen
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return SubRoutesScreen(trip: trip);
                        },
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.black26,
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Trip Id: ${trip.routeId}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 4, 0, 0),
                                  child: Text(
                                    'Total Deliveries: ${trip.subroutes.length}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 0),
                                  child: IntrinsicWidth(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            trip.assignedDate
                                                .toString()
                                                .substring(0, 10),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 12),
                                  child: Text(
                                    // Extract just the time from the DateTime object
                                    'Departure: ${trip.departureTime}',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade400,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 12, 0, 0),
                                  child: Container(
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 12, 0),
                                        child: Text(
                                          'Details',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    ),
  );
}

// Widget subRoutesBodyHeading(Trip trip) {
//   return Padding(
//     padding: const EdgeInsetsDirectional.fromSTEB(24, 4, 24, 0),
//     child: Text(
//       'Following are the parcels for ${trip.assignedDate.day} ${getMonthShortName(trip.assignedDate.month)}, ${trip.assignedDate.year}',
//       textAlign: TextAlign.start,
//       style: const TextStyle(
//         fontSize: 24,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//   );
// }

Widget singleTripContainer(Trip trip, BuildContext context) {
  return Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
    child: InkWell(
      onTap: () {
        // Navigate to the Route Details Screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return SubRoutesScreen(trip: trip);
            },
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.black26,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 4),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trip Id: ${trip.routeId}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text(
                        'Total Deliveries: ${trip.subroutes.length}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 0),
                      child: IntrinsicWidth(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                trip.assignedDate.toString().substring(0, 10),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                      child: Text(
                        // Extract just the time from the DateTime object
                        'Departure: ${trip.departureTime}',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade400,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                      child: Container(
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                            child: Text(
                              'Details',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
