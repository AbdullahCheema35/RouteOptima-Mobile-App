import 'package:flutter/material.dart';

void main() {
  runApp(const RouteOptimaApp());
}

class RouteOptimaApp extends StatelessWidget {
  const RouteOptimaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Route Optima',
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
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Parcel Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Show status of the parcel
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'IN PROGRESS',
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.amber,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(
              height: 52.0,
            ),

            // Name of the client
            const Text(
              'Muhammad Abdullah Cheema',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 24.0),

            // Address
            const Text(
              '123 Main St, City, Country',
              style: TextStyle(fontSize: 16.0),
            ),

            const SizedBox(height: 24.0),

            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 40.0,
                ),
                SizedBox(width: 16.0),
                Text(
                  '12:00 PM',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),

            const SizedBox(height: 16.0),

            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_outlined,
                  size: 40.0,
                ),
                SizedBox(width: 16.0),
                Text(
                  'qeqeqw456',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
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
                      child: const Icon(Icons.location_pin),
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
                      child: const Icon(Icons.call),
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
                      child: const Icon(Icons.sms),
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
              height: 2.0,
              decoration: BoxDecoration(
                color: Colors.grey[300], // Adjust color as needed
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
