import 'package:flutter/material.dart';
import 'package:first_flutter_project/auth/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailIdController = TextEditingController(text: '');
  final _userNameController = TextEditingController(text: '');
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? errorMessage = '';
  String? successMessage = '';
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  String? _emailId;
  String? _password;

  Future<User?> signIn (email, password) async {
    try {
      UserCredential user = await auth.signInWithEmailAndPassword(
          email: email.toString(),
          password: password.toString()
      );
      assert(user != null);
      assert(await user.user!.getIdToken() != null);
      return user.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } on PlatformException catch (e) {
      handleError(e);
    }
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        setState(() {
          errorMessage = 'Email Id already Exist!!!';
        });
        break;
      default:
    }
  }

  String? validateEmail(String? value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern.toString());
    if (value.toString().isEmpty || !regex.hasMatch(value.toString()))
      return 'Enter Valid Email Id!!!';
    else
      return null;
  }

  String? validatePassword(String? value) {
    if (value.toString().trim().isEmpty || value.toString().length < 6 || value.toString().length > 14) {
      return 'Minimum 6 & Maximum 14 Characters!!!';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget> [
            SizedBox(height: 130),
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    child: Image.asset(
                      "assets/images/insta_logo.png",
                      fit: BoxFit.contain,
                      height: 42,
                    ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: Colors.white10,
                    filled: true,
                    hintText: 'Email',
                    hintStyle: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                obscureText: true,
                  style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: Colors.white10,
                    filled: true,
                    hintText: 'Password',
                    hintStyle: TextStyle(fontSize: 15, color: Colors.white),
                )
              ),
            ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Container(
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10)
                ),
              child: TextButton(
                onPressed: null,
                child: Text(
                  'Log In',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
            TextButton(
              onPressed:null,
              child: Text(
                'Forgotten your login credentials? Get help logging in',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            SizedBox(height: 130),
            TextButton(
              onPressed:(){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              child: Text(
                'New User? Create Account',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ),
          ],
        )
      )
    );
  }
}