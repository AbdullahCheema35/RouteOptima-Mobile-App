import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:route_optima_mobile_app/services/rider_selection.dart';

final assignmentStreamProvider =
    StreamProvider.autoDispose<DocumentSnapshot>((ref) {
  final currentDocId = ref.watch(riderNotifierProvider).id;
  final stream = FirebaseFirestore.instance
      .collection('assignments')
      .doc(currentDocId)
      .snapshots();

  ref.onDispose(() {
    print("Disposed");
  });

  return stream;
});
