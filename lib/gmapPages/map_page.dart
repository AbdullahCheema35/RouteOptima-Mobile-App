import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_optima_mobile_app/consts/map_consts.dart';
import 'package:route_optima_mobile_app/gmapPages/edge_warning_overlay.dart';
import 'package:route_optima_mobile_app/gmapPages/proximity_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:route_optima_mobile_app/screens/emergency_request_dialog.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;
import 'package:vibration/vibration.dart';
import 'package:flutter_beep/flutter_beep.dart';

class MapPage extends StatefulWidget {
  const MapPage({
    required this.userId,
    required this.riderLocationData,
    required this.assignmentsData,
    super.key,
  });

  final String userId;
  final Map<String, dynamic> riderLocationData;
  final Map<String, dynamic> assignmentsData;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _gMapController;

  StreamSubscription<Position>? _positionStream;

  bool _hasVibrator = false;

  double _zoom = defaultZoom;

  Map<PolylineId, Polyline> polylines = {};

  bool _inProximity = false;

  bool _autoCameraFocusEnabled = false;

  // Additional fields for uploading current location to Firestore
  // according to the update interval set
  int lastDbUpdateStamp = 0; // in ms

  // GeoFencing fields
  bool? _isOnPath;

  // --------------------------------------------------------------------------------------------------
  //-------------------------------- Map Page Settings Fields ----------------------------------------
  //--------------------------------- Now Actual Data Fields Below -----------------------------------------

  late final Map<String, dynamic> _riderLocationData;
  late final Map<String, dynamic> _assignmentsData;

  late final String _userId;

  late int _polylineId;

  late String _srcAddr;
  late String _destAddr;

  late LatLng _srcCoord;
  late LatLng _destCoord;

  LatLng? _currentP;

  // New fields
  late Map<String, dynamic> _currentRoute;
  late List<dynamic> _allRoutes;
  late int _totalParcels;
  late DateTime _startTime;
  bool _showAllRoutes = false;

  @override
  void initState() {
    super.initState();

    // Initialize the fields with the data passed from the previous page
    _userId = widget.userId;
    _riderLocationData = widget.riderLocationData;
    _assignmentsData = widget.assignmentsData;
    _allRoutes = _riderLocationData['polylines'];
    _totalParcels = _riderLocationData['polylines'].length;

    // Now initialize the fields with the data
    _setLocDataFieldsFromJson(_riderLocationData);

    // Generate the polyline from the current route
    generateNextPolyLine();

    // Start Location service
    getLocationUpdates();

    // Check if the device has a vibrator
    Vibration.hasVibrator().then((value) {
      _hasVibrator = value ?? false;
    });
  }

