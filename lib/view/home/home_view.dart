import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/view/camera/camera_view.dart';
import 'package:mobile/view/consent/consent_view.dart';
import 'package:mobile/view/steps/steps_view.dart';

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
  final String assetName = "assets/images/logo.svg";

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
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/background_test.png"),
          fit: BoxFit.cover,
        )),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FractionallySizedBox(
                  heightFactor: 1 / 3,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: isCameraInitialized
                          ? () {
                              // Use firstCamera to open the camera view or perform other actions.
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StepsView(
                                          camera: firstCamera,
                                          frontCamera: frontCamera,
                                        )),
                              );
                            }
                          : null,
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          )),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xff5aa5d8)),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.all(10))),
                      child: const Text(
                        'Müşterimiz olmak için dokunun',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ), // Disables the button if the camera isn't initialized.
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
