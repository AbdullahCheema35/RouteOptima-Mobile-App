import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:route_optima_mobile_app/gmapPages/proximity_button.dart';
import 'package:route_optima_mobile_app/consts/googleMapConsts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  final LatLng _srcCoord = const LatLng(_srcLat, _srcLng);
  final LatLng _destCoord = const LatLng(_destLat, _destLng);

  LatLng? _currentP;

  final int _polylineId = 1;

  Map<PolylineId, Polyline> polylines = {};

  late Timer _locationUpdateTimer;
  static const int locationUploadInterval = 10;

  bool _inProximity = false;
  static const double proximityThreshold = 500.0;

  bool _autoCameraFocusEnabled = false;

  BitmapDescriptor? _currLocIcon;
  BitmapDescriptor? _firstLocIcon;
  BitmapDescriptor? _lastLocIcon;

  @override
  void initState() {
    super.initState();

    getLocationUpdates().then(
      (_) => {
        getPolylinePoints().then((coordinates) {
          generatePolyLineFromPoints(coordinates);
          updateFirestorePolyline(coordinates);
        }),
      },
    );

    _locationUpdateTimer = Timer.periodic(
        const Duration(seconds: locationUploadInterval), (timer) {
      if (_currentP != null) {
        updateFirestoreLocation(_currentP!);
      }
    });
  }

  @override
  void dispose() {
    _locationUpdateTimer.cancel();
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
              GoogleMap(
                onMapCreated: ((GoogleMapController controller) =>
                    _mapController.complete(controller)),
                initialCameraPosition: CameraPosition(
                  target: _srcCoord,
                  zoom: 13,
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

    Geolocator.getPositionStream().listen((Position position) {
      if (position.latitude != null && position.longitude != null) {
        final newP = LatLng(position.latitude!, position.longitude!);

        double distance = calculateDistance(
          newP,
          _destCoord,
        );

        setState(() {
          _currentP = newP;
          _cameraToPosition(_currentP!);
          _inProximity = distance <= proximityThreshold;
        });
      }
    });
  }

  Future<void> updateFirestoreLocation(LatLng currentLocation) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference locations = firestore.collection('riderLocation');

    DocumentReference documentRef = locations.doc(_userId);

    documentRef.update({
      'lat': currentLocation.latitude,
      'long': currentLocation.longitude,
    });
  }

  Future<void> updateFirestorePolyline(List<LatLng> polylineCoordinates) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference polylines = firestore.collection('riderLocation');

    DocumentReference documentRef = polylines.doc(_userId);

    documentRef.update({
      'polyline': polylineCoordinates
          .map((latLng) => {
                'lat': latLng.latitude,
                'long': latLng.longitude,
              })
          .toList(),
      'polylineId': _polylineId,
      'srcAddr': srcAddr,
      'destAddr': destAddr,
      'srcCoord': {
        'lat': _srcCoord.latitude,
        'long': _srcCoord.longitude,
      },
      'destCoord': {
        'lat': _destCoord.latitude,
        'long': _destCoord.longitude,
      },
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
