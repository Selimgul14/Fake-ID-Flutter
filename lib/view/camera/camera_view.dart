import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:mobile/core/widgets/progress_indicator.dart';
import 'package:mobile/view/frontCamera/frontCamera_view.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:quickalert/quickalert.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
    required this.frontCamera,
  });

  final CameraDescription camera;
  final CameraDescription frontCamera;

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
      backgroundColor: const Color(0xffecf2ff),
      body: Stack(
        children: <Widget>[
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                  child: CameraPreview(_controller!),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          Align(
            alignment: Alignment.center,
            child: IDCardSizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
          if (isLoading) const Center(child: CircularProgressIndicator()),
          Positioned(
            top: 80.0,
            left: 0.0,
            right: 0.0,
            child: Center(
                child: Text(
              photoStep,
              style: GoogleFonts.poppins(
                color: const Color.fromARGB(255, 59, 59, 61),
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            )),
          ),
          Positioned(
            bottom: 60,
            left: 30,
            child: FloatingActionButton(
              backgroundColor: Color(0xff5aa5d8),
              child: Icon(Icons.arrow_back_ios_new_outlined),
              onPressed: () => Navigator.of(context).pop(),
              heroTag: null,
            ),
          ),
          Positioned(
            bottom: 50,
            left: 170,
            child: FloatingActionButton.large(
              backgroundColor: Color(0xff5aa5d8),
              child: Icon(Icons.camera_alt),
              onPressed: () async {
                if (!isLoading) {
                  await captureImage();
                }
              },
              heroTag: null,
            ),
          )
        ],
      ),
    );
  }

  // Variables for button animation
  double _scale = 1;
  void _onTapDown(TapDownDetails details) {
    _scale = 0.9;
    setState(() {});
  }

  void _onTapUp(TapUpDetails details) {
    _scale = 1;
    setState(() {});
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
            frontCamera: widget.frontCamera,
          ),
        ),
      );
    }
  }
}

class DisplayPictureScreen extends StatefulWidget {
  final List<String> imagePaths;
  final CameraDescription frontCamera;

  const DisplayPictureScreen({
    Key? key,
    required this.imagePaths,
    required this.frontCamera,
  }) : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  String? _pdfPath;

  Future<void> generatePdf() async {
    final pdf = pdfWidgets.Document();

    for (String path in widget.imagePaths) {
      File imagefile = File(path);
      Uint8List imagebytes = await imagefile.readAsBytes();
      String base64string = base64.encode(imagebytes);
      print(base64string);
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    /*DialogBuilder(context).showLoadingIndicator(
                        "Please wait until your ID is processed. This process may take up to 20 seconds");
                    await Future.delayed(const Duration(seconds: 5));
                    DialogBuilder(context).hideOpenDialog();*/

                    await QuickAlert.show(
                        autoCloseDuration: const Duration(seconds: 10),
                        context: context,
                        type: QuickAlertType.loading,
                        title: "Please wait",
                        text:
                            "We are checking your ID. \n This process may take up to 20 seconds.");

                    if (context.mounted) {
                      await QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          autoCloseDuration: const Duration(seconds: 5),
                          showConfirmBtn: false,
                          title: "Success!",
                          text: "We have successfully verified your ID!");
                    }
                    /*File imagefile = File(widget.imagePaths[0]);
                    Uint8List imagebytes = await imagefile.readAsBytes();
                    String base64Front = base64.encode(imagebytes);
                    imagefile = File(widget.imagePaths[1]);
                    Uint8List imagebytes = await imagefile.readAsBytes();
                    String base64Back = base64.encode(imagebytes);
                    //await sendImageToServer(base64Front, base64Back);*/
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FaceCaptureView(
                                frontCamera: widget.frontCamera)),
                      );
                    }
                  },
                  child: const Text("Send image to server"),
                  style: ButtonStyle(
                      alignment: Alignment.center,
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.orange)),
                ),
              ),
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: generatePdf,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.picture_as_pdf),
      ),
    );
  }
}

Future<void> sendImageToServer(String base64Front, String base64Back) async {
  var url = Uri.parse('http://46.101.238.61:8000/before_api/api/');

  var response = await http.post(url, body: {
    'id_card_front': base64Front,
    'id_card_back': base64Back,
  });

  if (response.statusCode == 200 || response.statusCode == 201) {
    print("Image sent successfully");
  } else {
    print("Failed to send image: ${response.statusCode}");
  }
}

class IDCardSizedBox extends StatelessWidget {
  final double width;
  final Color color;

  IDCardSizedBox({required this.width, this.color = Colors.black})
      : assert(width > 0);

  @override
  Widget build(BuildContext context) {
    // Standard ID card aspect ratio (CR80: 3.375 in x 2.125 in)
    const aspectRatio = 3.375 / 2.125;

    return SizedBox(
        width: width,
        height: width / aspectRatio,
        child: Container(
          decoration: BoxDecoration(
            border:
                Border.all(color: color, width: 6, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(10),
          ),
        ));
  }
}
