import 'package:flutter/material.dart';
import 'package:route_optima_mobile_app/screens/emergency_request_dialog.dart';

class NavigationPage extends StatelessWidget {
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Page'),
      ),
      body: const Center(
        child: Text('Your main content here...'),
      ),
      floatingActionButton: const ReportEmergencyButton(),
    );
  }
}

class ReportEmergencyButton extends StatelessWidget {
  const ReportEmergencyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return EmergencyRequestDialog();
          },
        );
      },
      tooltip: 'Report Emergency',
      child: const Icon(Icons.report_problem),
    );
  }
}
