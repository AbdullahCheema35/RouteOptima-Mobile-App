import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_optima_mobile_app/consts/riders_info.dart';

// Define the Rider class to hold rider information
@immutable
class Rider {
  final String id;
  final String name;

  const Rider(this.id, this.name);
}

// The Notifier class that will be passed to our NotifierProvider.
// This class should not expose state outside of its "state" property, which means
// no public getters/properties!
// The public methods on this class will be what allow the UI to modify the state.
class RiderNotifier extends Notifier<Rider> {
  @override
  Rider build() {
    // Return the first rider in the riderCatalog
    final riderData = ridersCatalog.entries.first;
    return Rider(riderData.key, riderData.value);
  }

  // Let's change the rider
  void toggle(Rider rider) {
    state = rider;
  }
}

// Finally, we are using NotifierProvider to allow the UI to interact with
// our RiderNotifier class.
final riderNotifierProvider = NotifierProvider<RiderNotifier, Rider>(() {
  return RiderNotifier();
});
