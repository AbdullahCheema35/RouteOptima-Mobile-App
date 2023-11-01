import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:route_optima_mobile_app/models/trip.dart';

// The Notifier class that will be passed to our NotifierProvider.
// This class should not expose state outside of its "state" property, which means
// no public getters/properties!
// The public methods on this class will be what allow the UI to modify the state.
class RoutesNotifier extends Notifier<List<Trip>> {
  // We initialize the list of Routes to an empty list
  @override
  List<Trip> build() {
    return [];
  }

  // Let's allow the UI to add Routes.
  void addRoute(Trip route) {
    // Since our state is immutable, we are not allowed to do `state.add(route)`.
    // Instead, we should create a new list of routes which contains the previous
    // items and the new one.
    // Using Dart's spread operator here is helpful!
    state = [...state, route];
    // No need to call "notifyListeners" or anything similar. Calling "state ="
    // will automatically rebuild the UI when necessary.
  }
}

// Finally, we are using NotifierProvider to allow the UI to interact with
// our TodosNotifier class.
final routesNotifierProvider = NotifierProvider<RoutesNotifier, List<Trip>>(() {
  return RoutesNotifier();
});
