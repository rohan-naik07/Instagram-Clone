import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:ui' as ui;

import 'package:shared_preferences/shared_preferences.dart';

class SplashApp extends StatefulWidget {
  final onInitializationComplete;

  const SplashApp({
    required Key key,
    @required this.onInitializationComplete,
  }) : super(key: key);

  @override
  _SplashAppState createState() => _SplashAppState();
}

class _SplashAppState extends State<SplashApp> {
  Image? logo;

  @override
  void initState() {
    super.initState();
    logo = Image.asset(
      "assets/images/logo.png",
      fit: BoxFit.contain,
      height: 42,
    );
    Timer(Duration(seconds: 3), () => _initializeAsyncDependencies());
  }

  Future<String?> _initializeAsyncDependencies() async {
    await Firebase.initializeApp();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    widget.onInitializationComplete(prefs.getString('token'));
  }

  Widget getScreen (){
    return new Scaffold(
        backgroundColor: Colors.black26,
        body: SingleChildScrollView(
          child : Column(
            children: <Widget>[
              SizedBox(height: 150),
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Center(
                  child: Container(
                      width: 100,
                      height: 100,
                      child: logo
                  ),
                ),
              ),
              SizedBox(height: 250),
              Column(
                children: <Widget>[
                  Padding(
                      padding:const EdgeInsets.only(top: 5),
                      child: Text(
                        'from',
                        style: TextStyle(color: Colors.grey, fontSize: 15,fontStyle: FontStyle.italic),
                      )
                  ),
                  Padding(
                    padding:const EdgeInsets.only(top: 5),
                    child: Text(
                      'ROHAN',
                      style: TextStyle(
                          fontSize: 25,
                          foreground: Paint()
                            ..shader = ui.Gradient.linear(
                              const Offset(0, 50),
                              const Offset(50, 30),
                              <Color>[
                                Colors.pinkAccent,
                                Colors.amber
                              ],
                            )
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    precacheImage(AssetImage( "assets/images/logo.png"), context);
    return getScreen();
  }
}