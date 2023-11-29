class Location {
  final String lat;
  final String long;

  Location({required this.lat, required this.long});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: json['lat'],
      long: json['long'],
    );
  }
}
