import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  List<String> capturedImages = [];

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
        // Get a specific camera from the list of available cameras.
        widget.camera,
        // Define the resolution to use.
        ResolutionPreset.medium,
        imageFormatGroup: ImageFormatGroup.yuv420);

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fill this out in the next steps.
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            if (!mounted) return;

            capturedImages.add(image.path);

            if (capturedImages.length == 2) {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DisplayPictureScreen(
                    imagePaths: capturedImages,
                  ),
                ),
              );
              capturedImages.clear();
            }
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class DisplayPictureScreen extends StatefulWidget {
  final List<String> imagePaths;

  const DisplayPictureScreen({Key? key, required this.imagePaths}) : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  String? _pdfPath;

  Future<void> generatePdf() async {
    final pdf = pdfWidgets.Document();

    for (String path in widget.imagePaths) {
      final image = pdfWidgets.MemoryImage(File(path).readAsBytesSync());
      pdf.addPage(pdfWidgets.Page(
          build: (pdfWidgets.Context context) => pdfWidgets.Center(child: pdfWidgets.Image(image))
      ));
    }

    final directory = await getApplicationDocumentsDirectory();
    final pdfFile = File("${directory.path}/output.pdf");
    await pdfFile.writeAsBytes(await pdf.save());
    
    setState(() {
      _pdfPath = pdfFile.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Pictures')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.imagePaths.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.file(File(widget.imagePaths[index])),
                );
              },
            ),
          ),
          if (_pdfPath != null)
            ElevatedButton(
              onPressed: () => sendToServer(_pdfPath!),
              child: const Text("Send PDF to server")
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: generatePdf,
        child: const Icon(Icons.picture_as_pdf),
      ),
    );
  }
}


Future<void> sendToServer(String pdfPath) async {
  final pdfFile = File(pdfPath);
  final request = http.MultipartRequest('POST', Uri.parse('YOUR_SERVER_ENDPOINT'));
  request.files.add(await http.MultipartFile.fromPath('pdf_file', pdfFile.path));
  
  final response = await request.send();

  if (response.statusCode == 200) {
    print('PDF uploaded successfully.');
  } else {
    print('Failed to upload PDF.');
  }
}