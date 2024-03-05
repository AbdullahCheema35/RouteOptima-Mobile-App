import 'package:flutter/material.dart';
import 'package:route_optima_mobile_app/gmapPages/upload_image.dart';
import 'package:route_optima_mobile_app/gmapPages/upload_sign.dart';

Widget renderProximityButton(
    BuildContext context, void Function(Map<String, dynamic>) onDelivered) {
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

Future<void> _showDeliveryOptionsDialog(BuildContext context,
    void Function(Map<String, dynamic>) onDelivered) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Delivery Options"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
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
                      title: "Capture Unavailability Proof",
                    ),
                  ),
                ).then((value) {
                  if (value != null && value['success'] == true) {
                    // Get the image path
                    final downloadLink = value['link'];

                    // Update the deliveryData
                    deliveryData['proof'] = downloadLink;
                    deliveryData['success'] = true;

                    onDelivered(deliveryData);

                    Navigator.pop(context);
                  }
                });
              },
              child: const Text("Capture Unavailability Proof"),
            ),
            ElevatedButton(
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
                          title: "Take CNIC Proof",
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

                        onDelivered(deliveryData);

                        Navigator.pop(context);
                      }
                    });
                  }
                });
              },
              child: const Text("Confirm Delivery"),
            ),
          ],
        ),
      );
    },
  );
}
