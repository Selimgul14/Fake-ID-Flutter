import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mobile/view/camera/camera_view.dart';

class ConsentPage extends StatefulWidget {
  const ConsentPage({
    super.key,
    required this.camera,
    required this.frontCamera,
  });

  final CameraDescription camera;
  final CameraDescription frontCamera;
  @override
  _ConsentPageState createState() => _ConsentPageState();
}

class _ConsentPageState extends State<ConsentPage> {
  bool isConsentGiven = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffecf2ff),
      body: Stack(
        children: [
          Positioned(
              top: 40,
              left: 10,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios),
              )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/idCard.jpg',
                          height:
                              150), // replace 'image.jpg' with your image name
                      const SizedBox(height: 20),
                      const Text(
                        'Kimlik bilgilerinizi güvenlik doğrulaması yapmak amacıyla işleyeceğiz. Kimlik kartınızı doğrulayabilmemiz için kimliğinizin ön ve arka yüzünün fotoğrafını çekmeniz gerekmektedir..',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'FraudBusters\'a vermiş olduğum özel nitelikli kişisel verilerimin sadece kimlik doğrulaması yapmak amacıyla işlenmesine izin veriyorum.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Switch.adaptive(
                      value: isConsentGiven,
                      onChanged: (value) {
                        setState(() {
                          isConsentGiven = value;
                        });
                      },
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Text('Kimlik Doğrulamayı Başlatın'),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        )),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xff5aa5d8)),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.all(10))),
                    onPressed: isConsentGiven
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TakePictureScreen(
                                      camera: widget.camera,
                                      frontCamera: widget.frontCamera)),
                            );
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
