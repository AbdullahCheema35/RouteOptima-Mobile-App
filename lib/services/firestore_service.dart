import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_optima_mobile_app/models/trip.dart';

final firestoreServiceProvider = Provider.autoDispose<FirestoreService>((ref) {
  return FirestoreService();
});

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _subscribeToAssignedTripsUpdates(Function(List) onNewAssignedSubroute) {
    final subrouteCollection = _firestore
        .collection('subroutes')
        .where('status', isEqualTo: 'assigned')
        .orderBy('startTime');
    subrouteCollection.snapshots().listen(
      (event) {
        final List<Trip> eventTrips = [];
        for (var change in event.docChanges) {
          switch (change.type) {
            case DocumentChangeType.added:
              final newSubrouteData = change.doc.data() as Map<String, dynamic>;
              final newTrip =
                  Trip.fromFirestore(newSubrouteData, change.doc.id);
              eventTrips.add(newTrip);
              print("Added Subroute: ${newTrip.id}");
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
        onNewAssignedSubroute(eventTrips);
      },
      onError: (error) => print("Listen failed: $error"),
    );
  }

  void _subscribeToCompletedTripsUpdates(
      Function(List) onNewCompletedSubroute) {
    final subrouteCollection = _firestore
        .collection('subroutes')
        .where('status', isEqualTo: 'completed')
        .orderBy('startTime', descending: true);
    subrouteCollection.snapshots().listen(
      (event) {
        final List<Trip> eventTrips = [];
        for (var change in event.docChanges) {
          switch (change.type) {
            case DocumentChangeType.added:
              final newSubrouteData = change.doc.data() as Map<String, dynamic>;
              final newTrip =
                  Trip.fromFirestore(newSubrouteData, change.doc.id);
              eventTrips.add(newTrip);
              print("Added Subroute: ${newTrip.id}");
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
        onNewCompletedSubroute(eventTrips);
      },
      onError: (error) => print("Listen failed: $error"),
    );
  }

  void setupAssignedTripsListener(ref) {
    _subscribeToAssignedTripsUpdates((newAssignedSubroutes) {
      ref
          .read(assignedTripsNotifierProvider.notifier)
          .addTrips(newAssignedSubroutes);
    });
  }

  void setupCompletedTripsListener(ref) {
    _subscribeToCompletedTripsUpdates((newCompletedSubroutes) {
      ref
          .read(completedTripsNotifierProvider.notifier)
          .addTrips(newCompletedSubroutes);
    });
  }
}

final assignedTripsNotifierProvider =
    StateNotifierProvider<AssignedTripsNotifier, List<Trip>>((ref) {
  final firestoreService = ref.read(firestoreServiceProvider);
  firestoreService.setupAssignedTripsListener(ref);
  return AssignedTripsNotifier();
});

// The StateNotifier class that will be passed to our StateNotifierProvider.
// This class should not expose state outside of its "state" property, which means
// no public getters/properties!
// The public methods on this class will be what allow the UI to modify the state.
class AssignedTripsNotifier extends StateNotifier<List<Trip>> {
  // We initialize the list of trips to an empty list
  AssignedTripsNotifier() : super([]);

  // Let's allow the UI to add trips.
  void addTrips(List<Trip> newTrips) {
    state = [...state, ...newTrips];
  }
}

final completedTripsNotifierProvider =
    StateNotifierProvider.autoDispose<CompletedTripsNotifier, List<Trip>>(
        (ref) {
  final firestoreService = ref.read(firestoreServiceProvider);
  firestoreService.setupCompletedTripsListener(ref);
  return CompletedTripsNotifier();
});

// The StateNotifier class that will be passed to our StateNotifierProvider.
// This class should not expose state outside of its "state" property, which means
// no public getters/properties!
// The public methods on this class will be what allow the UI to modify the state.
class CompletedTripsNotifier extends StateNotifier<List<Trip>> {
  // We initialize the list of trips to an empty list
  CompletedTripsNotifier() : super([]);

  // Let's allow the UI to add trips.
  void addTrips(List<Trip> newTrips) {
    state = [...newTrips, ...state];
  }
}
