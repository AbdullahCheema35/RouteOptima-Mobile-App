import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:route_optima_mobile_app/models/trip.dart';
import 'package:route_optima_mobile_app/services/routes_notifier_provider.dart';
import 'package:route_optima_mobile_app/services/route_stream.dart';

final routeListProvider = Provider<List<Trip>>((ref) {
  // We obtain the list of all todos from the todosProvider
  final routeList = ref.watch(routesNotifierProvider);
  ref.listen(routeStreamProvider, (previous, next) async {
    final routeStreamObject = await ref.read(routeStreamProvider.future);
    ref.read(routesNotifierProvider.notifier).addRoute(routeStreamObject);
  });
  // routeStreamObject.then((value) {
  //   ref.read(routesNotifierProvider.notifier).addRoute(value);
  // }).catchError((error) {
  //   print('Error: $error');
  // });

  // we return only the completed todos
  return routeList;
});
