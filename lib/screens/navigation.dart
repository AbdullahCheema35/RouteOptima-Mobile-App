import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_optima_mobile_app/screens/emergency_request_dialog.dart';

class NavigationPage extends StatelessWidget {
  const NavigationPage({super.key});

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
                Navigator.pop(context);
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
      ),
      backgroundColor: Colors.white,
      body: const Center(
        child: Text('Navigation content goes here'),
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
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
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
