import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressPin extends StatefulWidget {
  final double lat;
  final double long;
  final String address;

  const AddressPin({
    required this.lat,
    required this.long,
    required this.address,
    super.key,
  });

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<AddressPin> {
  GoogleMapController? mapController;

  late final LatLng _coordinates;
  late final String _address;

  @override
  void initState() {
    super.initState();

    _coordinates = LatLng(widget.lat, widget.long);
    _address = widget.address;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _coordinates,
              zoom: 14.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: {
              Marker(
                markerId: const MarkerId('Client\'s Location'),
                position: _coordinates,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed),
                infoWindow:
                    InfoWindow(title: _address, snippet: 'Client\'s Address'),
              ),
            },
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
          ),

          // Circular button in the top left corner
          Positioned(
            top: 20.0,
            left: 20.0,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 35.0,
                height: 35.0,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: FaIcon(
                    Icons.arrow_back_sharp,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
