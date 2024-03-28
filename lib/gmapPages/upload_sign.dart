import 'package:flutter/material.dart';
import 'package:route_optima_mobile_app/gmapPages/firebase_storage.dart';
import 'package:route_optima_mobile_app/gmapPages/upload_image.dart';
import 'package:signature/signature.dart';

class SignaturePage extends StatefulWidget {
  const SignaturePage({super.key});

  @override
  State<SignaturePage> createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage> {
  late final SignatureController _controller;
  final penStrokeWidth = 5.0;
  final penColor = Colors.black;
  final bgColor = Colors.white;

  // Additional variables for name input
  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize the signature controller
    _controller = SignatureController(
      penStrokeWidth: penStrokeWidth,
      penColor: penColor,
      exportBackgroundColor: bgColor,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capture Signature'),
      ),
      body: SingleChildScrollView(
        // Enclose content in SingleChildScrollView for scrolling on smaller screens
        padding:
            const EdgeInsets.all(20.0), // Add padding for better aesthetics
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:
              CrossAxisAlignment.center, // Center elements horizontally
          children: [
            // Signature area with a decorated container
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.blueGrey, width: 2.0), // Decorative border
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
              ),
              child: Signature(
                controller: _controller,
                height: 200,
                backgroundColor: bgColor,
              ),
            ),
            const SizedBox(height: 20),

            // Text field for client name
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Receiver\'s Name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Map<String, dynamic> result = {
                      'success': false,
                    };
                    // Close the signature page
                    Navigator.pop(context, result);
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    // Clear the signature
                    _controller.clear();
                    // Clear the name field
                    nameController.clear();
                  },
                  child: const Text('Reset'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isEmpty) {
                      // If the name field is empty, display an error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter Receiver\'s name'),
                        ),
                      );
                      return;
                    }

                    if (_controller.isEmpty) {
                      // If the signature is empty, display an error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please Sign to continue'),
                        ),
                      );
                      return;
                    }

                    final futureObj =
                        uploadSignature(await _controller.toPngBytes());
                    // Show the status dialog while the signature is being saved
                    await showImageStatusDialog(context, futureObj);

                    // Wait for the signature to be saved
                    final downloadURL =
                        await futureObj; // Save the signature to cloud storage
                    print('Signature saved with URL: $downloadURL');

                    Map<String, dynamic> result = {
                      'success': true,
                      'link': downloadURL,
                      'receiverName': nameController
                          .text, // Include client name in the result
                    };

                    // Return the download URL and close the signature page
                    Navigator.pop(context, result);
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
