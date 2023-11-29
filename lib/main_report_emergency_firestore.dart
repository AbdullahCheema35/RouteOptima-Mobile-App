import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:route_optima_mobile_app/screens/navigation.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

// Create class MyApp
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Route Optima Mobile App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NavigationPage(),
    );
  }
}
