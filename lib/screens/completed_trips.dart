import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_optima_mobile_app/models/temp_trip.dart';
import 'package:route_optima_mobile_app/screens/drawer_widget.dart';
import 'package:route_optima_mobile_app/screens/trip_containers.dart';

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
      reverse: true,
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
