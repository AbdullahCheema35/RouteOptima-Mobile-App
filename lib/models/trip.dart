import 'package:route_optima_mobile_app/models/subroute.dart';

class Trip {
  final List<Subroute> subroutes;
  final String routeId;
  final DateTime assignedDate;
  final DateTime departureTime;
  final DateTime arrivalTime;

  Trip({
    required this.subroutes,
    required this.routeId,
    required this.assignedDate,
    required this.departureTime,
    required this.arrivalTime,
  });

  factory Trip.fromRoute(Trip route) {
    return Trip(
      subroutes: route.subroutes,
      routeId: route.routeId,
      assignedDate: route.assignedDate,
      departureTime: route.departureTime,
      arrivalTime: route.arrivalTime,
    );
  }

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      subroutes: List<Subroute>.from(
        json['subroutes'].map(
          (subroute) => Subroute.fromJson(subroute),
        ),
      ),
      routeId: json['route_id'],
      assignedDate: DateTime.parse(json['assigned_date']),
      departureTime: DateTime.parse(json['departure_time']),
      arrivalTime: DateTime.parse(json['arrival_time']),
    );
  }
}
