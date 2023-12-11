import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_optima_mobile_app/models/trip.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _subscribeToUpdates(Function(List) onNewSubroute) {
    final subrouteCollection = _firestore.collection('subroute');
    subrouteCollection.snapshots().listen(
      (event) {
        final List<Trip> eventTrips = [];
        for (var change in event.docChanges) {
          switch (change.type) {
            case DocumentChangeType.added:
              final newSubrouteData = change.doc.data() as Map<String, dynamic>;
              final newTrip = Trip.initial(newSubrouteData);
              eventTrips.add(newTrip);
              print("Added Subroute: ${newTrip.routeId}");
              break;
            case DocumentChangeType.modified:
              print("Modified Subroute: ${change.doc.data()}");
              break;
            case DocumentChangeType.removed:
              print("Removed Subroute: ${change.doc.data()}");
              break;
            default:
              print("Unknown route type added");
          }
        }
        onNewSubroute(eventTrips);
      },
      onError: (error) => print("Listen failed: $error"),
    );
  }

  void setupFirestoreListener(ref) {
    _subscribeToUpdates((newSubroutes) {
      ref.read(tripsNotifierProvider.notifier).addTrips(newSubroutes);
    });
  }
}

final tripsNotifierProvider =
    StateNotifierProvider<TripsNotifier, List<Trip>>((ref) {
  final firestoreService = ref.read(firestoreServiceProvider);
  firestoreService.setupFirestoreListener(ref);
  return TripsNotifier();
});

// The StateNotifier class that will be passed to our StateNotifierProvider.
// This class should not expose state outside of its "state" property, which means
// no public getters/properties!
// The public methods on this class will be what allow the UI to modify the state.
class TripsNotifier extends StateNotifier<List<Trip>> {
  // We initialize the list of trips to an empty list
  TripsNotifier() : super([]);

  // Let's allow the UI to add trips.
  void addTrips(List<Trip> newTrips) {
    state = [...state, ...newTrips];
  }
}

class TestScreen extends ConsumerWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trips = ref.watch(tripsNotifierProvider);

    return Scaffold(
      // Also show the number of trips (length of the list)
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        centerTitle: true,
        title: const Text('Test'),
      ),
      body: ListView.builder(
        itemCount: trips.length,
        itemBuilder: (context, index) {
          final trip = trips[index];
          // Customize the ListTile as per your Trip model
          return ListTile(
            title: Text(trip.routeId), // Other details to display...
          );
        },
      ),
    );
  }
}
