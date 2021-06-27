import 'package:first_flutter_project/auth/login.dart';
import 'package:first_flutter_project/futils/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final Auth instance = new Auth();
  int _index = 0;
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final _emailIdController = TextEditingController(text: '');
  final _userNameController = TextEditingController(text: '');
  final _fullNameController = TextEditingController(text: '');
  final _bioController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');
  final _confirmPasswordController = TextEditingController(text: '');

  String? errorMessage = '';
  String? successMessage = '';
  String? _emailId;
  String? _password;
  String _userName='';
  String _fullName='';
  String _bio='';

  bool hasLoaded = true;
  File? imageFile;

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("From where do you want to take the photo?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        _openGallery(context);
                      },
                    )
                  ],
                ),
              ));
        });
    }

  _openGallery(BuildContext context) async {
    var picture = await ImagePicker().getImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = File(picture!.path);
    });
    Navigator.of(context).pop();
  }

  Future<User?> signUp (email, password) async {
      try {
        UserCredential user = await auth.createUserWithEmailAndPassword(
            email: email.toString(),
            password: password.toString()
        );
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
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|'
          r'(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]'
          r'{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
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

    String? validateConfirmPassword(String? value) {
      if (value.toString().trim() != _passwordController.text.trim()) {
        return 'Passwords Mismatch!!!';
      }
      return null;
    }

    Widget step1 (){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
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
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
            //padding: EdgeInsets.symmetric(horizontal: 15),
            child: TextFormField(
                validator: validatePassword,
                onSaved: (value) => _password = value,
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
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
            child: TextFormField(
                validator: validateConfirmPassword,
                controller: _confirmPasswordController,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.white10,
                  filled: true,
                  hintText: 'Confirm Password',
                  hintStyle: TextStyle(fontSize: 15, color: Colors.white),
              )
            ),
          ),
        ],
      );
    }
  Widget step2 (){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
            child: TextFormField(
              onSaved: (value) {
                _userName = value.toString();
              },
              controller: _userNameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Colors.white10,
                filled: true,
                hintText: 'User Name',
                hintStyle: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
            child: TextFormField(
                controller: _fullNameController,
                onSaved: (value) {
                _fullName = value.toString();
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.white10,
                  filled: true,
                  hintText: 'Your Display Name',
                  hintStyle: TextStyle(fontSize: 15, color: Colors.white),
              )
            ),
          ),
        ],
      );
    }

    Widget step3 (){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
            Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
            child: TextFormField(
                controller: _bioController,
                onSaved: (value) => _bio = value!,
                style: TextStyle(color: Colors.white),
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.white10,
                  filled: true,
                  hintText: 'Add your Bio',
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
                      onPressed: () async {
                        if (_formStateKey.currentState!.validate()) {
                          _formStateKey.currentState!.save();
                          setState(()=>hasLoaded = false);
                          signUp(_emailId, _password).then((user) async {
                            String? url = await instance.uploadPhoto(imageFile!, this._userName);
                            if (user != null) {
                              instance.addUser(_userName,_fullName,_emailId,_bio,url).then((value) {
                                setState(() {
                                  successMessage = 'Registered Successfully';
                                });
                                setState(()=>hasLoaded = true);
                                Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()
                                  ),
                                );
                              }).catchError((error) {
                                print("Failed to add user: $error");
                                setState(()=>{
                                  hasLoaded = true,
                                  errorMessage = "Failed to add user: $error"
                                });
                              });
                            } else {
                              setState(()=>hasLoaded = true);
                              print('Error while Login.');
                              setState(() {
                                errorMessage = 'Error while Login.';
                              });
                            }
                          });
                        }
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
           hasLoaded==false ?  Center(child: CircularProgressIndicator())
                 : (successMessage != '' ? Text(
                  successMessage.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.green),
                ) : errorMessage !='' ? Text(
                    successMessage.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.red)
              ) : Container()),
        ],
      );
    }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(title: Text('Sign In'),),
        body: ListView(
            
              children: <Widget> [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Center(
                    child: Container(
                      child: GestureDetector(
                        onTap: () async { await _showSelectionDialog(context); },
                        child : imageFile != null ?
                        CircleAvatar(
                          radius: 60.0,
                          backgroundImage:Image.file(
                            imageFile!,
                            fit: BoxFit.contain,
                            height: 42,
                          ).image ,
                          backgroundColor: Colors.transparent,
                        ) :
                        Image.asset(
                          "assets/images/signup.png",
                          fit: BoxFit.contain,
                          height: 42,
                        ),
                      )
                    ),
                  ),
                ),
                Form(
                    autovalidateMode: AutovalidateMode.always, key: _formStateKey,
                    child: Stepper(
                        currentStep: _index,
                        onStepCancel: () {
                          if (_index > 0) {
                            setState(() { _index -= 1; });
                          }
                        },
                        onStepContinue: () {
                          if (_index <= 0 && _index<=3) {
                            setState(() { _index += 1; });
                          }
                        },
                        onStepTapped: (int index) {
                          setState(() { _index = index; });
                        },
                        steps: <Step>[
                          Step(
                            title: const Text('Auth',style: TextStyle(color: Colors.white)),
                            content: step1()
                          ),
                          Step(
                            title: const Text('Identity',style: TextStyle(color: Colors.white)),
                            content: step2()
                          ),
                          Step(
                            title: const Text('Bio',style: TextStyle(color: Colors.white)),
                            content: step3()
                          )
                        ],
                      )     
                    ),
               
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                     TextButton(
                      onPressed:(){
                        Navigator.pop(context);
                      },
                      child: Text('Already have an account ? Log In',style: TextStyle(color: Colors.grey, fontSize: 15),)
                    )
                  ],
                )
               
              ],
            )
        );
  }
}