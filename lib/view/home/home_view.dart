import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mobile/view/camera/camera_view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
  
}

class _HomeState extends State<Home> {
  List<CameraDescription>? cameras;
  late CameraDescription firstCamera;
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
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Welcome to FraudBusters',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          MaterialButton(
            child: const Text(
              'Tap to open the camera',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            onPressed: isCameraInitialized ? () {
                // Use firstCamera to open the camera view or perform other actions.
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TakePictureScreen(camera: firstCamera)),
                );
              } : null, // Disables the button if the camera isn't initialized.
            ),
        ],
      ),
    )
    );
  }
}
