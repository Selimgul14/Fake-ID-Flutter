import 'package:flutter/material.dart';

class SuccessView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffecf2ff),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100.0,
              ),
              SizedBox(height: 20),
              Text(
                'Kimliğinizi başarıyla doğruladınız!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Bankamızda hesap açabilirsiniz.',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 30),
              ElevatedButton(
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
                  // You can navigate to another page here, or do something else
                },
                child: Text('Devam'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
