import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_flutter_project/futils/posts.dart';
import 'package:first_flutter_project/home/userInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'ImageModel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:io';

class SubmitPage extends StatefulWidget {
  @override
  _SubmitState createState() => _SubmitState();
}

class _SubmitState extends State<SubmitPage> {
  var date = new DateTime.now();
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController(text: '');
  String? errorMessage = '';
  String _description = '';
  bool hasLoaded = true;

  Future<void> submitPost(var user,List<File> photos,BuildContext context) async {
    setState(() {
      hasLoaded = false;
    });
    //print(_description);

    try{
      await Post().addPost(user['user_name'], user['photoUrl'] ,photos,_description,date,user['_id']);
      var imageModel = context.read<ImageModel>();
      imageModel.removeAll();
      Navigator.pop(context);
    } on FirebaseException catch(error) {
      print(error.message);

      setState(() {
        hasLoaded = true;
        errorMessage = error.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var photos = context.watch<ImageModel>();
    var infoProvider = context.read<UserModel>();
    var user = infoProvider.info;
    return Scaffold(
      appBar : AppBar(
        title: Text('New Post', style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
        body : SingleChildScrollView(
          child : Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Row(
                    children: [
                      CircleAvatar(
                        radius: 25.0,
                        backgroundImage:
                        NetworkImage("${user['photoUrl']}"),
                        backgroundColor: Colors.transparent,
                      ),
                      Expanded(
                        /*1*/
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /*2*/
                            Container(
                                padding: const EdgeInsets.only(left: 8),
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: Text(
                                    '${user['user_name']}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20
                                    ),
                                  ),
                                )
                            ),
                            Container(
                                padding: const EdgeInsets.only(left: 8),
                                child:Material(
                                  type: MaterialType.transparency,
                                  child: Text(
                                    '${date.day}/${date.month}/${date.year}',
                                    style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 10
                                    ),
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child : CarouselSlider(
                    options: CarouselOptions(
                      height: 400,
                      aspectRatio: 16/9,
                      viewportFraction: 1.0,
                      initialPage: 0,
                      enableInfiniteScroll: false,
                    ),
                    items: photos.photos.map((image) {
                      return Builder(
                        builder: (BuildContext context) {
                          return  Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: Image.file(image).image,
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: null
                        );
                        },
                      );
                    }).toList(),
                  ),
                ),
                Form(
                  autovalidateMode: AutovalidateMode.always, key: _formStateKey,
                  child : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      onChanged: (value) {
                        _description= value;
                      },
                      controller: _descriptionController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Colors.white10,
                        filled: true,
                        hintText: 'Description',
                        hintStyle: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
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
                      onPressed: () async { await submitPost(user,photos.photos,context);},
                      child: Text(
                        'Post!',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
                hasLoaded==false ?  Center(child: CircularProgressIndicator())
                    : errorMessage !='' ? Text(
                    errorMessage.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.red)
                ) : Container()
              ],
            ),
          ),
        )
      );
    }
}