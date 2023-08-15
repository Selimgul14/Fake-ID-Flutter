import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';

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
    return const Placeholder();
  }
}
