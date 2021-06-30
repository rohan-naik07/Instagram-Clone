import 'package:first_flutter_project/posts/create/ImageModel.dart';
import 'package:flutter/material.dart';
import 'package:first_flutter_project/auth/login.dart';
import 'package:first_flutter_project/home/home.dart';
import 'package:first_flutter_project/start.dart';
import 'package:provider/provider.dart';
import 'home/userInfo.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      MaterialApp(
        title: 'Instagram Clone',
        darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
        ),
        themeMode: ThemeMode.dark, 
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
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ImageModel>(
              create: (context) => ImageModel()
          ),
          ChangeNotifierProvider<UserModel>(
              create: (context) => UserModel()
          ),
        ],
        child : MaterialApp(
          title: 'Instagram Clone',
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            /* dark theme settings */
          ),
          themeMode: ThemeMode.dark, 
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.black,
          ),
          home: token!=null ? MyHomePage() : LoginPage(),
        )
      )
    );
}

