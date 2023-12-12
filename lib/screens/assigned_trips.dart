import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_optima_mobile_app/models/temp_trip.dart';
import 'package:route_optima_mobile_app/screens/drawer_widget.dart';
import 'package:route_optima_mobile_app/screens/no_trips_assigned.dart';
import 'package:route_optima_mobile_app/screens/trip_containers.dart';

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
          return getNextMonthContainer(context, trips, index);
        } else {
          return getNormalContainer(context, trips, index, sameDate);
        }
      },
    );
  }
}
