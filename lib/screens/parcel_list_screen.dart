import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:route_optima_mobile_app/screens/assigned_parcel_list.dart';
import 'package:route_optima_mobile_app/screens/completed_parcel_list.dart';

class ParcelListPage extends ConsumerWidget {
  const ParcelListPage({
    required this.parcelRefs,
    this.isAssignedList = false,
    super.key,
  });

  final List<DocumentReference> parcelRefs;
  final bool isAssignedList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
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
                FontAwesomeIcons.chevronLeft,
                color: Colors.black,
              ),
            ),
            Text(
              'Back',
              style: GoogleFonts.roboto(
                fontSize: 20.0,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: isAssignedList
          ? const AssignedParcelList()
          : CompletedParceslList(parcelRefs: parcelRefs),
    );
  }
}
