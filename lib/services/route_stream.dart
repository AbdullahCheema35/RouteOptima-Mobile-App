// import 'dart:convert';
// import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:route_optima_mobile_app/models/customer.dart';
// import 'package:route_optima_mobile_app/models/subroute.dart';
import 'package:route_optima_mobile_app/models/trip.dart';

final dbClientSocketProvider = Provider<DBClientSocket>(
  (ref) {
    return FirestoreService();
  },
);

final routeStreamProvider = StreamProvider<List<Trip>>((ref) {
  final dbClient = ref.watch(dbClientSocketProvider);
  return dbClient.getRouteStream();
});

abstract class DBClientSocket {
  Stream<List<Trip>> getRouteStream();
}

// class FakeWebsocketClient implements DBClientSocket {
//   @override
//   Stream<List<Trip>> getRouteStream() async* {
//     // String jsonFile = './lib/models/dummy_data/routes.json';
//     // String jsonFile = 'assets/routes.json';
//     List<Trip> routes = getTrips();
//     int routesLength = routes.length;
//     print('routesLength: $routesLength');
//     if (routesLength == 0) {
//       routes = getHardCodedRoutes();
//       routesLength = routes.length;
//     }
//     int globalIValue = 0;
//     int i = 0;
//     while (true) {
//       // print('i: $i, waiting 10 seconds');
//       if (globalIValue > 0) {
//         await Future.delayed(const Duration(milliseconds: 6000000));
//       }
//       globalIValue++;
//       Trip currentRoute = routes[i];
//       i = (i + 1) % routesLength;
//       Trip nextRoute = routes[i];

//       yield [currentRoute, nextRoute];
//     }
//   }

//   List<Trip> getHardCodedRoutes() {
//     // Define a single hard-coded route with subroutes
//     Trip hardCodedRoute = Trip(
//       subroutes: [
//         Subroute(
//           customer: Customer(
//             sender: 'Sender1',
//             receiver: 'Receiver1',
//             address: 'Address1',
//             phoneNumber: '123-456-7890',
//           ),
//           arrivalTime: '2023-11-01T08:00:00',
//           distance: 5.0,
//           parcelId: 'Parcel1',
//           weight: 2.0,
//         ),
//         Subroute(
//           customer: Customer(
//             sender: 'Sender2',
//             receiver: 'Receiver2',
//             address: 'Address2',
//             phoneNumber: '987-654-3210',
//           ),
//           arrivalTime: '2023-11-01T09:30:00',
//           distance: 4.5,
//           parcelId: 'Parcel2',
//           weight: 3.0,
//         ),
//         // Add more subroutes if needed
//       ],
//       routeId: 'Route1',
//       assignedDate: DateTime.parse('2023-11-01T08:00:00'),
//       departureTime: DateTime.parse('2023-11-01T09:30:00'),
//       arrivalTime: DateTime.parse('2023-11-01T17:00:00'),
//     );

//     // Return a list of hard-coded routes
//     return [hardCodedRoute];
//   }

//   List<Trip> getRoutesFromJsonFile(String filePath) {
//     print('Reading JSON file: $filePath');
//     try {
//       File file = File(filePath);
//       if (!file.existsSync()) {
//         throw Exception('File not found: $filePath');
//       }

//       final jsonString = file.readAsStringSync();
//       final jsonData = json.decode(jsonString);

//       // Generate a random real number between 0.5 and 5.0
//       var rng = Random();

//       List<Trip> routes = List<Trip>.from(
//         jsonData['routes'].map(
//           (routeData) {
//             List<Subroute> subroutes = List<Subroute>.from(
//               routeData['subroutes'].map(
//                 (subrouteData) {
//                   Customer customer = Customer(
//                     sender: subrouteData['customer']['sender'],
//                     receiver: subrouteData['customer']['receiver'],
//                     address: subrouteData['customer']['address'],
//                     phoneNumber: subrouteData['customer']['phone_number'],
//                   );

//                   var generatedWeight = rng.nextDouble() * (5.0 - 0.5) + 0.5;

//                   return Subroute(
//                     customer: customer,
//                     arrivalTime: subrouteData['arrival_time'],
//                     distance: subrouteData['distance'].toDouble(),
//                     parcelId: subrouteData['parcel_id'],
//                     weight: generatedWeight,
//                   );
//                 },
//               ),
//             );

