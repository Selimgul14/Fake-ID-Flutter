import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:mobile/view/consent/consent_view.dart';

class StepsView extends StatefulWidget {
  const StepsView({
    super.key,
    required this.camera,
    required this.frontCamera,
  });

  final CameraDescription camera;
  final CameraDescription frontCamera;

  @override
  State<StepsView> createState() => _StepsViewState();
}

class _StepsViewState extends State<StepsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffecf2ff),
      appBar: AppBar(
        title: Text("Müşterimiz olun"),
        backgroundColor: Color(0xff386fa4),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              stepWidget(
                icon: const Icon(Icons.checklist),
                title: "KVKK",
                subtitle: "KVKK metnini okuyup onay verin",
              ),
              const Dash(
                direction: Axis.vertical,
                length: 100,
                dashLength: 6,
                dashColor: Color(0xff5aa5d8),
              ),
              stepWidget(
                icon: const Icon(Icons.badge),
                title: "Kimliğinizi taratın",
                subtitle:
                    "Telefonunuzun kamerası ile kimliğinizin fotoğrafını çekin",
              ),
              const Dash(
                direction: Axis.vertical,
                length: 100,
                dashLength: 6,
                dashColor: Color(0xff5aa5d8),
              ),
              stepWidget(
                icon: const Icon(Icons.video_chat),
                title: "Video görüşmesi yapın",
                subtitle:
                    "Kimlik doğrulamayı tamamlamak için, müşteri temsilcimizle video görüşmesi yapın",
              ),
              const SizedBox(height: 70),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      )),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xff5aa5d8)),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.all(10))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ConsentPage(
                                camera: widget.camera,
                                frontCamera: widget.frontCamera,
                              )),
                    );
                  },
                  child: Text("Devam"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget stepWidget(
    {required String title, required String subtitle, required Icon icon}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ElevatedButton(
        onPressed: () {},
        child: icon,
        style: ButtonStyle(
            shape: MaterialStateProperty.all(CircleBorder()),
            padding: MaterialStateProperty.all(EdgeInsets.all(20)),
            backgroundColor: MaterialStateProperty.all(Color(0xff5aa5d8))),
      ),
      SizedBox(width: 20),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    ],
  );
}
