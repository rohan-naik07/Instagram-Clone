import 'package:flutter/material.dart';
import 'package:first_flutter_project/auth/login.dart';
import 'package:first_flutter_project/home/home.dart';
import 'package:first_flutter_project/start.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      MaterialApp(
        title: 'Instagram Clone',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.black,
        ),
        home: SplashApp(
          key: UniqueKey(),
          onInitializationComplete: (token) => runMainApp(token),
        ),
      )
  );
}

void runMainApp(token) {
  if(token!=null){
    runApp(
        MaterialApp(
          title: 'Instagram Clone',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.black,
          ),
          home: MyHomePage(),
        )
    );
  } else {
    runApp(
        MaterialApp(
          title: 'Instagram Clone',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.black,
          ),
          home: LoginPage(),
        )
    );
  }
}

