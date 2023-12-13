import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_optima_mobile_app/models/trip.dart';
import 'package:route_optima_mobile_app/screens/no_trips_assigned.dart';
import 'package:route_optima_mobile_app/screens/trip_containers.dart';
import 'package:route_optima_mobile_app/services/firestore_service.dart';

class AssignedTrips extends ConsumerWidget {
  AssignedTrips({super.key});

  // final List<Trip> trips = [
  //   Trip(
  //       day: 'TUE',
  //       date: '12',
  //       month: 'Dec',
  //       year: '2023',
  //       startTime: '09:00 AM',
  //       endTime: '12:00 PM'),
  //   Trip(
  //       day: 'SAT',
  //       date: '12',
  //       month: 'Dec',
  //       year: '2023',
  //       startTime: '01:00 PM',
  //       endTime: '06:00 PM'),
  // ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int previousDate = 0;
    int previousMonth = 0;
    int previousYear = 0;

    final List<Trip> trips = ref.watch(assignedTripsNotifierProvider);

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
          return getNextMonthContainer(context, trips, index);
        } else {
          return getNormalContainer(context, trips, index, sameDate);
        }
      },
    );
  }
}
