import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:route_optima_mobile_app/gmapPages/firebase_storage.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key});

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
      appBar: AppBar(title: const Text('Take a picture')),
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
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final imageTaken = await _controller.takePicture();
            // Convert the image to bytes
            final imageBytes = await imageTaken.readAsBytes();

            if (!context.mounted) return;

            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  imageBytes: imageBytes,
                ),
              ),
            );
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

  const DisplayPictureScreen({super.key, required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Image.memory(imageBytes),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                // Retake the picture
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.replay),
            ),
            IconButton(
              onPressed: () async {
                // Save Image to cloud storage
                await uploadImage(imageBytes);
                print('Image saved');

                // Close the image display screen and the camera screen
                Navigator.of(context)
                  ..pop()
                  ..pop();
              },
              icon: const Icon(Icons.cloud_upload),
            ),
            IconButton(
              onPressed: () {
                // Cancel the image upload
                Navigator.of(context)
                  ..pop()
                  ..pop();
              },
              icon: const Icon(Icons.cancel),
            ),
          ],
        ),
      ),
    );
  }
}
