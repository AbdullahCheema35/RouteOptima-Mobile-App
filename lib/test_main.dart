import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_optima_mobile_app/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:route_optima_mobile_app/screens/trips_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Run the app now
  runApp(
    const ProviderScope(
      child: RouteOptimaApp(),
    ),
  );
}

class RouteOptimaApp extends StatelessWidget {
  const RouteOptimaApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Route Optima Mobile App',
      home: TripsPage(),
    );
  }
}
