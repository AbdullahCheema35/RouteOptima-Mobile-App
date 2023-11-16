import 'package:flutter/material.dart';
import 'package:route_optima_mobile_app/models/trip.dart';
import 'package:route_optima_mobile_app/models/subroute.dart';
import 'package:route_optima_mobile_app/models/months.dart';
import 'package:route_optima_mobile_app/screens/subroute_details.dart';

class SubRoutesScreen extends StatelessWidget {
  const SubRoutesScreen({super.key, required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.blue, // Change the background color
      //   automaticallyImplyLeading: false,
      //   title: Row(
      //     mainAxisSize: MainAxisSize.max,
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //       Column(
      //         mainAxisSize: MainAxisSize.max,
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           IconButton(
      //             // Remove FlutterFlowIconButton
      //             icon: const Icon(
      //               Icons.arrow_back_rounded,
      //               color: Colors.white, // Change the icon color
      //               size: 30,
      //             ),
      //             onPressed: () {
      //               print('IconButton pressed ...');
      //             },
      //           ),
      //         ],
      //       ),
      //       const Padding(
      //         padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
      //         child: Column(
      //           mainAxisSize: MainAxisSize.max,
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Text(
      //               'Subroutes',
      //               style: TextStyle(
      //                 fontSize: 24, // Change the font size
      //                 color: Colors.white, // Change the text color
      //                 fontWeight: FontWeight.bold, // Add font weight
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      //   actions: const [],
      //   centerTitle: false,
      //   elevation: 2,
      // ),
      appBar: AppBar(
        title: const Text('Parcels'),
      ),
      // Add the rest of your app content here
      body: buildSubroutesBody(trip, context),
    );
  }
}

Widget buildSubroutesBody(Trip trip, BuildContext context) {
  return SingleChildScrollView(
    child: Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        subRoutesBodyHeading(trip),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 24),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: trip.subroutes.map((subRoute) {
              return singleSubRouteContainer(subRoute, context);
            }).toList(),
          ),
        ),
      ],
    ),
  );
}

Widget subRoutesBodyHeading(Trip trip) {
  return Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(24, 4, 24, 0),
    child: Text(
      'Following are the parcels for ${getMonthShortName(trip.assignedDate.month)} ${trip.assignedDate.day}, ${trip.assignedDate.year}',
      textAlign: TextAlign.start,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget singleSubRouteContainer(Subroute subroute, BuildContext context) {
  return Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
    child: InkWell(
      onTap: () {
        // Navigate to the Subroute Details Screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SubrouteDetailsScreen(subroute: subroute),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.black26,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 4),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Id: ${subroute.parcelId}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text(
                        'Address: ${subroute.customer.address}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 0),
                      child: IntrinsicWidth(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                '${subroute.weight.toStringAsFixed(2)} kg',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                      child: Text(
                        // Extract just the time from the DateTime object
                        subroute.arrivalTime.substring(11, 16),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade400,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                      child: Container(
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                12, 0, 12, 0),
                            child: Text(
                              subroute.status,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}


// Widget buildSubroutesBody() {
//   return SingleChildScrollView(
//     child: Column(
//       mainAxisSize: MainAxisSize.max,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         subRoutesBodyHeading(),
//         Padding(
//           padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 24),
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               singleSubRouteContainer(),
//               singleSubRouteContainer(),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget subRoutesBodyHeading() {
//   return const Padding(
//     padding: EdgeInsetsDirectional.fromSTEB(24, 4, 24, 0),
//     child: Text(
//       'Following are the parcels for 3rd Nov, 2023',
//       textAlign: TextAlign.start,
//       style: TextStyle(
//         fontSize: 24, // Adjust the font size
//         fontWeight: FontWeight.bold, // Adjust the font weight
//       ),
//     ),
//   );
// }

// Widget singleSubRouteContainer() {
//   return Padding(
//     padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
//     child: Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: Colors.black,
//           width: 2,
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 4),
//         child: Row(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               flex: 2,
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   RichText(
//                     text: const TextSpan(
//                       children: [
//                         TextSpan(
//                           text: 'Order #: ',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         TextSpan(
//                           text: '429242424',
//                           style: TextStyle(
//                             color: Colors.blue,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const Padding(
//                     padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
//                     child: Text(
//                       'Address: House 5, Bilal Park, Muradabad Colony, Near Rahat Bakers, University Road, Sargodha, Punjab, Pakistan.',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.black,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   Padding(
//                     padding:
//                         const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
//                     child: IntrinsicWidth(
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color:
//                               Colors.blue, // Set your desired background color
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color:
//                                 Colors.black, // Set your desired border color
//                             width: 2,
//                           ),
//                         ),
//                         child: const Padding(
//                           padding:
//                               EdgeInsets.all(6), // Add padding between elements
//                           child: Align(
//                             alignment: Alignment.center,
//                             child: Text(
//                               '2.5 lbs',
//                               style: TextStyle(
//                                 fontSize: 16, // Set your desired font size
//                                 color:
//                                     Colors.black, // Set your desired text color
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 16), // Add space between columns
//             Expanded(
//               flex: 1,
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   const Padding(
//                     padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
//                     child: Text(
//                       '\$1.50',
//                       textAlign: TextAlign.end,
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
//                     child: Container(
//                       height: 32,
//                       decoration: BoxDecoration(
//                         color: Colors.blue,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: Colors.black,
//                           width: 2,
//                         ),
//                       ),
//                       child: const Align(
//                         alignment: Alignment.center,
//                         child: Padding(
//                           padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
//                           child: Text(
//                             'Shipped',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
