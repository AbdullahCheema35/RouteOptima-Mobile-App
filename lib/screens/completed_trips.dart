import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_optima_mobile_app/models/trip.dart';
import 'package:route_optima_mobile_app/screens/trip_containers.dart';
import 'package:route_optima_mobile_app/services/firestore_service.dart';

class CompletedTripsScreen extends ConsumerWidget {
  final isAssignedList = false;

  const CompletedTripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int previousDate = 0;
    int previousMonth = 0;
    int previousYear = 0;

    final List<Trip> trips = ref.watch(completedTripsNotifierProvider);

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
          return getNextMonthContainer(context, trips, index,
              isAssignedList: isAssignedList);
        } else {
          return getNormalContainer(context, trips, index, sameDate,
              isAssignedList: isAssignedList);
        }
      },
    );
  }
}
