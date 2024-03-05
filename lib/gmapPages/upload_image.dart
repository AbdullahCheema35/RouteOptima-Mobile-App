import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:route_optima_mobile_app/gmapPages/firebase_storage.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({required this.title, super.key});
  final String title;

  @override
  State<TakePictureScreen> createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  late final List<CameraDescription> _cameras;

  Future<void> initCameraFunctions() async {
    _cameras = await availableCameras();

    _controller = CameraController(
      _cameras.first,
      ResolutionPreset.max,
    );

    return _controller.initialize();
  }

  @override
  void initState() {
    super.initState();

    _initializeControllerFuture = initCameraFunctions();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final imageTaken = await _controller.takePicture();
            // Convert the image to bytes
            final imageBytes = await imageTaken.readAsBytes();

            if (!context.mounted) return;

            Navigator.push(
              context,
              MaterialPageRoute<Map<String, dynamic>>(
                builder: (context) => DisplayPictureScreen(
                  title: widget.title,
                  imageBytes: imageBytes,
                ),
              ),
            ).then((value) {
              if (value != null) {
                if (value['success'] == 1) {
                  // Image uploaded
                  value['success'] = true;
                  Navigator.pop(context, value);
                } else if (value['success'] == 0) {
                  // Image upload canceled
                  value['success'] = false;
                  Navigator.pop(context, value);
                }
              }
            });
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final Uint8List imageBytes;
  final String title;

  const DisplayPictureScreen(
      {super.key, required this.imageBytes, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Image.memory(imageBytes),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                // 1 if image uploaded, 0 if canceled, -1 if retake
                Map<String, dynamic> result = {
                  'success': -1,
                };
                // Retake the picture
                Navigator.pop(context, result);
              },
              icon: const Icon(Icons.replay),
            ),
            IconButton(
              onPressed: () async {
                // Save Image to cloud storage
                String downloadURL = await uploadImage(imageBytes);
                print('Image saved');

                // 1 if image uploaded, 0 if canceled, -1 if retake
                Map<String, dynamic> result = {
                  'success': 1,
                  'link': downloadURL,
                };

                // Close the image display screen and the camera screen
                Navigator.pop(context, result);
              },
              icon: const Icon(Icons.cloud_upload),
            ),
            IconButton(
              onPressed: () {
                // 1 if image uploaded, 0 if canceled, -1 if retake
                // 1 if image uploaded, 0 if canceled, -1 if retake
                Map<String, dynamic> result = {
                  'success': 0,
                };

                // Cancel the image upload
                Navigator.pop(context, result);
              },
              icon: const Icon(Icons.cancel),
            ),
          ],
        ),
      ),
    );
  }
}
