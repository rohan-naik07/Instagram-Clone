import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_flutter_project/auth/login.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> removeCredentials () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('user-id');
  }

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
              style: TextStyle(color: Colors.white, fontSize: 20)
            ),
            Text(
                user!.uid.toString(),
                style: TextStyle(color: Colors.grey, fontSize: 15)
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                height: 50,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: TextButton(
                  onPressed: () {
                      FirebaseAuth.instance.signOut().then((value)=>{
                        removeCredentials().then((value) => {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                                builder: (context) => LoginPage()
                                ),
                            )
                        })
                      });
                    },
                  child: Text(
                    'Log Out',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
