class Customer {
  final String sender;
  final String receiver;
  final String address;
  final String phoneNumber;

  Customer({
    required this.sender,
    required this.receiver,
    required this.address,
    required this.phoneNumber,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      sender: json['sender'],
      receiver: json['receiver'],
      address: json['address'],
      phoneNumber: json['phone_number'],
    );
  }
}
