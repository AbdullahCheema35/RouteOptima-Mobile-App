// DashboardPage.dart
import 'package:flutter/material.dart';
import 'package:route_optima_mobile_app/charts/distance_barchart.dart';
import 'package:route_optima_mobile_app/charts/ontime_piechart.dart';
import 'package:route_optima_mobile_app/screens/routes.dart';
import 'package:route_optima_mobile_app/services/stat_generator.dart';
import 'package:route_optima_mobile_app/charts/working_hours_barchart.dart';
// import 'package:route_optima_mobile_app/charts/raw_bar_chart.dart';

// class DashboardPage extends StatelessWidget {
//   const DashboardPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Dashboard'),
//       ),
//       body: const SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Pie Chart
//             Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Card(
//                 child: PieChartWidget(),
//               ),
//             ),

//             // Bar Chart 1
//             Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Card(
//                 child: BarChartSample3(),
//               ),
//             ),

//             // Bar Chart 2
//             Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Card(
//                 child: BarChartSample3(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool showMonth = true; // Default value for toggling between month and year
  Map<String, dynamic> currentStatsData =
      monthlyStats; // Default value for stats data (monthly)

  @override
  Widget build(BuildContext context) {
    int onTime = 0;
    int late = 0;
    currentStatsData.forEach((year, data) {
      onTime += data['onTimeDeliveries'] as int;
      late += data['lateDeliveries'] as int;
    });
    final pieChartObject = {'onTimeDeliveries': onTime, 'lateDeliveries': late};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      //Drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Route Optima',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('View Trips'),
              onTap: () {
                // Add navigation logic here
                Navigator.pop(context); // Close the drawer
                // Navigate to View Trips screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('Dashboard'),
              onTap: () {
                // Close the drawer
                Navigator.pop(context);
                // // Add navigation logic here
                // Navigator.pop(context); // Close the drawer
                // // Navigate to Dashboard screen
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => const DashboardPage()),
                // );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      showMonth = !showMonth;
                      currentStatsData = showMonth
                          ? monthlyStats
                          : yearlyStats; // Toggle stats data
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildFilterText(),
                        _buildToggleSwitch(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  children: [
                    const Text(
                      'Average Distance Travelled (km)', // Title text
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DistanceBarChart(
                      isShowingMonth: showMonth,
                      statsData:
                          currentStatsData, // You will pass actual data here
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  children: [
                    const Text(
                      'Average Working Hours', // Title text
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    WorkingHoursBarChart(
                      isShowingMonth: showMonth,
                      statsData:
                          currentStatsData, // You will pass actual data here
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  children: [
                    const Text(
                      'Percentage of On-Time Deliveries', // Title text
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    OnTimeDeliveriesPieChart(
                      statsData:
                          pieChartObject, // You will pass actual data here
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildToggleSwitch() {
  //   return Switch(
  //     value: showMonth,
  //     onChanged: (value) {
  //       setState(() {
  //         showMonth = value;
  //         currentStatsData =
  //             showMonth ? monthlyStats : yearlyStats; // Toggle stats data
  //       });
  //     },
  //     activeColor: Colors.blue, // Change color as needed
  //     inactiveThumbColor: Colors.grey, // Change color as needed
  //     inactiveTrackColor: Colors.grey[300], // Change color as needed
  //     activeTrackColor: Colors.blue[200], // Change color as needed
  //   );
  // }

  Widget _buildToggleSwitch() {
    return Switch(
      value: showMonth,
      onChanged: (value) {
        setState(() {
          showMonth = value;
          currentStatsData =
              showMonth ? monthlyStats : yearlyStats; // Toggle stats data
        });
      },
      activeColor: Colors.blue, // Change color as needed
      inactiveThumbColor: Colors.grey, // Change color as needed
      inactiveTrackColor: Colors.grey[300], // Change color as needed
      activeTrackColor: Colors.blue[200], // Change color as needed
    );
  }

  Widget _buildFilterText() {
    String filterLabel = showMonth ? 'Month' : 'Year';
    return Text(
      'Filter by: $filterLabel',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
