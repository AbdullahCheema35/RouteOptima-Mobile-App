import 'package:flutter/material.dart';

class NavButton extends StatelessWidget {
  const NavButton(
      {required this.autoCameraFocusEnabled,
      required this.cameraToPositionCallback,
      super.key});

  // Add a boolean variable to toggle the camera focus
  final bool autoCameraFocusEnabled;

  // Add a function to toggle the camera focus
  final void Function() cameraToPositionCallback;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      backgroundColor: Colors.black,
      foregroundColor: const Color.fromARGB(255, 239, 225, 225),
      onPressed: cameraToPositionCallback,
      tooltip: 'Show Current Location',
      child: autoCameraFocusEnabled
          ? // Material Design Icon
          const Icon(
              Icons.location_disabled_outlined,
            )
          : const Icon(
              Icons.my_location_outlined,
            ),
    );
  }
}
