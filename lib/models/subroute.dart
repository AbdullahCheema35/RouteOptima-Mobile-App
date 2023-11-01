import 'package:route_optima_mobile_app/models/customer.dart';

class Subroute {
  final Customer customer;
  final String arrivalTime;
  final double distance;
  final String parcelId;

  Subroute({
    required this.customer,
    required this.arrivalTime,
    required this.distance,
    required this.parcelId,
  });

  factory Subroute.fromJson(Map<String, dynamic> json) {
    return Subroute(
      customer: Customer.fromJson(json['customer']),
      arrivalTime: json['arrival_time'],
      distance: json['distance'],
      parcelId: json['parcel_id'],
    );
  }
}