//             return Trip(
//               subroutes: subroutes,
//               routeId: routeData['route_id'],
//               assignedDate: DateTime.parse(routeData['assigned_date']),
//               departureTime: DateTime.parse(routeData['departure_time']),
//               arrivalTime: DateTime.parse(routeData['arrival_time']),
//             );
//           },
//         ),
//       );

//       return routes;
//     } catch (e) {
//       print('Error reading JSON file: $e');
//       return [];
//     }
//   }
// }

// List<Trip> getTrips() {
//   const jsonString = '''{
//     "routes": [
//       {
//         "subroutes": [
//           {
//             "customer": {
//               "sender": "Sender1",
//               "receiver": "Receiver1",
//               "address": "Address1",
//               "phone_number": "111-111-1111"
//             },
//             "arrival_time": "2023-11-02T09:00:00",
//             "distance": 5.2,
//             "parcel_id": "Parcel1"
//           },
//           {
//             "customer": {
//               "sender": "Sender2",
//               "receiver": "Receiver2",
//               "address": "Address2",
//               "phone_number": "222-222-2222"
//             },
//             "arrival_time": "2023-11-02T10:30:00",
//             "distance": 8.7,
//             "parcel_id": "Parcel2"
//           },
//           {
//             "customer": {
//               "sender": "Sender3",
//               "receiver": "Receiver3",
//               "address": "Address3",
//               "phone_number": "333-333-3333"
//             },
//             "arrival_time": "2023-11-02T12:15:00",
//             "distance": 3.3,
//             "parcel_id": "Parcel3"
//           },
//           {
//             "customer": {
//               "sender": "Sender4",
//               "receiver": "Receiver4",
//               "address": "Address4",
//               "phone_number": "444-444-4444"
//             },
//             "arrival_time": "2023-11-02T13:45:00",
//             "distance": 4.8,
//             "parcel_id": "Parcel4"
//           },
//           {
//             "customer": {
//               "sender": "Sender5",
//               "receiver": "Receiver5",
//               "address": "Address5",
//               "phone_number": "555-555-5555"
//             },
//             "arrival_time": "2023-11-02T15:00:00",
//             "distance": 6.1,
//             "parcel_id": "Parcel5"
//           },
//           {
//             "customer": {
//               "sender": "Sender6",
//               "receiver": "Receiver6",
//               "address": "Address6",
//               "phone_number": "666-666-6666"
//             },
//             "arrival_time": "2023-11-02T16:30:00",
//             "distance": 9.2,
//             "parcel_id": "Parcel6"
//           },
//           {
//             "customer": {
//               "sender": "Sender7",
//               "receiver": "Receiver7",
//               "address": "Address7",
//               "phone_number": "777-777-7777"
//             },
//             "arrival_time": "2023-11-02T18:00:00",
//             "distance": 7.5,
//             "parcel_id": "Parcel7"
//           },
//           {
//             "customer": {
//               "sender": "Sender8",
//               "receiver": "Receiver8",
//               "address": "Address8",
//               "phone_number": "888-888-8888"
//             },
//             "arrival_time": "2023-11-02T19:45:00",
//             "distance": 5.4,
//             "parcel_id": "Parcel8"
//           },
//           {
//             "customer": {
//               "sender": "Sender9",
//               "receiver": "Receiver9",
//               "address": "Address9",
//               "phone_number": "999-999-9999"
//             },
//             "arrival_time": "2023-11-02T21:15:00",
//             "distance": 4.1,
//             "parcel_id": "Parcel9"
//           },
//           {
//             "customer": {
//               "sender": "Sender10",
//               "receiver": "Receiver10",
//               "address": "Address10",
//               "phone_number": "101-101-1010"
//             },
//             "arrival_time": "2023-11-02T22:30:00",
//             "distance": 2.8,
//             "parcel_id": "Parcel10"
//           },
//           {
//             "customer": {
//               "sender": "Sender11",
//               "receiver": "Receiver11",
//               "address": "Address11",
//               "phone_number": "1111-1111-1111"
//             },
//             "arrival_time": "2023-11-02T23:45:00",
//             "distance": 3.9,
//             "parcel_id": "Parcel11"
//           },
//           {
//             "customer": {
//               "sender": "Sender12",
//               "receiver": "Receiver12",
//               "address": "Address12",
//               "phone_number": "1212-1212-1212"
//             },
//             "arrival_time": "2023-11-03T01:00:00",
//             "distance": 4.7,
//             "parcel_id": "Parcel12"
//           }
//         ],
//         "route_id": "Route1",
//         "assigned_date": "2023-11-02T08:00:00",
//         "departure_time": "2023-11-02T09:00:00",
//         "arrival_time": "2023-11-02T17:30:00"
//       },
//       {
//         "subroutes": [
//           {
//             "customer": {
//               "sender": "Sender13",
//               "receiver": "Receiver13",
//               "address": "Address13",
//               "phone_number": "1313-1313-1313"
//             },
//             "arrival_time": "2023-11-03T08:30:00",
//             "distance": 6.9,
//             "parcel_id": "Parcel13"
//           },
//           {
//             "customer": {
//               "sender": "Sender14",
//               "receiver": "Receiver14",
//               "address": "Address14",
//               "phone_number": "1414-1414-1414"
//             },
//             "arrival_time": "2023-11-03T10:00:00",
//             "distance": 7.8,
//             "parcel_id": "Parcel14"
//           },
//           {
//             "customer": {
//               "sender": "Sender15",
//               "receiver": "Receiver15",
//               "address": "Address15",
//               "phone_number": "1515-1515-1515"
//             },
//             "arrival_time": "2023-11-03T12:15:00",
//             "distance": 4.3,
//             "parcel_id": "Parcel15"
//           },
//           {
//             "customer": {
//               "sender": "Sender16",
//               "receiver": "Receiver16",
//               "address": "Address16",
//               "phone_number": "1616-1616-1616"
//             },
//             "arrival_time": "2023-11-03T13:45:00",
//             "distance": 5.6,
//             "parcel_id": "Parcel16"
//           },
//           {
//             "customer": {
//               "sender": "Sender17",
//               "receiver": "Receiver17",
//               "address": "Address17",
//               "phone_number": "1717-1717-1717"
//             },
//             "arrival_time": "2023-11-03T15:00:00",
//             "distance": 8.2,
//             "parcel_id": "Parcel17"
//           },
//           {
//             "customer": {
//               "sender": "Sender18",
//               "receiver": "Receiver18",
//               "address": "Address18",
//               "phone_number": "1818-1818-1818"
//             },
//             "arrival_time": "2023-11-03T16:30:00",
//             "distance": 6.7,
//             "parcel_id": "Parcel18"
//           },
//           {
//             "customer": {
//               "sender": "Sender19",
//               "receiver": "Receiver19",
//               "address": "Address19",
//               "phone_number": "1919-1919-1919"
//             },
//             "arrival_time": "2023-11-03T18:00:00",
//             "distance": 4.9,
//             "parcel_id": "Parcel19"
//           },
//           {
//             "customer": {
//               "sender": "Sender20",
//               "receiver": "Receiver20",
//               "address": "Address20",
//               "phone_number": "2020-2020-2020"
//             },
//             "arrival_time": "2023-11-03T19:45:00",
//             "distance": 3.8,
//             "parcel_id": "Parcel20"
//           },
//           {
//             "customer": {
//               "sender": "Sender21",
//               "receiver": "Receiver21",
//               "address": "Address21",
//               "phone_number": "2121-2121-2121"
//             },
//             "arrival_time": "2023-11-03T21:15:00",
//             "distance": 2.4,
//             "parcel_id": "Parcel21"
//           },
//           {
//             "customer": {
//               "sender": "Sender22",
//               "receiver": "Receiver22",
//               "address": "Address22",
//               "phone_number": "2222-2222-2222"
//             },
//             "arrival_time": "2023-11-03T22:30:00",
//             "distance": 6.0,
//             "parcel_id": "Parcel22"
//           },
//           {
//             "customer": {
//               "sender": "Sender23",
//               "receiver": "Receiver23",
//               "address": "Address23",
//               "phone_number": "2323-2323-2323"
//             },
//             "arrival_time": "2023-11-04T01:00:00",
//             "distance": 5.2,
//             "parcel_id": "Parcel23"
//           }
//         ],
//         "route_id": "Route2",
//         "assigned_date": "2023-11-03T08:00:00",
//         "departure_time": "2023-11-03T09:30:00",
//         "arrival_time": "2023-11-03T18:15:00"
//       },
//       {
//         "subroutes": [
//           {
//             "customer": {
//               "sender": "Sender24",
//               "receiver": "Receiver24",
//               "address": "Address24",
//               "phone_number": "2424-2424-2424"
//             },
//             "arrival_time": "2023-11-04T08:30:00",
//             "distance": 7.1,
//             "parcel_id": "Parcel24"
//           },
//           {
//             "customer": {
//               "sender": "Sender25",
//               "receiver": "Receiver25",
//               "address": "Address25",
//               "phone_number": "2525-2525-2525"
//             },
//             "arrival_time": "2023-11-04T10:00:00",
//             "distance": 6.8,
//             "parcel_id": "Parcel25"
//           },
//           {
//             "customer": {
//               "sender": "Sender26",
//               "receiver": "Receiver26",
//               "address": "Address26",
//               "phone_number": "2626-2626-2626"
//             },
//             "arrival_time": "2023-11-04T12:15:00",
//             "distance": 5.2,
//             "parcel_id": "Parcel26"
//           },
//           {
//             "customer": {
//               "sender": "Sender27",
//               "receiver": "Receiver27",
//               "address": "Address27",
//               "phone_number": "2727-2727-2727"
//             },
//             "arrival_time": "2023-11-04T13:45:00",
//             "distance": 3.9,
//             "parcel_id": "Parcel27"
//           },
//           {
//             "customer": {
//               "sender": "Sender28",
//               "receiver": "Receiver28",
//               "address": "Address28",
//               "phone_number": "2828-2828-2828"
//             },
//             "arrival_time": "2023-11-04T15:00:00",
//             "distance": 6.5,
//             "parcel_id": "Parcel28"
//           },
//           {
//             "customer": {
//               "sender": "Sender29",
//               "receiver": "Receiver29",
//               "address": "Address29",
//               "phone_number": "2929-2929-2929"
//             },
//             "arrival_time": "2023-11-04T16:30:00",
//             "distance": 4.3,
//             "parcel_id": "Parcel29"
//           },
//           {
//             "customer": {
//               "sender": "Sender30",
//               "receiver": "Receiver30",
//               "address": "Address30",
//               "phone_number": "3030-3030-3030"
//             },
//             "arrival_time": "2023-11-04T18:00:00",
//             "distance": 7.8,
//             "parcel_id": "Parcel30"
//           },
//           {
//             "customer": {
//               "sender": "Sender31",
//               "receiver": "Receiver31",
//               "address": "Address31",
//               "phone_number": "3131-3131-3131"
//             },
//             "arrival_time": "2023-11-04T19:45:00",
//             "distance": 5.7,
//             "parcel_id": "Parcel31"
//           },
//           {
//             "customer": {
//               "sender": "Sender32",
//               "receiver": "Receiver32",
//               "address": "Address32",
//               "phone_number": "3232-3232-3232"
//             },
//             "arrival_time": "2023-11-04T21:15:00",
//             "distance": 3.1,
//             "parcel_id": "Parcel32"
//           },
//           {
//             "customer": {
//               "sender": "Sender33",
//               "receiver": "Receiver33",
//               "address": "Address33",
//               "phone_number": "3333-3333-3333"
//             },
//             "arrival_time": "2023-11-04T22:30:00",
//             "distance": 9.0,
//             "parcel_id": "Parcel33"
//           },
//           {
//             "customer": {
//               "sender": "Sender34",
//               "receiver": "Receiver34",
//               "address": "Address34",
//               "phone_number": "3434-3434-3434"
//             },
//             "arrival_time": "2023-11-05T01:00:00",
//             "distance": 8.4,
//             "parcel_id": "Parcel34"
//           }
//         ],
//         "route_id": "Route3",
//         "assigned_date": "2023-11-04T08:00:00",
//         "departure_time": "2023-11-04T09:15:00",
//         "arrival_time": "2023-11-04T17:15:00"
//       },
//       {
//         "subroutes": [
//           {
//             "customer": {
//               "sender": "Sender35",
//               "receiver": "Receiver35",
//               "address": "Address35",
//               "phone_number": "3535-3535-3535"
//             },
//             "arrival_time": "2023-11-05T08:45:00",
//             "distance": 5.5,
//             "parcel_id": "Parcel35"
//           },
//           {
//             "customer": {
//               "sender": "Sender36",
//               "receiver": "Receiver36",
//               "address": "Address36",
//               "phone_number": "3636-3636-3636"
//             },
//             "arrival_time": "2023-11-05T10:15:00",
//             "distance": 6.2,
//             "parcel_id": "Parcel36"
//           },
//           {
//             "customer": {
//               "sender": "Sender37",
//               "receiver": "Receiver37",
//               "address": "Address37",
//               "phone_number": "3737-3737-3737"
//             },
//             "arrival_time": "2023-11-05T12:30:00",
//             "distance": 4.8,
//             "parcel_id": "Parcel37"
//           },
//           {
//             "customer": {
//               "sender": "Sender38",
//               "receiver": "Receiver38",
//               "address": "Address38",
//               "phone_number": "3838-3838-3838"
//             },
//             "arrival_time": "2023-11-05T13:45:00",
//             "distance": 7.1,
//             "parcel_id": "Parcel38"
//           },
//           {
//             "customer": {
//               "sender": "Sender39",
//               "receiver": "Receiver39",
//               "address": "Address39",
//               "phone_number": "3939-3939-3939"
//             },
//             "arrival_time": "2023-11-05T15:00:00",
//             "distance": 6.3,
//             "parcel_id": "Parcel39"
//           },
//           {
//             "customer": {
//               "sender": "Sender40",
//               "receiver": "Receiver40",
//               "address": "Address40",
//               "phone_number": "4040-4040-4040"
//             },
//             "arrival_time": "2023-11-05T16:30:00",
//             "distance": 8.2,
//             "parcel_id": "Parcel40"
//           },
//           {
//             "customer": {
//               "sender": "Sender41",
//               "receiver": "Receiver41",
//               "address": "Address41",
//               "phone_number": "4141-4141-4141"
//             },
//             "arrival_time": "2023-11-05T18:00:00",
//             "distance": 5.6,
//             "parcel_id": "Parcel41"
//           },
//           {
//             "customer": {
//               "sender": "Sender42",
//               "receiver": "Receiver42",
//               "address": "Address42",
//               "phone_number": "4242-4242-4242"
//             },
//             "arrival_time": "2023-11-05T19:45:00",
//             "distance": 7.0,
//             "parcel_id": "Parcel42"
//           },
//           {
//             "customer": {
//               "sender": "Sender43",
//               "receiver": "Receiver43",
//               "address": "Address43",
//               "phone_number": "4343-4343-4343"
//             },
//             "arrival_time": "2023-11-05T21:15:00",
//             "distance": 5.4,
//             "parcel_id": "Parcel43"
//           },
//           {
//             "customer": {
//               "sender": "Sender44",
//               "receiver": "Receiver44",
//               "address": "Address44",
//               "phone_number": "4444-4444-4444"
//             },
//             "arrival_time": "2023-11-05T22:30:00",
//             "distance": 6.7,
//             "parcel_id": "Parcel44"
//           },
//           {
//             "customer": {
//               "sender": "Sender45",
//               "receiver": "Receiver45",
//               "address": "Address45",
//               "phone_number": "4545-4545-4545"
//             },
//             "arrival_time": "2023-11-06T01:00:00",
//             "distance": 5.9,
//             "parcel_id": "Parcel45"
//           }
//         ],
//         "route_id": "Route4",
//         "assigned_date": "2023-11-05T08:15:00",
//         "departure_time": "2023-11-05T09:45:00",
//         "arrival_time": "2023-11-05T17:45:00"
//       },
//       {
//         "subroutes": [
//           {
//             "customer": {
//               "sender": "Sender46",
//               "receiver": "Receiver46",
//               "address": "Address46",
//               "phone_number": "4646-4646-4646"
//             },
//             "arrival_time": "2023-11-06T08:30:00",
//             "distance": 6.2,
//             "parcel_id": "Parcel46"
//           },
//           {
//             "customer": {
//               "sender": "Sender47",
//               "receiver": "Receiver47",
//               "address": "Address47",
//               "phone_number": "4747-4747-4747"
//             },
//             "arrival_time": "2023-11-06T10:00:00",
//             "distance": 5.7,
//             "parcel_id": "Parcel47"
//           },
//           {
//             "customer": {
//               "sender": "Sender48",
//               "receiver": "Receiver48",
//               "address": "Address48",
//               "phone_number": "4848-4848-4848"
//             },
//             "arrival_time": "2023-11-06T12:15:00",
//             "distance": 4.1,
//             "parcel_id": "Parcel48"
//           },
//           {
//             "customer": {
//               "sender": "Sender49",
//               "receiver": "Receiver49",
//               "address": "Address49",
//               "phone_number": "4949-4949-4949"
//             },
//             "arrival_time": "2023-11-06T13:45:00",
//             "distance": 6.5,
//             "parcel_id": "Parcel49"
//           },
//           {
//             "customer": {
//               "sender": "Sender50",
//               "receiver": "Receiver50",
//               "address": "Address50",
//               "phone_number": "5050-5050-5050"
//             },
//             "arrival_time": "2023-11-06T15:00:00",
//             "distance": 7.3,
//             "parcel_id": "Parcel50"
//           },
//           {
//             "customer": {
//               "sender": "Sender51",
//               "receiver": "Receiver51",
//               "address": "Address51",
//               "phone_number": "5151-5151-5151"
//             },
//             "arrival_time": "2023-11-06T16:30:00",
//             "distance": 5.9,
//             "parcel_id": "Parcel51"
//           },
//           {
//             "customer": {
//               "sender": "Sender52",
//               "receiver": "Receiver52",
//               "address": "Address52",
//               "phone_number": "5252-5252-5252"
//             },
//             "arrival_time": "2023-11-06T18:00:00",
//             "distance": 6.8,
//             "parcel_id": "Parcel52"
//           },
//           {
//             "customer": {
//               "sender": "Sender53",
//               "receiver": "Receiver53",
//               "address": "Address53",
//               "phone_number": "5353-5353-5353"
//             },
//             "arrival_time": "2023-11-06T19:45:00",
//             "distance": 4.6,
//             "parcel_id": "Parcel53"
//           },
//           {
//             "customer": {
//               "sender": "Sender54",
//               "receiver": "Receiver54",
//               "address": "Address54",
//               "phone_number": "5454-5454-5454"
//             },
//             "arrival_time": "2023-11-06T21:15:00",
//             "distance": 7.0,
//             "parcel_id": "Parcel54"
//           },
//           {
//             "customer": {
//               "sender": "Sender55",
//               "receiver": "Receiver55",
//               "address": "Address55",
//               "phone_number": "5555-5555-5555"
//             },
//             "arrival_time": "2023-11-06T22:30:00",
//             "distance": 5.2,
//             "parcel_id": "Parcel55"
//           },
//           {
//             "customer": {
//               "sender": "Sender56",
//               "receiver": "Receiver56",
//               "address": "Address56",
//               "phone_number": "5656-5656-5656"
//             },
//             "arrival_time": "2023-11-07T01:00:00",
//             "distance": 6.1,
//             "parcel_id": "Parcel56"
//           }
//         ],
//         "route_id": "Route5",
//         "assigned_date": "2023-11-06T08:00:00",
//         "departure_time": "2023-11-06T09:30:00",
//         "arrival_time": "2023-11-06T18:15:00"
//       }
//     ]
//   }''';
//   final jsonData = json.decode(jsonString);

