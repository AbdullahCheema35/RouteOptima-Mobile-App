import 'package:flutter/material.dart';

void main() {
  runApp(const RouteOptimaApp());
}

class RouteOptimaApp extends StatelessWidget {
  const RouteOptimaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Route Optima',
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
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Parcels List'),
      ),
      backgroundColor: Colors.grey.shade200,
      body: ListView.builder(
        itemCount: parcels.length,
        itemBuilder: (BuildContext context, int index) {
          return buildParcelContainer(parcels[index], index);
        },
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
              child: Center(
                child: Container(
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
              ),
            ),
          ),
          // const SizedBox(width: 12.0), // Add spacing between the columns
          Container(
            width: 40.0, // Width for the left column
            child: const Text('12:00'),
          ),

          const SizedBox(width: 12.0), // Add spacing between the columns

          // Right column with parcel details
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'John Doe', // Replace with actual receiver name
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                    '123 Main St, City, Country'), // Replace with actual address
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.navigate_next_rounded),
            color: Colors.blue.shade900,
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
    print(index);
    print(length);

    double topOffset = index > 0 ? 0 : size.height / 2;
    double bottomOffset = index < length - 1 ? size.height : size.height / 2;

    // print(topOffset);
    // print(bottomOffset);

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
