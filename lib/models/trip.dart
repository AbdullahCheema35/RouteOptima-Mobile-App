// class Trip {
//   final List<Subroute> subroutes;
//   final String routeId;
//   final DateTime assignedDate;
//   final String departureTime;
//   final String arrivalTime;

//   Trip({
//     required this.subroutes,
//     required this.routeId,
//     required this.assignedDate,
//     required this.departureTime,
//     required this.arrivalTime,
//   });

//   factory Trip.initial(Map<String, dynamic> json) {
//     return Trip(
//       subroutes: [],
//       routeId: "",
//       assignedDate: DateTime.now(),
//       departureTime: json['startTime'],
//       arrivalTime: json['endTime'],
//     );
//   }

//   factory Trip.fromRoute(Trip route) {
//     return Trip(
//       subroutes: route.subroutes,
//       routeId: route.routeId,
//       assignedDate: route.assignedDate,
//       departureTime: route.departureTime,
//       arrivalTime: route.arrivalTime,
//     );
//   }

//   // factory Trip.fromJson(Map<String, dynamic> json) {
//   //   return Trip(
//   //     subroutes: List<Subroute>.from(
//   //       json['subroutes'].map(
//   //         (subroute) => Subroute.fromJson(subroute),
//   //       ),
//   //     ),
//   //     routeId: json['route_id'],
//   //     assignedDate: DateTime.parse(json['assigned_date']),
//   //     departureTime: DateTime.parse(json['departure_time']),
//   //     arrivalTime: DateTime.parse(json['arrival_time']),
//   //   );
//   // }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  String id;
  String status;
  String startTime; // ISO format string (e.g., "2023-12-12T08:30:00Z")
  String endTime; // ISO format datetime string (e.g., "2023-12-12T17:00:00Z")
  List<DocumentReference> parcelRefs;
  int date;
  int day;
  int month;
  int year;
  int hour;
  int minute;
  List? parcels;

  Trip({
    required this.id,
    required this.status,
    required this.startTime,
    required this.endTime,
    required this.parcelRefs,
    required this.date,
    required this.day,
    required this.month,
    required this.year,
    required this.hour,
    required this.minute,
  });

  factory Trip.fromFirestore(Map<String, dynamic> json, String _id) {
    DateTime startDateTime = DateTime.parse(json['startTime']);
    DateTime endDateTime = DateTime.parse(json['endTime']);

    return Trip(
      id: _id,
      status: json['status'],
      startTime: startDateTime.toIso8601String(),
      endTime: endDateTime.toIso8601String(),
      parcelRefs: List<DocumentReference>.from(json['parcels']),
      date: startDateTime.day,
      day: startDateTime.weekday,
      month: startDateTime.month,
      year: startDateTime.year,
      hour: startDateTime.hour,
      minute: startDateTime.minute,
    );
  }
}
