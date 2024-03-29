// DashboardPage.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_optima_mobile_app/charts/distance_barchart.dart';
import 'package:route_optima_mobile_app/charts/ontime_piechart.dart';
import 'package:route_optima_mobile_app/screens/drawer_widget.dart';
import 'package:route_optima_mobile_app/services/rider_selection.dart';
import 'package:route_optima_mobile_app/services/stat_generator.dart';
import 'package:route_optima_mobile_app/charts/working_hours_barchart.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends ConsumerState<DashboardPage> {
  final _drawerTileIndex = 1;
  bool showMonth = true; // Default value for toggling between month and year
  Map<String, dynamic> currentStatsData =
      monthlyStats; // Default value for stats data (monthly)

  @override
  Widget build(BuildContext context) {
    final riderName = ref.watch(riderNotifierProvider).name;

    int onTime = 0;
    int late = 0;
    currentStatsData.forEach((year, data) {
      onTime += data['onTimeDeliveries'] as int;
      late += data['lateDeliveries'] as int;
    });
    final pieChartObject = {'onTimeDeliveries': onTime, 'lateDeliveries': late};

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 24.0,
            fontFamily: 'Roboto', // Apply 'Roboto' font
          ),
        ),
      ),
      //Drawer
      drawer: routeOptimaDrawerWidget(context, _drawerTileIndex, riderName),
      //body
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
                    Text(
                      'Average Distance Travelled (km)', // Title text
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto', // Apply 'Roboto' font
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
                    Text(
                      'Average Working Hours', // Title text
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto', // Apply 'Roboto' font
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
                    Text(
                      'Percentage of On-Time Deliveries', // Title text
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto', // Apply 'Roboto' font
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
        fontFamily: 'Roboto', // Apply 'Roboto' font
      ),
    );
  }
}
