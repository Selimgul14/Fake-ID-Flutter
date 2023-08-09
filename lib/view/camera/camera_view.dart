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

  String photoStep =
      "Front"; // Determines whether it's the Front or Back photo stage
  bool isLoading = false; // To show a loading indicator

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
      _initializeControllerFuture = _controller!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      body: Stack(
        children: <Widget>[
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          if (isLoading)
            const Center(
                child:
                    CircularProgressIndicator()), // Display a loading indicator
          Positioned(
            top: 50.0,
            left: 0.0,
            right: 0.0,
            child: Center(
                child: Text(photoStep,
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (!isLoading) {
            await captureImage();
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  Future<void> captureImage() async {
    isLoading = true;
    setState(() {});

    await _initializeControllerFuture;
    final image = await _controller.takePicture();

    capturedImages.add(image.path); // Store the path of the captured image

    if (!mounted) return;

    if (photoStep == "Front") {
      // Simulate a 2-second loading time after the first photo
      await Future.delayed(Duration(seconds: 2));

      // Prepare for the second photo
      isLoading = false;
      photoStep = "Back";
      setState(() {});
    } else if (photoStep == "Back") {
      isLoading = false; // Reset loading state
      setState(() {});

      // Navigate to display both images
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            imagePaths: capturedImages,
          ),
        ),
      );
    }
  }
}

class DisplayPictureScreen extends StatefulWidget {
  final List<String> imagePaths;

  const DisplayPictureScreen({Key? key, required this.imagePaths})
      : super(key: key);

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
          build: (pdfWidgets.Context context) =>
              pdfWidgets.Center(child: pdfWidgets.Image(image))));
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
                child: const Text("Send PDF to server")),
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
  final request =
      http.MultipartRequest('POST', Uri.parse('YOUR_SERVER_ENDPOINT'));
  request.files
      .add(await http.MultipartFile.fromPath('pdf_file', pdfFile.path));

  final response = await request.send();

  if (response.statusCode == 200) {
    print('PDF uploaded successfully.');
  } else {
    print('Failed to upload PDF.');
  }
}
