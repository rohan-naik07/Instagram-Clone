import 'package:flutter/material.dart';
import 'dart:math' as math;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Image.asset(
          "assets/images/insta_logo.png",
          fit: BoxFit.contain,
          height: 42,
        ),
        toolbarHeight: 78,
        actions: [
          Transform.rotate(
              angle: 60 * math.pi / 180,
              child: IconButton(
                icon: Icon(
                  Icons.details,
                  color: Colors.white,
                ),
                onPressed: null,
              )
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to Instagram',
            ),
          ],
        ),
      ),
    );
  }
}
