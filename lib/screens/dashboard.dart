// DashboardPage.dart
import 'package:flutter/material.dart';
import 'package:route_optima_mobile_app/charts/bar_chart.dart';
import 'package:route_optima_mobile_app/charts/pie_chart.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Pie Chart
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: PieChartWidget(),
              ),
            ),

            // Bar Chart 1
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: BarChartSample3(),
              ),
            ),

            // Bar Chart 2
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: BarChartSample3(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
