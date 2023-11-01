import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:route_optima_mobile_app/screens/subroutes.dart';
import 'package:route_optima_mobile_app/services/route_list_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trips = ref.watch(routeListProvider);

    return Scaffold(
      // Also show the number of trips (length of the list)
      appBar: AppBar(title: Text('Current Routes (${trips.length})')),
      body: ListView.builder(
        itemCount: trips.length,
        itemBuilder: (context, index) {
          final trip = trips[index];
          return ListTile(
            title: Text('Departure Time: ${trip.departureTime}'),
            subtitle: Text('Number of Deliveries: ${trip.subroutes.length}'),
            trailing: Text('Finish Time: ${trip.arrivalTime}'),
            onTap: () {
              // Navigate to the Route Details Screen
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return RouteDetailsScreen(trip: trip);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
