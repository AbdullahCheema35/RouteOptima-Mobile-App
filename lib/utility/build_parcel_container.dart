import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:route_optima_mobile_app/conversion/time.dart';
import 'package:route_optima_mobile_app/models/parcel.dart';
import 'package:route_optima_mobile_app/screens/parcel_details_screen.dart';
import 'package:route_optima_mobile_app/services/line_painter.dart';

Widget buildParcelContainer(
    BuildContext context, Parcel parcel, int idx, List<Parcel> parcels) {
  return Container(
    height: 100, // Fixed height for each parcel container
    width: double.infinity, // Occupy all screen width
    padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
    child: Row(
      children: [
        // Left column with circles and lines
        SizedBox(
          width: 40.0, // Width for the left column
          child: CustomPaint(
            painter: LinePainter(
                length: parcels.length,
                index: parcel.status == 'pending' ? -1 : idx),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 20.0,
                  height: 20.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: parcel.status == 'delivered'
                        ? Colors.green
                        : parcel.status == 'unavailable'
                            ? Colors.red
                            : Colors.black,
                  ),
                  child: Center(
                    child: FaIcon(
                      parcel.status == 'delivered'
                          ? FontAwesomeIcons.check
                          : parcel.status == 'unavailable'
                              ? FontAwesomeIcons.xmark
                              : FontAwesomeIcons.solidCircle,
                      color: isCurrentParcel(parcel, idx, parcels)
                          ? Colors.amber[400]
                          : Colors.white,
                      size: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 4.0), // Add spacing between the columns
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              extractTime(parcel.dueTime),
              style: const TextStyle(
                  fontFamily: 'Roboto'), // Apply GoogleFont('Roboto')
            ),
          ],
        ),

        const SizedBox(width: 12.0), // Add spacing between the columns

        // Right column with parcel details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                parcel.name, // Replace with actual receiver name
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto', // Apply GoogleFont('Roboto')
                ),
              ),
              const SizedBox(height: 4.0),
              Row(
                children: [
                  const FaIcon(
                    FontAwesomeIcons.bagShopping,
                    size: 18.0,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    '1 item',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.grey[600]), // Apply GoogleFont('Roboto')
                  ),
                ],
              ),
              const SizedBox(height: 4.0),
              Text(
                parcel.address,
                style: const TextStyle(
                    fontFamily: 'Roboto'), // Apply GoogleFont('Roboto')
              ),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                // Show Parcel Details
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ParcelDetailsScreen(parcel),
                  ),
                );
              },
              icon: const FaIcon(
                FontAwesomeIcons.chevronRight,
              ),
              color: Colors.black,
            ),
          ],
        ),
      ],
    ),
  );
}

bool isCurrentParcel(Parcel parcel, int idx, List<Parcel> parcels) {
  if (parcel.status != 'pending') {
    return false;
  }
  // It means current parcel's status is pending

  // Check if the current parcel is the first parcel
  if (idx == 0) {
    return true;
  }

  // Check if the previous parcel is not pending
  if (idx - 1 > 0 && parcels[idx - 1].status != 'pending') {
    return true;
  }

  return false;
}
