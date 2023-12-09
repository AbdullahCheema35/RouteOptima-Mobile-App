import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const RouteOptimaApp());
}

class RouteOptimaApp extends StatelessWidget {
  const RouteOptimaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Route Optima',
      debugShowCheckedModeBanner: false,
      home: ParcelDetailsScreen(),
    );
  }
}

class ParcelDetailsScreen extends StatelessWidget {
  const ParcelDetailsScreen({super.key});

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
              },
              icon: const FaIcon(
                FontAwesomeIcons.angleLeft,
                size: 24,
                color: Colors.black,
              ),
            ),
            Text(
              'Back',
              style: GoogleFonts.getFont(
                'Roboto',
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
              'IN PROGRESS',
              style: GoogleFonts.getFont('Roboto Mono',
                  color: Colors.yellow.shade800,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
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
            // // Show status of the parcel
            // const Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     Text(
            //       'IN PROGRESS',
            //       style: TextStyle(
            //           fontSize: 18.0,
            //           color: Colors.amber,
            //           fontWeight: FontWeight.bold),
            //     ),
            //   ],
            // ),

            // const SizedBox(
            //   height: 32.0,
            // ),

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
              'Muhammad Abdullah',
              style: GoogleFonts.getFont('Roboto',
                  fontSize: 24.0, fontWeight: FontWeight.bold),
            ),

            // Address
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '123 Main St, City, Country',
                style: GoogleFonts.getFont('Roboto',
                    fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 24.0),

            // const Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Icon(
            //       Icons.access_time_rounded,
            //       size: 40.0,
            //     ),
            //     SizedBox(width: 16.0),
            //     Text(
            //       '12:00 PM',
            //       style: TextStyle(fontSize: 16.0),
            //     ),
            //   ],
            // ),

            // const SizedBox(height: 16.0),

            // const Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Icon(
            //       Icons.receipt_outlined,
            //       size: 40.0,
            //     ),
            //     SizedBox(width: 16.0),
            //     Text(
            //       'qeqeqw456',
            //       style: TextStyle(fontSize: 16.0),
            //     ),
            //   ],
            // ),

            // const SizedBox(height: 24.0),

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
                    const Text('LOCATION'),
                  ],
                ),

                // Phone call button
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle phone call button pressed
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
                    const Text('CALL'),
                  ],
                ),

                // Message button
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle message button pressed
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
                        FontAwesomeIcons.solidMessage,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const Text('SMS'),
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
              style: GoogleFonts.getFont(
                'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 18.0,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
