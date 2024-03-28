import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoTripsAssigned extends StatelessWidget {
  const NoTripsAssigned({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 100,
        ),
        SizedBox(
          width: double.infinity,
          height: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/images/calendar (6).png', // Replace this with your calendar image path
                width: 150,
                height: 150,
              ),
              Positioned(
                top: 175,
                left: 190,
                child: Image.asset(
                  'assets/images/bag.png', // Replace this with your shopping bag image path
                  width: 100,
                  height: 100,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        Column(
          children: [
            Text(
              'No Trips',
              style: GoogleFonts.roboto(
                fontSize: 28.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'You will be Notified for New Trips',
              style: GoogleFonts.roboto(
                fontSize: 18.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
