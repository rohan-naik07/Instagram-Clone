import 'dart:convert';
import 'dart:io';
import 'package:first_flutter_project/futils/auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ImageModel.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SubmitPage extends StatefulWidget {
  @override
  _SubmitState createState() => _SubmitState();
}

class _SubmitState extends State<SubmitPage> {
  var date = new DateTime.now();

  Future<dynamic> getUser() async {
    SharedPreferences preferences =  await SharedPreferences.getInstance();
    String? email = preferences.get("email").toString();
    var user = await Firestore().getUser(email);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    var photos = context.watch<ImageModel>();
    // TODO: implement build
    return FutureBuilder<dynamic>(
        future: getUser(),
        builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot){
          var user = snapshot.data;
          return Container(
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30.0,
                      backgroundImage:
                      NetworkImage("${user.photoUrl}"),
                      backgroundColor: Colors.transparent,
                    ),
                    Expanded(
                      /*1*/
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          /*2*/
                          Container(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              '${user.user_name}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            '${date.day}/${date.month}/${date.year}',
                            style: TextStyle(
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                CarouselSlider(
                  options: CarouselOptions(height: 400.0),
                  items: photos.photos.map((file) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            child: Image.file(file)
                        );
                      },
                    );
                  }).toList(),
                )
              ],
            ),
          );
        }
    );
  }
}