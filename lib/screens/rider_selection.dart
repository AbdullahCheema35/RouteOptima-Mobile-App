import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_optima_mobile_app/consts/riders_info.dart';
import 'package:route_optima_mobile_app/screens/drawer_widget.dart';
import 'package:route_optima_mobile_app/services/rider_selection.dart';

class RiderSelectionPage extends ConsumerWidget {
  const RiderSelectionPage({super.key});

  final _drawerTileIndex = 2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final riders = ridersCatalog.entries
        .map((entry) => Rider(entry.key, entry.value))
        .toList();

    final selectedRider = ref.watch(riderNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Rider Selection',
          style: TextStyle(
            fontSize: 24.0,
            fontFamily: 'Roboto', // Apply 'Roboto' font
          ),
        ),
      ),
      //Drawer
      drawer: routeOptimaDrawerWidget(
          context, _drawerTileIndex, selectedRider.name),
      //body
      body: ListView.builder(
        itemCount: riders.length,
        itemBuilder: (context, index) {
          final rider = riders[index];
          return ListTile(
            title: Text(rider.name),
            trailing: selectedRider.id == rider.id
                ? const Icon(Icons.radio_button_checked, color: Colors.black)
                : const Icon(Icons.radio_button_unchecked),
            onTap: () {
              ref.read(riderNotifierProvider.notifier).toggle(rider);
            },
          );
        },
      ),
    );
  }
}
