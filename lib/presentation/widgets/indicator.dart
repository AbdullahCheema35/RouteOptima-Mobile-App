import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    this.isSquare = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          margin: EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: color,
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
          ),
        ),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
