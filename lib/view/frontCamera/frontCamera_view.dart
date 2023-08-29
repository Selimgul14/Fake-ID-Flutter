import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';

import 'package:mobile/view/card_reader/card_reader_view.dart';

class FaceCaptureView extends StatefulWidget {
  const FaceCaptureView({
    super.key,
    required this.frontCamera,
  });

  final CameraDescription frontCamera;

  @override
  State<FaceCaptureView> createState() => _FaceCaptureViewState();
}

class _FaceCaptureViewState extends State<FaceCaptureView> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.frontCamera,
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
          Positioned(
            bottom: 50,
            left: 0.0,
            right: 0.0,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: FloatingActionButton.large(
                onPressed: () async {
                },
                backgroundColor: Colors.lightBlue,
                child: Icon(Icons.camera_alt),
              ),
            ),
          )
        ],
      ),
    );
  }
}
