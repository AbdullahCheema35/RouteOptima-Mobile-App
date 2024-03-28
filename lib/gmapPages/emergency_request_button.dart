import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:route_optima_mobile_app/screens/emergency_request_dialog.dart';

class EmergencyRequestButton extends StatelessWidget {
  const EmergencyRequestButton(
      {required this.request, required this.ref, super.key});

  final EmergencyRequestType request;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return EmergencyRequestDialog(
              request: request,
              ref: ref,
            );
          },
        );
      },
      tooltip: 'Report Emergency',
      child: const FaIcon(
        FontAwesomeIcons.triangleExclamation,
      ),
    );
  }
}
