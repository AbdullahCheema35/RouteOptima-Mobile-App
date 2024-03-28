import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:route_optima_mobile_app/conversion/time.dart';
import 'package:route_optima_mobile_app/models/parcel.dart';
import 'package:route_optima_mobile_app/screens/point_address.dart';
import 'package:route_optima_mobile_app/utility/dialer.dart';
import 'package:route_optima_mobile_app/utility/sms.dart';

class ParcelDetailsScreen extends StatelessWidget {
  const ParcelDetailsScreen(this.parcel, {super.key});

  final Parcel parcel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leadingWidth: 100.0,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                // Implement the back functionality here
                Navigator.pop(context);
              },
              icon: const FaIcon(
                FontAwesomeIcons.chevronLeft,
                color: Colors.black,
              ),
            ),
            Text(
              'Back',
              style: GoogleFonts.roboto(
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              parcel.status == 'pending'
                  ? 'PENDING'
                  : parcel.status == 'delivered'
                      ? "DELIVERED"
                      : "UNAVAILABLE",
              style: GoogleFonts.roboto(
                color: parcel.status == 'pending'
                    ? Colors.yellow.shade800
                    : parcel.status == 'delivered'
                        ? Colors.green
                        : Colors.red,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50, // Adjust the size of the circular avatar
              backgroundImage: AssetImage(
                  'assets/images/uifaces-human-image.jpg'), // Replace with your image path
            ),

            // Sized Box
            const SizedBox(
              height: 20,
            ),

            // Name of the client
            Text(
              parcel.name,
              style: GoogleFonts.roboto(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Address
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                parcel.address,
                style: GoogleFonts.roboto(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 24.0),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Map button
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle map button pressed

                        if (parcel.lat == null || parcel.long == null) {
                          // Handle error
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddressPin(
                              lat: parcel.lat!,
                              long: parcel.long!,
                              address: parcel.address,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size.square(60.0),
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12.0), // Rounded corners
                        ),
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.locationDot,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      'ADDRESS',
                      style: TextStyle(
                          fontFamily: 'Roboto'), // Apply GoogleFont('Roboto')
                    ),
                  ],
                ),

                // Phone call button
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle phone call button pressed
                        launchDialer(parcel.phone);
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size.square(60.0),
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12.0), // Rounded corners
                        ),
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.phone,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      'CALL',
                      style: TextStyle(
                          fontFamily: 'Roboto'), // Apply GoogleFont('Roboto')
                    ),
                  ],
                ),

                // Message button
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle message button pressed
                        launchSMS(parcel.phone);
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size.square(60.0),
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12.0), // Rounded corners
                        ),
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.solidEnvelope,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      'SMS',
                      style: TextStyle(
                          fontFamily: 'Roboto'), // Apply GoogleFont('Roboto')
                    ),
                  ],
                ),
              ],
            ),
            // Styled Divider
            Container(
              margin: const EdgeInsets.symmetric(vertical: 24.0),
              height: 4.0,
              decoration: BoxDecoration(
                color: Colors.grey[300], // Adjust color as needed
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
            (parcel.status == 'pending' || parcel.status == 'unavailable')
                ? pendingOrUnavailable()
                : receivingDetails(parcel),
          ],
        ),
      ),
    );
  }
}

Widget pendingOrUnavailable() {
  return Column(
    children: [
      Transform.rotate(
        angle: 0.7,
        child: Image.asset(
          'assets/images/sand-clock.png', // Replace with your hourglass image path
          width: 120, // Adjust the width of the image
          height: 200, // Adjust the height of the image
        ),
      ),
      Text(
        'Awaiting Delivery',
        style: GoogleFonts.roboto(
          fontWeight: FontWeight.w400,
          fontSize: 18.0,
          color: Colors.black45,
        ),
      ),
    ],
  );
}

Widget receivingDetails(Parcel parcel) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(
        children: [
          Text(
            'Receiving Details:',
            style: GoogleFonts.roboto(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 16.0,
      ),
      Row(
        children: [
          Text(
            'Received By: ${parcel.receivedBy}',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w400,
              fontSize: 18.0,
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 12.0,
      ),
      Row(
        children: [
          Text(
            'Delivered at: ${extractTime(parcel.deliveredTime)}',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w400,
              fontSize: 18.0,
            ),
          ),
        ],
      ),
    ],
  );
}
