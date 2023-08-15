import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mobile/view/camera/camera_view.dart';
import 'package:mobile/view/consent/consent_view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CameraDescription>? cameras;
  late CameraDescription firstCamera;
  late CameraDescription frontCamera;
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();

    if (cameras!.isNotEmpty) {
      firstCamera = cameras!.first;
      frontCamera = cameras!.firstWhere(
        (CameraDescription camera) =>
            camera.lensDirection == CameraLensDirection.front,
      );
      setState(() {
        isCameraInitialized = true;
      });
    } else {
      // Handle the error, e.g., show a message to the user
      print('No cameras found!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffecf2ff),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to FraudBusters',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Image.asset("assets/images/logo.png"),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: isCameraInitialized
                      ? () {
                          // Use firstCamera to open the camera view or perform other actions.
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ConsentPage(
                                      camera: firstCamera,
                                      frontCamera: frontCamera,
                                    )),
                          );
                        }
                      : null,
                  child: const Text(
                    'Tap to start ID verification',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.lightBlueAccent),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.all(
                              10))), // Disables the button if the camera isn't initialized.
                ),
              ],
            ),
          ),
        ));
  }
}