//   // Generate a random real number between 0.5 and 5.0
//   var rng = Random();

//   List<Trip> routes = List<Trip>.from(
//     jsonData['routes'].map(
//       (routeData) {
//         List<Subroute> subroutes = List<Subroute>.from(
//           routeData['subroutes'].map(
//             (subrouteData) {
//               Customer customer = Customer(
//                 sender: subrouteData['customer']['sender'],
//                 receiver: subrouteData['customer']['receiver'],
//                 address: subrouteData['customer']['address'],
//                 phoneNumber: subrouteData['customer']['phone_number'],
//               );

//               var generatedWeight = rng.nextDouble() * (5.0 - 0.5) + 0.5;

//               return Subroute(
//                 customer: customer,
//                 arrivalTime: subrouteData['arrival_time'],
//                 distance: subrouteData['distance'].toDouble(),
//                 parcelId: subrouteData['parcel_id'],
//                 weight: generatedWeight,
//               );
//             },
//           ),
//         );

//         return Trip(
//           subroutes: subroutes,
//           routeId: routeData['route_id'],
//           assignedDate: DateTime.parse(routeData['assigned_date']),
//           departureTime: DateTime.parse(routeData['departure_time']),
//           arrivalTime: DateTime.parse(routeData['arrival_time']),
//         );
//       },
//     ),
//   );

//   return routes;
// }

class FirestoreService implements DBClientSocket {
  final db = FirebaseFirestore.instance;
  @override
  Stream<List<Trip>> getRouteStream() async* {
    final subroutesRef = db.collection("subroute");
    print("I am here");
    subroutesRef.snapshots().listen(
      (event) {
        for (var change in event.docChanges) {
          switch (change.type) {
            case DocumentChangeType.added:
              print("New Subroute: ${change.doc.data()}");
              break;
            case DocumentChangeType.modified:
              print("Modified Subroute: ${change.doc.data()}");
              break;
            case DocumentChangeType.removed:
              print("Removed Subroute: ${change.doc.data()}");
              break;
            default:
              print("Unknown route type added");
          }
        }
      },
      onError: (error) => print("Listen failed: $error"),
    );
  }
}
