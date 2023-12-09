import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const RouteOptimaApp());
}

class RouteOptimaApp extends StatelessWidget {
  const RouteOptimaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Route Optima',
      debugShowCheckedModeBanner: false,
      home: ParcelListPage(),
    );
  }
}

class ParcelListPage extends StatelessWidget {
  // Example list of parcels
  final List<Map<String, dynamic>> parcels = [
    {
      'delivered': true,
      'time': '11:30 AM',
    },
    {
      'delivered': false,
      'time': '12:00 PM',
    },
    {
      'delivered': true,
      'time': '12:00 PM',
    },
    {
      'delivered': false,
      'time': '12:00 PM',
    },
    // Add more parcels as needed
  ];

  ParcelListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
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
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                '3 OF 8 COMPLETED',
                style: GoogleFonts.getFont('Roboto',
                    color: const Color.fromRGBO(0, 0, 0, 0.867),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: parcels.length,
          itemBuilder: (BuildContext context, int index) {
            return buildParcelContainer(parcels[index], index);
          },
        ),
      ),
    );
  }

  Widget buildParcelContainer(Map<String, dynamic> parcel, int idx) {
    return Container(
      height: 100, // Fixed height for each parcel container
      width: double.infinity, // Occupy all screen width
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Row(
        children: [
          // Left column with circles and lines
          Container(
            width: 40.0, // Width for the left column
            child: CustomPaint(
              painter: LinePainter(length: parcels.length, index: idx),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 20.0,
                    height: 20.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: parcel['delivered']! ? Colors.green : Colors.red,
                    ),
                    child: Center(
                      child: Icon(
                        parcel['delivered']! ? Icons.check : Icons.close,
                        color: Colors.white,
                        size: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 4.0), // Add spacing between the columns
          const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('12:00 PM'),
            ],
          ),

          const SizedBox(width: 12.0), // Add spacing between the columns

          // Right column with parcel details
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'John Doe', // Replace with actual receiver name
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.0),
                Row(
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 18.0,
                    ),
                    SizedBox(width: 4.0),
                    Text('1 item'),
                  ],
                ),
                SizedBox(height: 4.0),
                Text(
                    '123 Main St, City, Country'), // Replace with actual address
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.navigate_next_rounded),
                color: Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final int length;
  final int index;

  LinePainter({required this.length, required this.index});

  @override
  void paint(Canvas canvas, Size size) {
    double topOffset = 0.0;
    double bottomOffset = index < length - 1 ? size.height : 0;

    final Paint paint = Paint()
      ..color = Colors.black // Change the color as desired
      ..strokeWidth = 1.0;

    canvas.drawLine(
      Offset(size.width / 2, topOffset),
      Offset(size.width / 2, bottomOffset),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
