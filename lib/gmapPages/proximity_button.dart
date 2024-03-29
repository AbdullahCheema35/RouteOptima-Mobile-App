import 'package:flutter/material.dart';
import 'package:route_optima_mobile_app/gmapPages/upload_image.dart';
import 'package:route_optima_mobile_app/gmapPages/upload_sign.dart';

class ProximityButton extends StatelessWidget {
  const ProximityButton({required this.onDelivered, super.key});

  // Store the passed callback function
  final Future<bool> Function(Map<String, dynamic>) onDelivered;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black)),
          onPressed: () {
            _showDeliveryOptionsDialog(context, onDelivered);
          },
          child: const Text("Ready to Deliver?"),
        ),
      ),
    );
  }
}

Future<void> _showDeliveryOptionsDialog(BuildContext context,
    Future<bool> Function(Map<String, dynamic>) onDelivered) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Update Delivery Status"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
              ),
              onPressed: () {
                Map<String, dynamic> deliveryData = {
                  'confirmation': false,
                  'unavailable': true,
                  'success': false,
                };

                // Open the camera to capture the unavailability proof
                Navigator.push(
                  context,
                  MaterialPageRoute<Map<String, dynamic>>(
                    builder: (context) => const TakePictureScreen(
                      title: "Upload Unavailability Proof",
                    ),
                  ),
                ).then((value) {
                  if (value != null && value['success'] == true) {
                    // Get the image path
                    final downloadLink = value['link'];

                    // Update the deliveryData
                    deliveryData['proof'] = downloadLink;
                    deliveryData['success'] = true;

                    final isNextLocation = onDelivered(deliveryData);

                    isNextLocation.then((value) {
                      Navigator.pop(context);

                      if (!value) {
                        // Show dialog to user
                        showAssignmentCompletionDialog(context);
                      }
                    });
                  }
                });
              },
              child: const Text("Customer Unavailable"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
              ),
              onPressed: () async {
                Map<String, dynamic> deliveryData = {
                  'confirmation': true,
                  'unavailable': false,
                  'success': false,
                };

                // Open the signature page
                Navigator.push(
                  context,
                  MaterialPageRoute<Map<String, dynamic>>(
                      builder: (context) => const SignaturePage()),
                ).then((sigValue) {
                  if (sigValue == null || sigValue['success'] == false) {
                    return;
                  } else if (sigValue['success'] == true) {
                    Navigator.push(
                      context,
                      MaterialPageRoute<Map<String, dynamic>>(
                        builder: (context) => const TakePictureScreen(
                          title: "Upload CNIC",
                        ),
                      ),
                    ).then((cnicValue) {
                      if (cnicValue != null && cnicValue['success'] == true) {
                        // Get the signature image path
                        final signatureLink = sigValue['link'];
                        // Get the CNIC image path
                        final cnicLink = cnicValue['link'];
                        // Get the receiver's name
                        final receiverName = sigValue['receiverName'];

                        // Update the deliveryData
                        deliveryData['sign'] = signatureLink;
                        deliveryData['cnic'] = cnicLink;
                        deliveryData['receiverName'] = receiverName;
                        deliveryData['success'] = true;

                        final isNextLocation = onDelivered(deliveryData);

                        isNextLocation.then((value) {
                          Navigator.pop(context);

                          if (!value) {
                            // Show dialog to user
                            showAssignmentCompletionDialog(context);
                          }
                        });
                      }
                    });
                  }
                });
              },
              child: const Text("Delivered Successfully"),
            ),
          ],
        ),
      );
    },
  );
}

// Show assignment completion dialog to user
void showAssignmentCompletionDialog(BuildContext context) {
  // Show a dialog to the user
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Assignment Completed'),
        content: const Text('All parcels have been delivered.'),
        actions: [
          TextButton(
            onPressed: () {
              // Pop two times to go back to the assignment details screen
              Navigator.of(context)
                ..pop()
                ..pop();
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}
