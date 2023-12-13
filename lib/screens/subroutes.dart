// import 'package:flutter/material.dart';
// import 'package:route_optima_mobile_app/models/trip.dart';
// import 'package:route_optima_mobile_app/screens/subroute_details.dart';

// class RouteDetailsScreen extends StatelessWidget {
//   final Trip trip;

//   const RouteDetailsScreen({super.key, required this.trip});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Trip Details')),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ListTile(
//             title: Text('Assigned Date: ${trip.assignedDate}'),
//           ),
//           for (var subroute in trip.subroutes)
//             ListTile(
//               title: Text('Receiver: ${subroute.customer.receiver}'),
//               subtitle: Text('Address: ${subroute.customer.address}'),
//               trailing: Text('Arrival Time: ${subroute.arrivalTime}'),
//               onTap: () {
//                 // Navigate to the Subroute Details Screen
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         SubrouteDetailsScreen(subroute: subroute),
//                   ),
//                 );
//               },
//             ),
//         ],
//       ),
//     );
//   }
// }
