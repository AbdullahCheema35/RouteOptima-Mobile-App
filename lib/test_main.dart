import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_optima_mobile_app/firebase_options.dart';
import 'package:route_optima_mobile_app/services/firestore_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //
  runApp(
    // For widgets to be able to read providers, we need to wrap the entire
    // application in a "ProviderScope" widget.
    // This is where the state of our providers will be stored.
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // // This widget is the root of your application.
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Route Optima Mobile App',
  //     theme: ThemeData(
  //       // This is the theme of your application.
  //       //
  //       // Try running your application with "flutter run". You'll see the
  //       // application has a blue toolbar. Then, without quitting the app, try
  //       // changing the primarySwatch below to Colors.green and then invoke
  //       // "hot reload" (press "r" in the console where you ran "flutter run",
  //       // or simply save your changes to "hot reload" in a Flutter IDE).
  //       // Notice that the counter didn't reset back to zero; the application
  //       // is not restarted.
  //       primarySwatch: Colors.blue,
  //     ),
  //     home: const FlutterFlowScreen(),
  //   );
  // }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Route Optima Mobile App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      // home: const SubRoutesScreen(trip: null,),
      home: TestScreen(),
    );
  }
}

// class DummyHomeScreen extends StatelessWidget {
//   DummyHomeScreen({super.key});

//   final dfs = DummyFirestoreService();

//   @override
//   Widget build(BuildContext context) {
//     dfs.getRouteStream();

//     return Scaffold(
//         appBar: AppBar(title: const Text("Home")), body: Container());
//   }
// }

// class DummyFirestoreService {
//   final db = FirebaseFirestore.instance;

//   void getRouteStream() async {
//     print("Inside getRouteStream()");
//     final subroutesRef = db.collection("subroute");
//     subroutesRef.snapshots().listen(
//       (event) {
//         for (var change in event.docChanges) {
//           switch (change.type) {
//             case DocumentChangeType.added:
//               print("New Subroute: ${change.doc.data()}");
//               break;
//             case DocumentChangeType.modified:
//               print("Modified Subroute: ${change.doc.data()}");
//               break;
//             case DocumentChangeType.removed:
//               print("Removed Subroute: ${change.doc.data()}");
//               break;
//             default:
//               print("Unknown route type added");
//           }
//         }
//       },
//       onError: (error) => print("Listen failed: $error"),
//     );
//   }
// }
