import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:route_optima_mobile_app/services/rider_selection.dart';

final locationStreamProvider = StreamProvider<DocumentSnapshot>((ref) {
  final currentDocId = ref.watch(riderNotifierProvider).id;
  final stream = FirebaseFirestore.instance
      .collection('riderLocation')
      .doc(currentDocId)
      .snapshots();

  ref.onDispose(() {
    print("riderLocation Disposed");
  });

  return stream;
});
