import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:route_optima_mobile_app/consts/map_consts.dart';
import 'package:route_optima_mobile_app/gmapPages/edge_warning_overlay.dart';
import 'package:route_optima_mobile_app/gmapPages/proximity_button.dart';
import 'package:route_optima_mobile_app/consts/googleMapConsts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:route_optima_mobile_app/screens/emergency_request_dialog.dart';
import 'package:route_optima_mobile_app/screens/navigation.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;
import 'package:vibration/vibration.dart';
import 'package:flutter_beep/flutter_beep.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _userId = '46ACIEbnlM4N8dGez77b';

  GoogleMapController? _gMapController;

  StreamSubscription<Position>? _positionStream;

  bool _hasVibrator = false;

  static const String srcAddr =
      "72 Rohtas Rd, G-9 Markaz G 9 Markaz G-9, Islamabad, Islamabad Capital Territory 44090, Pakistan";

  static const String destAddr =
      "17, G-11/3 G 11/3 G-11, Islamabad, Islamabad Capital Territory, Pakistan";

  static const _srcLat = 33.6877;
  static const _srcLng = 73.0339;
  static const _destLat = 33.6755;
  static const _destLng = 73.0007;

  double _zoom = defaultZoom;

  final LatLng _srcCoord = const LatLng(_srcLat, _srcLng);
  final LatLng _destCoord = const LatLng(_destLat, _destLng);

  LatLng? _currentP;

  final int _polylineId = 1;

  Map<PolylineId, Polyline> polylines = {};

  bool _inProximity = false;

  bool _autoCameraFocusEnabled = false;

  // Additional fields for uploading current location to Firestore
  // according to the update interval set
  int lastDbUpdateStamp = 0; // in ms

  // GeoFencing fields
  bool? _isOnPath;

  // Vibration duration

  @override
  void initState() {
    super.initState();

    getLocationUpdates().then(
      (_) => {
        getPolylinePoints().then((polylinesData) {
          generatePolyLineFromPoints(polylinesData);
        }),
      },
    );

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
                visible: _isOnPath != null,
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

  Future<void> geoFencingFunction(
      LatLng origPoint, List<LatLng> origPolyline) async {
    mp.LatLng point = mp.LatLng(origPoint.latitude, origPoint.longitude);

    List<mp.LatLng> polyline =
        origPolyline.map((e) => mp.LatLng(e.latitude, e.longitude)).toList();

    final isOnPathResult = mp.PolygonUtil.isLocationOnPath(
        point, polyline, true,
        tolerance: geoFencingTolerance);

    if (_isOnPath == null || _isOnPath != isOnPathResult) {
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
    }
  }
}
