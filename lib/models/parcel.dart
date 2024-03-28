class Parcel {
  String name;
  String address;
  String phone;
  String
      dueTime; // ISO format string for due time (e.g., "2023-12-12T08:30:00Z")
  String
      deliveredTime; // ISO format string for delivered time (e.g., "2023-12-12T17:00:00Z")
  String receivedBy;
  String status;
  int dueDate;
  int dueDay;
  int dueMonth;
  int dueYear;
  int dueHour;
  int dueMinute;
  double? lat;
  double? long;

  Parcel({
    required this.name,
    required this.address,
    required this.phone,
    required this.dueTime,
    required this.deliveredTime,
    required this.receivedBy,
    required this.status,
    required this.dueDate,
    required this.dueDay,
    required this.dueMonth,
    required this.dueYear,
    required this.dueHour,
    required this.dueMinute,
    this.lat,
    this.long,
  });

  factory Parcel.fromFirestore(Map<String, dynamic> json) {
    DateTime dueDateTime = DateTime.parse(json['dueTime']);

    return Parcel(
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      dueTime: dueDateTime.toIso8601String(),
      deliveredTime: json['deliveredTime'],
      receivedBy: json['receivedBy'],
      status: json['status'],
      dueDate: dueDateTime.day,
      dueDay: dueDateTime.weekday,
      dueMonth: dueDateTime.month,
      dueYear: dueDateTime.year,
      dueHour: dueDateTime.hour,
      dueMinute: dueDateTime.minute,
    );
  }
}
