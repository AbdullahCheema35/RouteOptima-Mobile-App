import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadImage(Uint8List? imageData) async {
  DateTime now = DateTime.now();

  // Create a reference to the location you want to upload to in Firebase Storage
  final Reference imagesRef = FirebaseStorage.instance.ref().child(
      'unavailability_proofs/${now.year}-${now.month}-${now.day}_${now.millisecondsSinceEpoch}.png');

  // Upload the file (image) to the specified location
  await imagesRef.putData(imageData ?? Uint8List(0));
  return imagesRef.getDownloadURL();
}

Future<String> uploadSignature(Uint8List? signData) async {
  DateTime now = DateTime.now();

  // Create a reference to the location you want to upload to in Firebase Storage
  final Reference signsRef = FirebaseStorage.instance.ref().child(
      'signatures/${now.year}-${now.month}-${now.day}_${now.millisecondsSinceEpoch}.png');

  // Upload the file (image) to the specified location
  await signsRef.putData(signData ?? Uint8List(0));
  return signsRef.getDownloadURL();
}
