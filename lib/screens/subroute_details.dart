// import 'package:flutter/material.dart';
// import 'package:route_optima_mobile_app/models/subroute.dart';

// class SubrouteDetailsScreen extends StatelessWidget {
//   final Subroute subroute;

//   const SubrouteDetailsScreen({super.key, required this.subroute});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Parcel Details'),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ListTile(title: Text('Receiver: ${subroute.customer.receiver}')),
//           ListTile(title: Text('Address: ${subroute.customer.address}')),
//           ListTile(title: Text('Phone: ${subroute.customer.phoneNumber}')),
//           ListTile(title: Text('Distance: ${subroute.distance}')),
//           ListTile(title: Text('Arrival Time: ${subroute.arrivalTime}')),
//           ListTile(title: Text('Parcel ID: ${subroute.parcelId}')),
//         ],
//       ),
//     );
//   }
// }
