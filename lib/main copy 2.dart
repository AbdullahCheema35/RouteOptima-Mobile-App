import 'package:flutter/material.dart';
// import 'package:route_optima_mobile_app/presentation/sample/sample_pie_chart.dart';
import 'package:route_optima_mobile_app/screens/dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Pie Chart Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Pie Chart Example'),
      ),
      body: Center(
        child: DashboardPage(),
      ),
    );
  }
}