  @override
  void dispose() {
    if (_gMapController != null) {
      _gMapController!.dispose();
    }
    if (_positionStream != null) {
      _positionStream!.cancel();
    }
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
                visible: _isOnPath != null && _gMapController != null,
                child: Positioned.fill(
                  child: EdgeWarningOverlay(
                    isOnPath: _isOnPath ?? true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GoogleMap(
                  onMapCreated: ((GoogleMapController controller) {
                    _gMapController = controller;
                  }),
                  initialCameraPosition: CameraPosition(
                    target: _srcCoord,
                    zoom: defaultZoom,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId("srcLoc"),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueOrange),
                      position: _srcCoord,
                      infoWindow: InfoWindow(
                        title: _srcAddr,
                      ),
                    ),
                    Marker(
                      markerId: const MarkerId("destLoc"),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueRed),
                      position: _destCoord,
                      infoWindow: InfoWindow(
                        title: _destAddr,
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
                    // Set zoom level to default
                    _zoom = defaultZoom;

                    CameraPosition newCameraPosition = CameraPosition(
                      target: latLng,
                      zoom: _zoom,
                    );
                    if (_gMapController != null) {
                      _gMapController!.animateCamera(
                        CameraUpdate.newCameraPosition(newCameraPosition),
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FloatingActionButton(
                            heroTag: null,
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            onPressed: () {
                              togglePolyline();
                            },
                            tooltip: 'Toggle Polyline',
                            child: _showAllRoutes == true
                                ? const FaIcon(
                                    FontAwesomeIcons.mapMarker,
                                  )
                                : const FaIcon(
                                    FontAwesomeIcons.layerGroup,
                                  ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _getEmergencyRequestButton(),
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
                          child:
                              renderProximityButton(context, onParcelDelivered),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
  }

  // Update the _assignmentsData fields
  void onParcelDelivered(Map<String, dynamic> result) {
    // Update the assignmentsData with the result
    print('');
    print(result['success']);

    if (result['success'] == false) {
      return;
    }

    if (result['confirmation'] == true) {
      print('confirmation is true');
      print('sign: ${result['sign']}');
      print('cnic: ${result['cnic']}');
      print('ReceiverName: ${result['receiverName']}');
      // Update the Firestore with the new status
    } else if (result['unavailable'] == true) {
      print('unavailable is true');
      print('proof: ${result['proof']}');
      // Update the Firestore with the new status
    }

    // Move on to the next parcel
    setNextLocationDetails();
  }

  // Previous Parcel is delivered. Now onto the next one
  void setNextLocationDetails() {
    // Get the next location details from the riderLocation data
    // and set the fields accordingly
    // Also, generate the polyline from the current route
    // and update the Firestore with the new polylineId

    if (_polylineId + 1 < _totalParcels) {
      _riderLocationData['polylineId'] = _polylineId + 1;
      _setLocDataFieldsFromJson(_riderLocationData);
      generateNextPolyLine();
      updateFirestorePolylineId(_polylineId);
    }
  }

  void _setLocDataFieldsFromJson(Map<String, dynamic> data) {
    _polylineId = data['polylineId'];
    _currentRoute = data['polylines'][_polylineId];
    _srcAddr = _currentRoute['source'];
    _destAddr = _currentRoute['destination'];
    _srcCoord = LatLng(
      _currentRoute['sourceCoordinates']['lat'],
      _currentRoute['sourceCoordinates']['long'],
    );
    _destCoord = LatLng(
      _currentRoute['destinationCoordinates']['lat'],
      _currentRoute['destinationCoordinates']['long'],
    );
    _startTime = DateTime.now();
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    if (!_autoCameraFocusEnabled) return;

    if (_gMapController == null) return;

    // Get current zoom level
    _zoom = await _gMapController!.getZoomLevel();

    CameraPosition newCameraPosition = CameraPosition(
      target: pos,
      zoom: _zoom,
    );

    await _gMapController!.animateCamera(
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

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: locationStreamDistanceFilter,
      ),
    ).listen((Position position) {
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

  Future<void> updateFirestoreParcelStatus(
      String status, Map<String, dynamic> result) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference assignments = firestore.collection('assignments');

    DocumentReference documentRef = assignments.doc(_userId);

    documentRef.update({
      'status': status,
    });
  }

  Future<void> updateFirestorePolylineId(int newPolylineId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference locations = firestore.collection('riderLocation');

    DocumentReference documentRef = locations.doc(_userId);

    documentRef.update({
      'polylineId': newPolylineId,
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
    });
  }

  void togglePolyline() {
    if (_showAllRoutes == true) {
      // Change to single route
      PolylineId id = PolylineId(_polylineId.toString());
      final currentPolylineObj = polylines[id];

      // Clear the previous polylines
      polylines.clear();

      setState(() {
        _showAllRoutes = !_showAllRoutes;
        polylines[id] = currentPolylineObj!;
      });
    } else {
      // Now change to all routes
      polylines.clear();

      for (int i = 0; i < _totalParcels; i++) {
        final List<dynamic> polylineData =
            _riderLocationData['polylines'][i]['polyline'];
        final List<LatLng> polylineCoordinates = polylineData
            .map((e) => LatLng(e['lat'], e['long']))
            .toList(growable: false);
        PolylineId id = PolylineId(i.toString());
        Polyline polyline = Polyline(
          polylineId: id,
          color: i == _polylineId ? Colors.blueAccent : Colors.grey,
          points: polylineCoordinates,
          width: 8,
          zIndex: i == _polylineId ? 1 : 0,
        );

        polylines[id] = polyline;
      }

      setState(() {
        _showAllRoutes = !_showAllRoutes;
        polylines;
      });
    }
  }

  void generateNextPolyLine() {
    if (_showAllRoutes == false) {
      // Clear the previous polyline
      polylines.clear();

      final List<dynamic> polylineData = _currentRoute['polyline'];
      final List<LatLng> polylineCoordinates = polylineData
          .map((e) => LatLng(e['lat'], e['long']))
          .toList(growable: false);
      PolylineId id = PolylineId(_polylineId.toString());
      Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.blueAccent,
        points: polylineCoordinates,
        width: 8,
        zIndex: 1,
      );

      // Show the polyline on the map
      setState(() {
        polylines[id] = polyline;
      });
    } else {
      if (_polylineId > 0) {
        // Update the last polyline to grey
        // and current to blue
        PolylineId lastId = PolylineId((_polylineId - 1).toString());
        PolylineId currentId = PolylineId(_polylineId.toString());

        // Create a new polyline object
        final lastPolylineObj = Polyline(
          polylineId: lastId,
          color: Colors.grey,
          points: polylines[lastId]!.points,
          width: 8,
        );
        final currentPolylineObj = Polyline(
          polylineId: currentId,
          color: Colors.blueAccent,
          points: polylines[currentId]!.points,
          width: 8,
          zIndex: 1,
        );

        setState(() {
          polylines[lastId] = lastPolylineObj;
          polylines[currentId] = currentPolylineObj;
        });
      } else {
        print("There is something wrong!");
      }
    }
  }

  Widget _getNavButton() {
    return FloatingActionButton(
      heroTag: null,
      backgroundColor: Colors.black,
      foregroundColor: const Color.fromARGB(255, 239, 225, 225),
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

  Widget _getEmergencyRequestButton() {
    return FloatingActionButton(
      heroTag: null,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            final request = _getEmergencyRequestTypeObject();
            return EmergencyRequestDialog(request: request);
          },
        );
      },
      tooltip: 'Report Emergency',
      child: const FaIcon(
        FontAwesomeIcons.triangleExclamation,
      ),
    );
  }

  Future<void> geoFencingFunction(
      LatLng origPoint, List<LatLng> origPolyline) async {
    mp.LatLng point = mp.LatLng(origPoint.latitude, origPoint.longitude);

    List<mp.LatLng> polyline =
        origPolyline.map((e) => mp.LatLng(e.latitude, e.longitude)).toList();

    final isOnPathResult = mp.PolygonUtil.isLocationOnPath(
        point, polyline, true,
        tolerance: geoFencingTolerance);

    if (_gMapController != null &&
        (_isOnPath == null || _isOnPath != isOnPathResult)) {
      // Set state of the app
      setState(() {
        _isOnPath = isOnPathResult;
      });

      // If the user is not on the path, then do the following
      if (isOnPathResult == false) {
        // Beep the device
        FlutterBeep.playSysSound(AndroidSoundIDs.TONE_CDMA_ABBR_ALERT);

        // Check if the device has a vibrator
        if (_hasVibrator) {
          // Vibrate the device
          Vibration.vibrate(duration: vibrationDuration);
        }

        // Show dialog to the user
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
                        final request = _getEmergencyRequestTypeObject();
                        return EmergencyRequestDialog(request: request);
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
    }
  }

  EmergencyRequestType _getEmergencyRequestTypeObject() {
    return EmergencyRequestType(
      riderId: _userId,
      geoTag: _currentP!,
      currentRoute: _currentRoute['polyline'],
      allRoutes: _riderLocationData['polylines'],
      srcLoc: _srcCoord,
      destLoc: _destCoord,
      polylineId: _polylineId,
    );
  }
}
