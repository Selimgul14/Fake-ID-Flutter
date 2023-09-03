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
                'You have successfully verified your identity.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'You can now open an account in our bank.',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // You can navigate to another page here, or do something else
                },
                child: Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
