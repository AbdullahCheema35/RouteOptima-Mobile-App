import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:route_optima_mobile_app/gmapPages/edge_warning_overlay.dart';
import 'package:route_optima_mobile_app/gmapPages/proximity_button.dart';
import 'package:route_optima_mobile_app/consts/googleMapConsts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:route_optima_mobile_app/screens/emergency_request_dialog.dart';
import 'package:route_optima_mobile_app/screens/navigation.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _userId = '46ACIEbnlM4N8dGez77b';

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  static const String srcAddr =
      "72 Rohtas Rd, G-9 Markaz G 9 Markaz G-9, Islamabad, Islamabad Capital Territory 44090, Pakistan";

  static const String destAddr =
      "17, G-11/3 G 11/3 G-11, Islamabad, Islamabad Capital Territory, Pakistan";

  static const _srcLat = 33.6877;
  static const _srcLng = 73.0339;
  static const _destLat = 33.6755;
  static const _destLng = 73.0007;

  // Zoom Level
  static const double default_zoom = 13;

  double _zoom = default_zoom;

  final LatLng _srcCoord = const LatLng(_srcLat, _srcLng);
  final LatLng _destCoord = const LatLng(_destLat, _destLng);

  LatLng? _currentP;

  final int _polylineId = 1;

  Map<PolylineId, Polyline> polylines = {};

  static const int locationStreamDistanceFilter = 100;

  late Timer _locationUpdateTimer;
  // static const int locationUploadInterval = 10;

  bool _inProximity = false;
  static const double proximityThreshold = 100.0;

  bool _autoCameraFocusEnabled = false;

  BitmapDescriptor? _currLocIcon;
  BitmapDescriptor? _firstLocIcon;
  BitmapDescriptor? _lastLocIcon;

  // // Stats for updates
  // int locationUpdateCount = 0;
  // int lastLocationUpdateMillis = -1;
  // int timeStarted = -1;

  // Additional fields for uploading current location to Firestore
  // according to the update interval set

  static const int locationUploadInterval = 10000; // in ms
  int lastDbUpdateStamp = 0; // in ms

  // GeoFencing fields
  static const int geoFencingTolerance = 200; // meters
  bool? _isOnPath;

  @override
  void initState() {
    super.initState();

    getLocationUpdates().then(
      (_) => {
        getPolylinePoints().then((polylinesData) {
          generatePolyLineFromPoints(polylinesData);
          // updateFirestorePolyline(coordinates);
        }),
      },
    );

    // _locationUpdateTimer = Timer.periodic(
    //     const Duration(seconds: locationUploadInterval), (timer) {
    //   if (_currentP != null) {
    //     updateFirestoreLocation(_currentP!);
    //   }
    // });
  }

  @override
  void dispose() {
    // _locationUpdateTimer.cancel();
    // _positionStream.cancel();
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
              Visibility(
                visible: _isOnPath != null,
                child: Positioned.fill(
                  child: EdgeWarningOverlay(
                    isOnPath: _isOnPath ?? true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                // padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GoogleMap(
                  onMapCreated: ((GoogleMapController controller) =>
                      _mapController.complete(controller)),
                  initialCameraPosition: CameraPosition(
                    target: _srcCoord,
                    zoom: default_zoom,
                  ),
                  markers: {
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
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  onLongPress: (LatLng latLng) async {
                    final GoogleMapController controller =
                        await _mapController.future;

                    // Set zoom level to default
                    _zoom = default_zoom;

                    CameraPosition newCameraPosition = CameraPosition(
                      target: latLng,
                      zoom: _zoom,
                    );
                    await controller.animateCamera(
                      CameraUpdate.newCameraPosition(newCameraPosition),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                // padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
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
              ),
            ],
          );
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    if (!_autoCameraFocusEnabled) return;

    final GoogleMapController controller = await _mapController.future;

    // Get current zoom level
    _zoom = await controller.getZoomLevel();

    CameraPosition newCameraPosition = CameraPosition(
      target: pos,
      zoom: _zoom,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(newCameraPosition),
    );
  }

  Future<void> getLocationUpdates() async {
    bool serviceEnabled;
    LocationPermission permissionGranted;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permissionGranted = await Geolocator.checkPermission();
    if (permissionGranted == LocationPermission.denied) {
      permissionGranted = await Geolocator.requestPermission();
      if (permissionGranted != LocationPermission.whileInUse &&
          permissionGranted != LocationPermission.always) {
        return;
      }
    }

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: locationStreamDistanceFilter,
      ),
    ).listen((Position position) {
      // print(
      //     "Location Change Detected: ${position.latitude}, ${position.longitude}");

      // if (timeStarted == -1) {
      //   timeStarted = DateTime.now().millisecondsSinceEpoch;
      //   lastLocationUpdateMillis = timeStarted;
      // } else {
      //   locationUpdateCount++;
      //   final currTime = DateTime.now().millisecondsSinceEpoch;
      //   print(
      //       "Time since last update: ${currTime - lastLocationUpdateMillis}ms");
      //   lastLocationUpdateMillis = currTime;
      //   print(
      //       "Avg time between updates: ${(currTime - timeStarted) / locationUpdateCount}ms");
      // }

      final newP = LatLng(position.latitude, position.longitude);

      // Compute distance from destination to check for proximity using geolocator
      final distance = Geolocator.distanceBetween(newP.latitude, newP.longitude,
          _destCoord.latitude, _destCoord.longitude);

      // Animate camera to new position
      _cameraToPosition(newP);

      setState(() {
        _currentP = newP;
        _inProximity = distance <= proximityThreshold;
      });

      // Check if the user is following the polyline path
      // But also check if the polyline has been generated
      if (polylines.isNotEmpty) {
        geoFencingFunction(_currentP!, polylines.values.first.points);
      }

      // Update Firestore with current location if the interval has passed
      if (position.timestamp.millisecondsSinceEpoch - lastDbUpdateStamp >
          locationUploadInterval) {
        updateFirestoreLocation(_currentP!);
        lastDbUpdateStamp = position.timestamp.millisecondsSinceEpoch;
      }
    });
  }

  Future<void> updateFirestoreLocation(LatLng currentLocation) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference locations = firestore.collection('riderLocation');

    DocumentReference documentRef = locations.doc(_userId);

    documentRef.update({
      'riderCoordinates': {
        'lat': currentLocation.latitude,
        'long': currentLocation.longitude,
      },
      'lat': currentLocation.latitude,
      'long': currentLocation.longitude,
    });
  }

  // Future<void> updateFirestorePolyline(List<LatLng> polylineCoordinates) async {
  //   final FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   CollectionReference polylines = firestore.collection('riderLocation');

  //   DocumentReference documentRef = polylines.doc(_userId);

  //   documentRef.update({
  //     'polyline': polylineCoordinates
  //         .map((latLng) => {
  //               'lat': latLng.latitude,
  //               'long': latLng.longitude,
  //             })
  //         .toList(),
  //     'polylineId': _polylineId,
  //     'srcAddr': srcAddr,
  //     'destAddr': destAddr,
  //     'srcCoord': {
  //       'lat': _srcCoord.latitude,
  //       'long': _srcCoord.longitude,
  //     },
  //     'destCoord': {
  //       'lat': _destCoord.latitude,
  //       'long': _destCoord.longitude,
  //     },
  //   });
  // }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GEO_API_KEY,
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

  // Future<dynamic> getPolylinePointsFromFirestore() async {
  //   final FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   CollectionReference polylines = firestore.collection('riderLocation');

  //   DocumentReference documentRef = polylines.doc(_userId);

  //   final doc = await documentRef.get();
  //   final data = doc.data() as Map<String, dynamic>;
  //   final List<dynamic> polylineData = data['polylines'];
  //   return polylineData;
  // }

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = PolylineId(_polylineId.toString());
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.blueAccent,
        points: polylineCoordinates,
        width: 8);
    setState(() {
      polylines[id] = polyline;
    });
  }

  // void generatePolylinesFromData(dynamic polylinesData) {
  //   // PolylinesData is a list of maps
  //   // Each map contains polyline (list of coordinates with lat long keys) and polylineId
  //   for (var data in polylinesData) {
  //     final polylineMap = data['polyline'];
  //     final polylineId = data['polylineId'];
  //     final List<LatLng> polylineCoordinates = [];
  //     for (var coord in polylineMap) {
  //       polylineCoordinates.add(LatLng(coord['lat'], coord['long']));
  //     }
  //     PolylineId id = PolylineId(polylineId.toString());
  //     Polyline polyline = Polyline(
  //         polylineId: id,
  //         color: polylineId == 0 ? Colors.blueAccent : Colors.grey,
  //         points: polylineCoordinates,
  //         width: 8);

  //     setState(() {
  //       polylines[id] = polyline;
  //     });
  //   }
  // }

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

  Future<void> geoFencingFunction(
      LatLng point, List<LatLng> polylinePath) async {
    mp.LatLng _point = mp.LatLng(point.latitude, point.longitude);
    List<mp.LatLng> _polyline =
        polylinePath.map((e) => mp.LatLng(e.latitude, e.longitude)).toList();
    final isOnPathResult = mp.PolygonUtil.isLocationOnPath(
        _point, _polyline, true,
        tolerance: geoFencingTolerance);
    if (_isOnPath == null || _isOnPath != isOnPathResult) {
      if (isOnPathResult == false) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Deviation Alert'),
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('You are deviating from the path.'),
                  SizedBox(height: 8.0),
                  Text(
                      'The admin will be notified of your deviation from the provided path.'),
                  SizedBox(height: 16.0),
                  Text(
                      'Kindly return to the path or inform admin about an emergency.'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return EmergencyRequestDialog();
                      },
                    );
                  },
                  child: const Text('Report Emergency'),
                ),
              ],
            );
          },
        );
      }
      setState(() {
        _isOnPath = isOnPathResult;
      });
    }
  }
}
