// import 'dart:convert';
// import 'dart:io';
import 'package:route_optima_mobile_app/models/dummy_data/seed_data.dart';

class DummyRoute {
  String routeId;
  DateTime assignedDate;
  DateTime departureTime;
  DateTime arrivalTime;
  double distance;
  bool onTime;

  DummyRoute({
    required this.routeId,
    required this.assignedDate,
    required this.departureTime,
    required this.arrivalTime,
    required this.distance,
    required this.onTime,
  });

  factory DummyRoute.fromJson(Map<String, dynamic> json) {
    return DummyRoute(
      routeId: json['route_id'],
      assignedDate: DateTime.parse(json['assigned_date']),
      departureTime: DateTime.parse(json['departure_time']),
      arrivalTime: DateTime.parse(json['arrival_time']),
      distance: json['distance'].toDouble(),
      onTime: json['on_time'],
    );
  }
}

// List<DummyRoute> parseRoutes(String jsonString) {
//   final parsed = jsonDecode(jsonString);
//   List<dynamic> routes = parsed['routes'];
//   return routes.map((route) => DummyRoute.fromJson(route)).toList();
// }

// List<DummyRoute> readRoutesFromFile(String filePath) {
//   try {
//     File file = File(filePath);
//     String contents = file.readAsStringSync();
//     return parseRoutes(contents);
//   } catch (e) {
//     print('Error reading file: $e');
//     return [];
//   }
// }

List<DummyRoute> get dummyRoutes {
  final routes = dummyRoutesData['routes'] as List<dynamic>;
  return routes.map((route) => DummyRoute.fromJson(route)).toList();
}
