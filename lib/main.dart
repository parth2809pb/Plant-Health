import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:plant_health/modelHelper.dart';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new MySplash(),
    theme: new ThemeData(
      primarySwatch: Colors.green,
    ),
  ));
}

class MySplash extends StatefulWidget {
  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      backgroundColor: Colors.grey[900],
      image: Image.asset("images/app_logo.png"),
      photoSize: 150.0,
      loaderColor: Colors.lightGreenAccent,
      navigateAfterSeconds: App(),
      loadingText: Text(
        "Welcome to Plant Health",
        style: new TextStyle(color: Colors.lightGreenAccent, fontSize: 20.0),
      ),
    );
  }
}
