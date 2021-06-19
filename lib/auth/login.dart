import 'package:first_flutter_project/home/home.dart';
import 'package:flutter/material.dart';
import 'package:first_flutter_project/auth/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final _emailIdController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');

  String? errorMessage = '';
  String? successMessage = '';
  String? _emailId;
  String? _password;
  bool hasLoaded = true;

  Future<void> setCredentials (token,email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    prefs.setString('user-email', email);
  }

  Future<User?> signIn (email, password) async {
    try {
      UserCredential user = await auth.signInWithEmailAndPassword(
          email: email.toString(),
          password: password.toString()
      );
      return user.user;
    } on PlatformException catch(error){
      throw error;
    }
  }

  handleError(PlatformException error) {
    print('error');
    print(error);
    setState(() {
      errorMessage = error.message;
      hasLoaded = true;
    });
  }

  String? validateEmail(String? value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern.toString());
    if (value.toString().isEmpty || !regex.hasMatch(value.toString()))
      return 'Enter Valid Email Id';
    else
      return null;
  }

  String? validatePassword(String? value) {
    if (value.toString().trim().isEmpty || value.toString().length < 6 || value.toString().length > 14) {
      return 'Minimum 6 & Maximum 14 Characters';
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
            Form(
              autovalidateMode: AutovalidateMode.always, key: _formStateKey,
              child: Column(
                children: <Widget> [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      validator: validateEmail,
                      onSaved: (value) {
                        _emailId = value;
                      },
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailIdController,
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
                    child: TextFormField(
                        validator: validatePassword,
                        onSaved: (value) {
                          _password = value;
                        },
                        controller: _passwordController,
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
                ],
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
                  onPressed: () {
                    if (_formStateKey.currentState!.validate()) {
                      _formStateKey.currentState!.save();
                      setState(()=>hasLoaded = false);
                      try {
                        signIn(_emailId, _password).then((user) {
                          if (user != null) {
                            setState(() {
                              successMessage = 'Logged In Successfully';
                              hasLoaded = true;
                            });
                            setCredentials(user.getIdToken().toString(), _emailId)
                                .then((value) => {
                                    Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                        builder: (context) => MyHomePage()
                                      ),
                                    )
                                  }
                                );
                          } else {
                            print('Error while Login.');
                            setState(()=>hasLoaded = true);
                            setState(() {
                              errorMessage = 'Error while Login.';
                            });
                          }
                      });
                      } on PlatformException catch (e) {
                        handleError(e);
                      }
                    }
                  },
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
            hasLoaded==false ? Center(child: CircularProgressIndicator())
            : (successMessage != '' ? Text(
                successMessage.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.green),
            ) : errorMessage !='' ? Text(
                successMessage.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.red)
            ) : Container()),
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