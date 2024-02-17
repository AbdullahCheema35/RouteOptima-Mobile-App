import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:route_optima_mobile_app/gmapPages/proximity_button.dart';
import 'package:route_optima_mobile_app/googleMapConsts.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Location _locationController = Location();

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  static const LatLng _pGooglePlex = LatLng(37.4223, -122.0848);
  static const LatLng _pApplePark = LatLng(37.3346, -122.0090);
  LatLng? _currentP;

  Map<PolylineId, Polyline> polylines = {};

  // Additional attributes for timer and last uploaded location and Duration of the timer
  // LatLng? _lastUploadedLocation; // Track the last uploaded location
  late Timer _locationUpdateTimer; // Timer for periodic updates
  static const int locationUploadInterval =
      10; // Duration of the timer in seconds

  // Attribute to conditionally reder the proximity button
  bool _inProximity = false;

  // Proximity radius threshold in meters
  static const double proximityThreshold = 500.0;

  @override
  void initState() {
    super.initState();

    // Set up a timer to update the location every timerDuration seconds
    _locationUpdateTimer = Timer.periodic(
        const Duration(seconds: locationUploadInterval), (timer) {
      if (_currentP != null) {
        updateFirestoreLocation(_currentP!);
      }
    });

    getLocationUpdates().then(
      (_) => {
        getPolylinePoints().then((coordinates) {
          // Generate polyline and store in Firestore
          generatePolyLineFromPoints(coordinates);
          updateFirestorePolyline(coordinates);
        }),
      },
    );
  }

  // Cancel the timer when the widget is disposed
  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _locationUpdateTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _currentP == null
        ? const Center(
            child: Text("Loading..."),
          )
        : Stack(
            children: [
              GoogleMap(
                onMapCreated: ((GoogleMapController controller) =>
                    _mapController.complete(controller)),
                initialCameraPosition: const CameraPosition(
                  target: _pGooglePlex,
                  zoom: 13,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId("_currentLocation"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: _currentP!,
                  ),
                  const Marker(
                      markerId: MarkerId("_sourceLocation"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: _pGooglePlex),
                  const Marker(
                      markerId: MarkerId("_destionationLocation"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: _pApplePark)
                },
                polylines: Set<Polyline>.of(polylines.values),
              ),
              // Render the proximity button if the rider is in proximity
              if (_inProximity) renderProximityButton(context),
            ],
          );
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition newCameraPosition = CameraPosition(
      target: pos,
      zoom: 13,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(newCameraPosition),
    );
  }

  Future<void> getLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        final newP =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);

        // Calculate the distance between the current location and the destination
        double distance = calculateDistance(
          newP,
          _pApplePark,
        );

        setState(() {
          _currentP = newP;
          _cameraToPosition(_currentP!);

          // Check if the rider is in proximity
          _inProximity = distance <= proximityThreshold;
        });
      }
    });
  }

  Future<void> updateFirestoreLocation(LatLng currentLocation) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference locations = firestore.collection('riderLocation');

    // Specify the document ID you want to update
    DocumentReference documentRef = locations.doc('46ACIEbnlM4N8dGez77b');

    // Use the update method to only update the specified fields
    documentRef.update({
      'lat': currentLocation.latitude,
      'long': currentLocation.longitude,
    });
  }

  Future<void> updateFirestorePolyline(List<LatLng> polylineCoordinates) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference polylines = firestore.collection('riderLocation');

    // Specify the document ID you want to update
    DocumentReference documentRef = polylines.doc('46ACIEbnlM4N8dGez77b');

    // Update Firestore with polyline coordinates
    documentRef.update({
      'polyline': polylineCoordinates
          .map((latLng) => {
                'lat': latLng.latitude,
                'long': latLng.longitude,
              })
          .toList(),
    });
  }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GOOGLE_MAPS_API_KEY,
      PointLatLng(_pGooglePlex.latitude, _pGooglePlex.longitude),
      PointLatLng(_pApplePark.latitude, _pApplePark.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      print(result.errorMessage);
    }
    return polylineCoordinates;
  }

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.black,
        points: polylineCoordinates,
        width: 8);
    setState(() {
      polylines[id] = polyline;
    });
  }
}
