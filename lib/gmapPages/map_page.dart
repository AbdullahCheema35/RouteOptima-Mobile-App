import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_optima_mobile_app/consts/map_consts.dart';
import 'package:route_optima_mobile_app/gmapPages/edge_warning_overlay.dart';
import 'package:route_optima_mobile_app/gmapPages/emergency_request_button.dart';
import 'package:route_optima_mobile_app/gmapPages/firestore_services.dart';
import 'package:route_optima_mobile_app/gmapPages/nav_button.dart';
import 'package:route_optima_mobile_app/gmapPages/open_gmap.dart';
import 'package:route_optima_mobile_app/gmapPages/proximity_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:route_optima_mobile_app/screens/emergency_request_dialog.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;
import 'package:vibration/vibration.dart';
import 'package:flutter_beep/flutter_beep.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({
    required this.userId,
    required this.riderLocationData,
    super.key,
  });

  final Map<String, dynamic> riderLocationData;
  final String userId;

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  GoogleMapController? _gMapController;

  StreamSubscription<Position>? _positionStream;

  bool _hasVibrator = false;

  double _zoom = defaultZoom;

  Map<PolylineId, Polyline> polylines = {};
  Map<int, Circle> circles = {};

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

  // Markers for the map
  Map<String, Marker> markers = {};

  @override
  void initState() {
    super.initState();

    // Initialize the fields with the data passed from the previous page
    _riderLocationData = widget.riderLocationData;
    _allRoutes = _riderLocationData['polylines'];
    _totalParcels = _allRoutes.length;
    _userId = widget.userId;

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
                    target: _currentP!,
                    zoom: defaultZoom,
                  ),
                  markers: Set<Marker>.of(markers.values),
                  circles: Set<Circle>.of(circles.values),
                  polylines: Set<Polyline>.of(polylines.values),
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  onLongPress: (LatLng latLng) async {
                    // Set zoom level to default
                    if (_zoom - 3 >= defaultZoom) {
                      _zoom = defaultZoom;
                    } else {
                      _zoom = _zoom - 2 < 0 ? 0 : _zoom - 2;
                    }

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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GoogleMapsButton(
                            destCoord: _destCoord,
                          ),
                        ),
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
                                    FontAwesomeIcons.locationPin,
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
                          child: EmergencyRequestButton(
                            ref: ref,
                            request: _getEmergencyRequestTypeObject(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: NavButton(
                            autoCameraFocusEnabled: _autoCameraFocusEnabled,
                            cameraToPositionCallback: autoCameraFocusToggled,
                          ),
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
                              ProximityButton(onDelivered: onParcelDelivered),
                        ),
                      ],
                    ),
                  ],
                ),
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
          );
  }

  // Update the _assignmentsData fields
  Future<bool> onParcelDelivered(Map<String, dynamic> result) async {
    // Update the assignmentsData with the result
    if (result['success'] == false) {
      return true;
    }

    Map<String, dynamic> assignmentsData;

    if (result['confirmation'] == true) {
      // Additional Fields
      result['deliveryProofLink'] = [result['cnic'], result['sign']];
      result['actualStartTime'] = _startTime;
      result['actualEndTime'] = DateTime.now();
      // Update the Firestore with the new status
      assignmentsData = await updateFirestoreParcelStatus(
          'delivered', result, _userId, _polylineId, ref,
          receiverName: result['receiverName']);
    } else if (result['unavailable'] == true) {
      // Additional Fields
      result['deliveryProofLink'] = [result['proof']];
      result['actualStartTime'] = _startTime;
      result['actualEndTime'] = DateTime.now();
      // Update the Firestore with the new status
      assignmentsData = await updateFirestoreParcelStatus(
          'unavailable', result, _userId, _polylineId, ref);
    } else {
      return true;
    }

    // Move on to the next parcel
    return setNextLocationDetails(assignmentsData);
  }

  // Previous Parcel is delivered. Now onto the next one
  bool setNextLocationDetails(Map<String, dynamic> assignmentsData) {
    // Get the next location details from the riderLocation data
    // and set the fields accordingly
    // Also, generate the polyline from the current route
    // and update the Firestore with the new polylineId

    _polylineId += 1;

    if (_polylineId < _totalParcels) {
      // Now set the next parcel location details
      _riderLocationData['polylineId'] = _polylineId;
      _setLocDataFieldsFromJson(_riderLocationData);
      generateNextPolyLine();
      updateFirestorePolylineId(_polylineId, _userId);
      return true;
    } else {
      // All parcels have been delivered
      updateFirestoreAssignmentStatus("completed", _userId, assignmentsData);
      return false;
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

      // Update current location's circle on the map
      final updatedCircle = Circle(
        circleId: const CircleId("0"),
        center: newP,
        radius: proximityThreshold,
        fillColor: Colors.blue.withOpacity(0.2),
        strokeWidth: 0,
      );

      setState(() {
        _currentP = newP;
        _inProximity = distance <= proximityThreshold;
        circles[0] = updatedCircle;
      });

      // Check if the user is following the polyline path
      // But also check if the polyline has been generated
      if (polylines.isNotEmpty) {
        geoFencingFunction(_currentP!, polylines.values.first.points);
      }

      // Update Firestore with current location if the interval has passed
      if (position.timestamp.millisecondsSinceEpoch - lastDbUpdateStamp >
          locationUploadInterval) {
        updateFirestoreLocation(_currentP!, _userId);
        lastDbUpdateStamp = position.timestamp.millisecondsSinceEpoch;
      }
    });
  }

  void togglePolyline() {
    print("Show all routes: $_showAllRoutes");

    if (_showAllRoutes == true) {
      // Change to single route
      PolylineId id = PolylineId(_polylineId.toString());
      final currentPolylineObj = polylines[id];

      // Clear the previous polylines
      polylines.clear();

      // Store the currentLocationCircle (firstCircle) in a temp variable and clear the rest of circles
      final currentLocationCircle = circles[0];
      circles.clear();

      // Change the markers
      final srcMarker = Marker(
        markerId: const MarkerId("src"),
        position: _srcCoord,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
          title: _srcAddr,
          snippet: 'Source Address',
        ),
      );

      final destMarker = Marker(
        markerId: const MarkerId("dest"),
        position: _destCoord,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: _destAddr,
          snippet: 'Destination Address',
        ),
      );

      setState(() {
        _showAllRoutes = !_showAllRoutes;
        polylines[id] = currentPolylineObj!;
        circles[0] = currentLocationCircle!;
        markers['src'] = srcMarker;
        markers['dest'] = destMarker;
      });
    } else {
      // Now change to all routes
      polylines.clear();

      for (int i = 0; i < _totalParcels; i++) {
        final List<dynamic> polylineData = _allRoutes[i]['polyline'];
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

        // Create circles on parcel locations
        CircleId circleId = CircleId((i + 1).toString());
        Circle circle = Circle(
          circleId: circleId,
          center: LatLng(
            _allRoutes[i]['destinationCoordinates']['lat'],
            _allRoutes[i]['destinationCoordinates']['long'],
          ),
          radius: proximityThreshold,
          fillColor: Colors.black87,
          strokeWidth: 0,
        );

        circles[i + 1] = circle;
        polylines[id] = polyline;
      }

      // Update the markers
      final srcMarker = Marker(
        markerId: const MarkerId("src"),
        position: LatLng(
          _allRoutes[0]['sourceCoordinates']['lat'],
          _allRoutes[0]['sourceCoordinates']['long'],
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
          title: _allRoutes[0]['source'],
          snippet: 'Warehouse Address',
        ),
      );

      final destMarker = Marker(
        markerId: const MarkerId("dest"),
        position: LatLng(
          _allRoutes[_totalParcels - 1]['destinationCoordinates']['lat'],
          _allRoutes[_totalParcels - 1]['destinationCoordinates']['long'],
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: _allRoutes[_totalParcels - 1]['destination'],
          snippet: 'Last Destination Address',
        ),
      );

      setState(() {
        _showAllRoutes = !_showAllRoutes;
        circles;
        polylines;
        markers['src'] = srcMarker;
        markers['dest'] = destMarker;
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

      // Update markers
      // Add the source and destination markers
      final srcMarker = Marker(
        markerId: const MarkerId("src"),
        position: _srcCoord,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
          title: _srcAddr,
          snippet: 'Source Address',
        ),
      );

      final destMarker = Marker(
        markerId: const MarkerId("dest"),
        position: _destCoord,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: _destAddr,
          snippet: 'Destination Address',
        ),
      );

      // Show the polyline on the map
      setState(() {
        markers['src'] = srcMarker;
        markers['dest'] = destMarker;
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

  // Pressed the nav button
  void autoCameraFocusToggled() {
    setState(() {
      _autoCameraFocusEnabled = !_autoCameraFocusEnabled;
    });
    _cameraToPosition(_currentP ?? _srcCoord);
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
        // Generate an emergency alert of rider deviation
        // and send to the admin for further action
        generateDeviationAlert(ref);

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
              title: const Text('Path Deviation Alert'),
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
                        return EmergencyRequestDialog(
                            request: request, ref: ref);
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

  void generateDeviationAlert(WidgetRef ref) {
    // Generate an emergency alert of rider deviation
    // and send to the admin for further action
    final deviationAlert = _getEmergencyRequestTypeObject();

    deviationAlert.type = "Path Deviation";
    deviationAlert.description = "Rider has deviated from the given path.";

    // Upload the deviation alert to Firestore
    uploadEmergencyRequest(_userId, deviationAlert, ref);
  }

  EmergencyRequestType _getEmergencyRequestTypeObject() {
    return EmergencyRequestType(
      riderId: _userId,
      geoTag: _currentP!,
      currentRoute: _currentRoute['polyline'],
      allRoutes: _allRoutes,
      srcLoc: _srcCoord,
      destLoc: _destCoord,
      polylineId: _polylineId,
    );
  }
}
