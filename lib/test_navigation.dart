import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_optima_mobile_app/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:route_optima_mobile_app/screens/navigation.dart';

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
    const tempUserId = "46ACIEbnlM4N8dGez77b";
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Route Optima Mobile App',
      home: NavigationPage(
        userId: tempUserId,
      ),
    );
  }
}
