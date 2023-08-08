import 'package:flutter/material.dart';
import 'dart:io';

import 'package:mobile/view/home/home_view.dart';

Future<void> main() async {
  await _init();

  try {
    final result = await InternetAddress.lookup('164.92.208.145');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      runApp(
        const MyApp(),
      );
    }
  } on SocketException catch (_) {
    runApp(const NoInt());
  }
}

Future<void> _init() async {
  WidgetsFlutterBinding.ensureInitialized();

}

class NoInt extends StatelessWidget {
  const NoInt({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'No Internet Connection',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "FraudBusters requires internet connection to run\n           Please check your connection.",
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: OutlinedButton(
                    onPressed: () async {
                      try {
                        final result = await InternetAddress.lookup('google.com');
                        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                          runApp(
                            const MyApp(),
                          );
                        }
                      } on SocketException catch (_) {
                        debugPrint("No Internet Connection");
                      }
                    },
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.black,
                        primary: Colors.white,
                        fixedSize: const Size(150, 50),
                        side: const BorderSide(width: 1.0, color: Colors.white)),
                    child: const Text(
                      'Try Again',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}

class AvoidGlowBehavior extends ScrollBehavior{
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details){
    return child;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Home(),
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: AvoidGlowBehavior(),
          child: child!,
        );
      },
    );
  }
}