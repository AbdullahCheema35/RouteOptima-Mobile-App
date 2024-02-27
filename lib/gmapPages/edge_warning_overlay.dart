import 'package:flutter/material.dart';

class EdgeWarningOverlay extends StatelessWidget {
  const EdgeWarningOverlay({required this.isOnPath, super.key});

  final bool isOnPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isOnPath ? Colors.green : Colors.red,
    );
  }
}
