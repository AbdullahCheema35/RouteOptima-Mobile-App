import 'package:flutter/material.dart';

void main() {
  runApp(RouteOptimaApp());
}

class RouteOptimaApp extends StatelessWidget {
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
  final List<Map<String, bool>> parcels = [
    {
      'delivered': true,
    },
    {
      'delivered': false,
    },
    {
      'delivered': true,
    },
    {
      'delivered': false,
    },
    // Add more parcels as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parcel List'),
      ),
      body: ListView.builder(
        itemCount: parcels.length,
        itemBuilder: (BuildContext context, int index) {
          return buildParcelContainer(parcels[index], index);
        },
      ),
    );
  }

  Widget buildParcelContainer(Map<String, bool> parcel, int idx) {
    return Container(
      height: 100, // Fixed height for each parcel container
      width: double.infinity, // Occupy all screen width
      padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
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
          SizedBox(width: 12.0), // Add spacing between the columns

          // Right column with parcel details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Receiver: John Doe', // Replace with actual receiver name
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.0),
                Text('Address: 123 Main St'), // Replace with actual address
                SizedBox(height: 4.0),
                Text('Delivery Time: 10:00 AM'), // Replace with actual time
              ],
            ),
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
