import 'dart:math';

import 'package:route_optima_mobile_app/models/customer.dart';

class Subroute {
  final Customer customer;
  final String arrivalTime;
  final double distance;
  final String parcelId;
  final double weight;
  String status;

  Subroute({
    required this.customer,
    required this.arrivalTime,
    required this.distance,
    required this.parcelId,
    required this.weight,
    this.status = 'Pending',
  });

  factory Subroute.fromJson(Map<String, dynamic> json) {
    // Generate a random real number between 0.5 and 5.0
    var rng = Random();
    var generatedWeight = rng.nextDouble() * (5.0 - 0.5) + 0.5;

    return Subroute(
      customer: Customer.fromJson(json['customer']),
      arrivalTime: json['arrival_time'],
      distance: json['distance'],
      parcelId: json['parcel_id'],
      weight: generatedWeight,
    );
  }
}
