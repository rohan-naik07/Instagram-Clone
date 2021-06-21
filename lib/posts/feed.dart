import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_flutter_project/auth/login.dart';
import 'package:first_flutter_project/futils/posts.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  Widget? renderPost (post){
    List<Widget> images = [];
    post['images'].map((var image)=>images.add(Image.network(image)));
    return Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0,top: 20.0),
                child : Row(
                  children: [
                    CircleAvatar(
                      radius: 25.0,
                      backgroundImage:
                      NetworkImage("${post['photoUrl']}"),
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
                                  '${post['user_name']}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20
                                  ),
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child : CarouselSlider(
                  options: CarouselOptions(
                    height: 400,
                    aspectRatio: 16/9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: false,
                  ),
                  items: images.map((image) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            child: image,
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ]
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: Post().getPosts(),
        builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot){
          if(snapshot.hasData){
            var posts = snapshot.data;
            return new ListView.builder(
                itemCount: posts.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return renderPost(posts[index])!;
                }
            );
          }
          return Container();
        }
    );
  }
}
