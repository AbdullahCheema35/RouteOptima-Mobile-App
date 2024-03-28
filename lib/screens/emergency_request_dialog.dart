import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_optima_mobile_app/gmapPages/firestore_services.dart';

class EmergencyRequestDialog extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedType = 'Puncture'; // Default selected type

  EmergencyRequestDialog({required this.request, required this.ref, super.key});
  final EmergencyRequestType request;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Report Emergency',
        style: GoogleFonts.roboto(),
      ),
      content: _buildDialogContent(context),
    );
  }

  // Function to build the content of the dialog
  Widget _buildDialogContent(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTypeDropdown(),
          const SizedBox(height: 10),
          _buildDescriptionTextField(),
          _buildDialogButtons(context),
        ],
      ),
    );
  }

// Widget for dropdown to select emergency type
  Widget _buildTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedType,
      items: <String>['Puncture', 'Accident', 'Road Closure', 'Other']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: GoogleFonts.roboto(), // Apply GoogleFont('Roboto')
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          _selectedType = newValue;
        }
      },
      decoration: const InputDecoration(
        labelText: 'Type',
        border: OutlineInputBorder(),
      ),
    );
  }

// Widget for description text field
  Widget _buildDescriptionTextField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'Description',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some description';
        }
        return null;
      },
      style: GoogleFonts.roboto(), // Apply GoogleFont('Roboto')
    );
  }

// Widget for dialog action buttons (Send and Cancel)
  Widget _buildDialogButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style:
                TextStyle(fontFamily: 'Roboto'), // Apply GoogleFont('Roboto')
          ),
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final descriptionText = _descriptionController.text;
              final currentSelectedType = _selectedType;
              // Update EmergencyRequestType object with the new data
              request.type = currentSelectedType;
              request.description = descriptionText;
              final requestFuture = uploadEmergencyRequest(
                  request.riderId, request, ref); // Send emergency request
              showRequestStatusDialog(context, requestFuture);
              _formKey.currentState!.reset();
            }
          },
          child: const Text(
            'Send',
            style:
                TextStyle(fontFamily: 'Roboto'), // Apply GoogleFont('Roboto')
          ),
        ),
      ],
    );
  }

  Future<void> showRequestStatusDialog(
      BuildContext context, Future<void> futureObj) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Sending Emergency Request',
            style: GoogleFonts.roboto(), // Apply GoogleFont('Roboto')
          ),
          content: FutureBuilder(
            future: futureObj,
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        strokeWidth: 4, // Adjust the thickness of the circle
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Please wait...',
                      style: GoogleFonts.roboto(), // Apply GoogleFont('Roboto')
                    ),
                  ],
                );
              } else if (snapshot.connectionState == ConnectionState.done &&
                  !snapshot.hasError) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.circleCheck,
                      color: Colors.green,
                      size: 50,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Emergency Request Sent Successfully',
                      style: GoogleFonts.roboto(), // Apply GoogleFont('Roboto')
                    ),
                  ],
                );
              } else {
                return Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontFamily: 'Roboto', // Apply GoogleFont('Roboto')
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  // Function to send emergency report to Firestore
  Future<void> _sendEmergencyRequest(EmergencyRequestType request) async {
    // Get Current Timestamp
    request.timestamp = DateTime.now();

    // Add emergency report data to Firestore in 'emergenctRequest' collection
    await FirebaseFirestore.instance.collection('emergencyRequest').add(
          request.toJson(),
        );
  }
}

// New Emergency Request Type
class EmergencyRequestType {
  String? type;
  String? description;
  DateTime? timestamp;
  final LatLng geoTag;
  final int polylineId;
  final List<dynamic> currentRoute;
  final List<dynamic> allRoutes;
  final String riderId;
  final LatLng srcLoc;
  final LatLng destLoc;

  EmergencyRequestType({
    this.type,
    this.description,
    this.timestamp,
    required this.geoTag,
    required this.currentRoute,
    required this.allRoutes,
    required this.riderId,
    required this.srcLoc,
    required this.destLoc,
    required this.polylineId,
  });

  Map<String, dynamic> latLngToJson(LatLng coord) {
    return {
      'lat': coord.latitude,
      'long': coord.longitude,
    };
  }

  // Function to convert EmergencyRequestType object to Json
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'description': description,
      'timestamp': timestamp,
      'geoTag': {
        'lat': geoTag.latitude,
        'long': geoTag.longitude,
      },
      'currentRoute': currentRoute,
      'allRoutes': allRoutes,
      'riderId': riderId,
      'srcLoc': {
        'lat': srcLoc.latitude,
        'long': srcLoc.longitude,
      },
      'destLoc': {
        'lat': destLoc.latitude,
        'long': destLoc.longitude,
      },
      'polylineId': polylineId,
    };
  }
}
