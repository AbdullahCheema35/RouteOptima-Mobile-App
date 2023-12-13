import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_optima_mobile_app/services/current_location.dart';
import 'package:route_optima_mobile_app/models/location.dart';

class EmergencyRequestDialog extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedType = 'Puncture'; // Default selected type

  EmergencyRequestDialog({super.key});

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
          return 'Please enter a description';
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
              final requestFuture =
                  _sendEmergencyRequest(descriptionText, currentSelectedType);
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

  void showRequestStatusDialog(BuildContext context, Future<void> futureObj) {
    showDialog(
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
  Future<void> _sendEmergencyRequest(
      String descriptionText, String currentSelectedType) async {
    // Get current timestamp
    DateTime currentTime = DateTime.now();

    // Get device location
    Location? locationObj = await _getLocation();

    // Add emergency report data to Firestore
    DocumentReference? locationRef;
    if (locationObj != null) {
      // Create a new document in the 'location' collection
      DocumentReference locationDoc =
          await FirebaseFirestore.instance.collection('location').add({
        'lat': locationObj.lat,
        'lng': locationObj.long,
      });
      locationRef =
          locationDoc; // Reference to the newly created location document
    }

    // Get the first subroute document in the 'subroutes' collection
    DocumentSnapshot subrouteDoc = await FirebaseFirestore.instance
        .collection('subroute')
        .limit(1)
        .get()
        .then((value) => value.docs.first);

    // Get the data from the subroute document
    Map<String, dynamic> subrouteData =
        subrouteDoc.data() as Map<String, dynamic>;

    // Get the references to the rider, trip and route
    DocumentReference tripRef = subrouteData['tripRef'];
    DocumentReference riderRef = subrouteData['riderRef'];
    DocumentReference subrouteRef = subrouteDoc.reference;

    // Prepare data to be added in the 'emergency_reports' collection
    Map<String, dynamic> emergencyData = {
      'type': currentSelectedType,
      'description': descriptionText,
      'timestamp': currentTime,
      'locationRef': locationObj != null ? locationRef : null,
      'riderRef': riderRef,
      'routeRef': subrouteRef,
      'tripRef': tripRef,
    };

    // Add emergency report data to Firestore in 'emergency_reports' collection
    await FirebaseFirestore.instance
        .collection('emergencyRequest')
        .add(emergencyData);
  }

  // Function to get device's current location using Geolocator package
  Future<Location?> _getLocation() async {
    // Get device's current location
    final currentPos = await getCurrentLocation();

    // Return null if location is not available
    if (currentPos == null) {
      return null;
    }

    // Return location object if location is available
    return Location(
      lat: currentPos.latitude.toString(),
      long: currentPos.longitude.toString(),
    );
  }
}
