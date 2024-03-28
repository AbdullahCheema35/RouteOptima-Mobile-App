import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_optima_mobile_app/utility/build_parcel_container.dart';
import 'package:route_optima_mobile_app/screens/assigned_trips.dart';
import 'package:route_optima_mobile_app/screens/navigation.dart';
import 'package:route_optima_mobile_app/services/assignment_stream_provider.dart';
import 'package:route_optima_mobile_app/services/rider_selection.dart';

class AssignedParcelList extends ConsumerWidget {
  const AssignedParcelList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<DocumentSnapshot> assignmentSnapshot =
        ref.watch(assignmentStreamProvider);

    return assignmentSnapshot.when(
      data: (assignmentData) {
        print(assignmentData);
        if (!assignmentData.exists) {
          // Bigger and stylish font for the message
          return const Center(
            // Bigger and stylish font for the message
            child: Text(
              'No Parcels Found :)',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else {
          final rawParcelsList =
              (assignmentData.data()! as Map<String, dynamic>)['parcels'];
          final parcelsList = createParcelListFromResponse(rawParcelsList);

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: parcelsList.length + 2,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == parcelsList.length + 1) {
                      return const SizedBox(height: 40.0);
                    } else if (index == 0) {
                      return const SizedBox(height: 20.0);
                    } else {
                      return buildParcelContainer(
                        context,
                        parcelsList[index - 1],
                        index - 1,
                        parcelsList,
                      );
                    }
                  },
                ),
              ),
              // Render a widget in the bottom center of the screen
              Visibility(
                visible: true,
                child: Positioned(
                  bottom: 16.0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: FloatingActionButton.extended(
                      heroTag: null,
                      onPressed: () {
                        final userId = ref.read(riderNotifierProvider).id;

                        // Implement functionality for Start Trip button
                        // Show Parcel Details
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NavigationPage(
                              userId: userId,
                            ),
                          ),
                        );
                      },
                      label: Text(
                        'Show Path',
                        style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
                      ),
                      // FontAwesome Icon replaced here
                      icon: const FaIcon(FontAwesomeIcons.route),
                      backgroundColor:
                          Colors.black, // Customize the background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, _) => Center(
        child: Text('Error: $error'),
      ),
    );
  }
}
