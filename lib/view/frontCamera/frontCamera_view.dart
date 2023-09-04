import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';

import 'package:mobile/view/card_reader/card_reader_view.dart';
import 'package:mobile/view/home/home_view.dart';
import 'package:mobile/view/success/success_view.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

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
  bool verified = true;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.frontCamera,
      ResolutionPreset.high,
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
                  _controller.pausePreview();
                  await QuickAlert.show(
                      context: context,
                      type: QuickAlertType.loading,
                      title: "Lütfen Bekleyin",
                      text:
                          "Fotoğrafınızı kontrol ediyoruz. \n Bu işlem 20 saniyeye kadar sürebilir.",
                      autoCloseDuration: Duration(seconds: 10));
                  if (!verified) {
                    if (context.mounted) {
                      await QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: "Fotoğrafınızı doğrulayamadık",
                          text:
                              "Tekrar fotoğraf çekin ya da ana ekrana geri dönün",
                          showCancelBtn: true,
                          showConfirmBtn: true,
                          onConfirmBtnTap: () {
                            Navigator.pop(context);
                          },
                          onCancelBtnTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Home()),
                            );
                          });
                    } else {
                      await QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          autoCloseDuration: Duration(seconds: 5),
                          title: "Başarılı!",
                          text: "Fotoğrafınız başarıyla doğrulandı!");
                    }
                  }
                  await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SuccessView()));
                },
                backgroundColor: Colors.lightBlue,
                child: Icon(Icons.camera_alt),
              ),
            ),
          ),
          Positioned(
            top: 120.0,
            left: 0.0,
            right: 0.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                "Aydınlık bir ortamda yüzünüz tam gözükecek şekilde fotoğraf çekiniz",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
