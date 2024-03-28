import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_optima_mobile_app/models/parcel.dart';
import 'package:route_optima_mobile_app/models/trip.dart';
import 'package:route_optima_mobile_app/screens/no_trips_assigned.dart';
import 'package:route_optima_mobile_app/screens/trip_containers.dart';
import 'package:route_optima_mobile_app/services/assignment_stream_provider.dart';

class AssignedTrips extends ConsumerWidget {
  const AssignedTrips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<DocumentSnapshot> assignmentSnapshot =
        ref.watch(assignmentStreamProvider);

    return assignmentSnapshot.when(
      data: (assignmentData) {
        if (!assignmentData.exists) {
          return NoTripsAssigned();
        } else {
          const index = 0;
          final trip =
              createTempTrip(assignmentData.data() as Map<String, dynamic>);
          final trips = [trip];
          final parcels =
              createParcelListFromResponse(assignmentData['parcels']);
          return getNextMonthContainer(context, trips, index, parcels: parcels);
        }
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, _) => Center(
        child: Text('Error: $error'),
      ),
    );
  }
}

Trip createTempTrip(Map<String, dynamic> data) {
  final startTime = parseDateTime(data['date'] + ' ' + data['startTime']);
  final endTime = parseDateTime(data['date'] + ' ' + data['endTime']);

  return Trip(
    id: 'abc124',
    status: data['status'],
    startTime: startTime.toIso8601String(),
    endTime: endTime.toIso8601String(),
    month: startTime.month,
    year: startTime.year,
    day: startTime.weekday,
    hour: startTime.hour,
    minute: startTime.minute,
    date: startTime.day,
    parcelRefs: [],
  );
}

DateTime parseDateTime(String dateTimeString) {
  // Split the date time string by space
  List<String> parts = dateTimeString.split(' ');

  // Extract date and time parts
  String datePart = parts[0];
  String timePart = parts[1];

  // Split the date part by '/'
  List<String> dateParts = datePart.split('/');

  // Extract month, day, and year
  int month = int.parse(dateParts[0]);
  int day = int.parse(dateParts[1]);
  int year = int.parse(dateParts[2]);

  // Split the time part by ':'
  List<String> timeParts = timePart.split(':');

  // Extract hour and minute
  int hour = int.parse(timeParts[0]);
  int minute = int.parse(timeParts[1]);

  // Check if it's AM or PM
  bool isPM = parts[2].toUpperCase() == 'PM';

  // Adjust hour if it's PM
  if (isPM && hour != 12) {
    hour += 12;
  } else if (!isPM && hour == 12) {
    // Adjust hour if it's 12 AM
    hour = 0;
  }

  // Create DateTime object
  return DateTime(year, month, day, hour, minute);
}

List<Parcel> createParcelListFromResponse(List<dynamic> responseList) {
  return responseList.map((responseMap) {
    // Extract required fields
    final name = responseMap['receiver']['name'];
    final address = responseMap['receiver']['address'];
    final phone = responseMap['receiver']['phone'];
    final dueTime = responseMap['arrival_time'];
    final status = responseMap['status'];
    final lat = responseMap['location']['lat'];
    final long = responseMap['location']['long'];

    // Parse dueTime into ISO format and extract date components
    final parsedDueTime = parseDateTime("3/18/2024 $dueTime");
    final dueDate = parsedDueTime.day;
    final dueDay = parsedDueTime.weekday;
    final dueMonth = parsedDueTime.month;
    final dueYear = parsedDueTime.year;
    final dueHour = parsedDueTime.hour;
    final dueMinute = parsedDueTime.minute;

    // Assuming "receivedBy" is not provided by the API, set it to null
    const receivedBy = "null";

    return Parcel(
      name: name,
      address: address,
      phone: phone,
      dueTime: parsedDueTime.toIso8601String(),
      deliveredTime: parsedDueTime.toIso8601String(),
      receivedBy: receivedBy,
      status: status,
      dueDate: dueDate,
      dueDay: dueDay,
      dueMonth: dueMonth,
      dueYear: dueYear,
      dueHour: dueHour,
      dueMinute: dueMinute,
      lat: lat,
      long: long,
    );
  }).toList();
}
