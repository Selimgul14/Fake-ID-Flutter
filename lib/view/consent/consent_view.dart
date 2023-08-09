import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mobile/view/camera/camera_view.dart';

class ConsentPage extends StatefulWidget {
  const ConsentPage({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;
  @override
  _ConsentPageState createState() => _ConsentPageState();
}

class _ConsentPageState extends State<ConsentPage> {
  bool isConsentGiven = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffecf2ff),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/idCard.jpg',
                      height: 150), // replace 'image.jpg' with your image name
                  SizedBox(height: 20),
                  Text(
                    'We will process your credentials for security verification purposes. In order for us to verify your ID card, you need to scan your card after taking a photo of the front and back of your ID.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'I consent to the processing of my personal data that I have given to FraudBusters only for the purpose of identity verification.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Switch.adaptive(
                  value: isConsentGiven,
                  onChanged: (value) {
                    setState(() {
                      isConsentGiven = value;
                    });
                  },
                ),
              ],
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                child: Text('Start ID Verification'),
                onPressed: isConsentGiven
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TakePictureScreen(camera: widget.camera)),
                        );
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}