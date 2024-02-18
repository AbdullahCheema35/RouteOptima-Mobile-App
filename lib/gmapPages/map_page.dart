import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:route_optima_mobile_app/gmapPages/proximity_button.dart';
import 'package:route_optima_mobile_app/gmapPages/googleMapConsts.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:route_optima_mobile_app/screens/navigation.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Location _locationController = Location();

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  // Src and dest Addresses
  static const String srcAddr = "Googleplex, Mountain View, CA";
  static const String destAddr = "Apple Park, Cupertino, CA";

  // Src and dest coordinates
  static const LatLng _srcCoord = LatLng(37.4223, -122.0848);
  static const LatLng _destCoord = LatLng(37.3346, -122.0090);
  // Current Location Coordinates
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

  // Attribute to set auto Camera Focus to the rider's location
  bool _autoCameraFocusEnabled = false;

  // Custom Marker icons
  BitmapDescriptor? _currLocIcon;
  BitmapDescriptor? _firstLocIcon;
  BitmapDescriptor? _lastLocIcon;

  @override
  void initState() {
    super.initState();

    // // Load the custom marker icons
    // BitmapDescriptor.fromAssetImage(
    //         const ImageConfiguration(size: Size.fromRadius(1.0)),
    //         'assets/markers/curr_loc.png')
    //     .then((icon) {
    //   setState(() {
    //     _currLocIcon = icon;
    //   });
    // });
    // BitmapDescriptor.fromAssetImage(
    //         const ImageConfiguration(size: Size.fromRadius(1.0)),
    //         'assets/markers/first_loc.png')
    //     .then((icon) {
    //   setState(() {
    //     _firstLocIcon = icon;
    //   });
    // });
    // BitmapDescriptor.fromAssetImage(
    //         const ImageConfiguration(size: Size.fromRadius(1.0)),
    //         'assets/markers/last_loc.png')
    //     .then((icon) {
    //   setState(() {
    //     _lastLocIcon = icon;
    //   });
    // });

    getLocationUpdates().then(
      (_) => {
        getPolylinePoints().then((coordinates) {
          // Generate polyline and store in Firestore
          generatePolyLineFromPoints(coordinates);
          updateFirestorePolyline(coordinates);
        }),
      },
    );

    // Set up a timer to update the location every timerDuration seconds
    _locationUpdateTimer = Timer.periodic(
        const Duration(seconds: locationUploadInterval), (timer) {
      if (_currentP != null) {
        updateFirestoreLocation(_currentP!);
      }
    });
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
            child: CircularProgressIndicator(),
          )
        : Stack(
            children: [
              GoogleMap(
                onMapCreated: ((GoogleMapController controller) =>
                    _mapController.complete(controller)),
                initialCameraPosition: const CameraPosition(
                  target: _srcCoord,
                  zoom: 13,
                ),
                markers: {
                  // Marker(
                  //   markerId: const MarkerId("currLoc"),
                  //   icon: _currLocIcon ??
                  //       BitmapDescriptor.defaultMarkerWithHue(
                  //           BitmapDescriptor.hueBlue),
                  //   position: _currentP!,
                  // ),
                  Marker(
                    markerId: const MarkerId("srcLoc"),
                    icon: _firstLocIcon ??
                        BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueOrange),
                    position: _srcCoord,
                    infoWindow: const InfoWindow(
                      title: srcAddr,
                    ),
                  ),
                  Marker(
                    markerId: const MarkerId("destLoc"),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed),
                    position: _destCoord,
                    infoWindow: const InfoWindow(
                      title: destAddr,
                    ),
                  ),
                  Marker(
                    markerId: const MarkerId("lastLoc"),
                    icon: _lastLocIcon ??
                        BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueOrange),
                    position: _destCoord,
                    visible: _lastLocIcon != null,
                  ),
                },
                circles: {
                  Circle(
                    circleId: const CircleId("currLocCircle"),
                    center: _currentP!,
                    radius: proximityThreshold,
                    fillColor: Colors.blueAccent.withOpacity(0.2),
                    strokeWidth: 0,
                  ),
                },
                polylines: Set<Polyline>.of(polylines.values),
                zoomControlsEnabled: false,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                onLongPress: (LatLng latLng) async {
                  final GoogleMapController controller =
                      await _mapController.future;
                  CameraPosition newCameraPosition = CameraPosition(
                    target: latLng,
                    zoom: 13,
                  );
                  await controller.animateCamera(
                    CameraUpdate.newCameraPosition(newCameraPosition),
                  );
                },
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ReportEmergencyButton(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _getNavButton(),
                      ),
                    ],
                  ),
                  // Render the proximity button if the rider is in proximity
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: _inProximity,
                        child: renderProximityButton(context),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    // If auto camera focus is disabled, return
    if (!_autoCameraFocusEnabled) return;

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
          _destCoord,
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
      PointLatLng(_srcCoord.latitude, _srcCoord.longitude),
      PointLatLng(_destCoord.latitude, _destCoord.longitude),
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
        color: Colors.blueAccent,
        points: polylineCoordinates,
        width: 8);
    setState(() {
      polylines[id] = polyline;
    });
  }

  Widget _getNavButton() {
    return FloatingActionButton(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      onPressed: () {
        setState(() {
          _autoCameraFocusEnabled = !_autoCameraFocusEnabled;
        });
        _cameraToPosition(_currentP ?? _srcCoord);
      },
      tooltip: 'Show Current Location',
      child: _autoCameraFocusEnabled
          ? const FaIcon(
              FontAwesomeIcons.locationArrow,
            )
          : const FaIcon(
              FontAwesomeIcons.locationCrosshairs,
            ),
    );
  }
}
