import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_flutter_project/auth/login.dart';
import 'package:first_flutter_project/futils/posts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  Widget? renderPost (post){
    List<String> images = [];
    post['images'].forEach((image)=>images.add(image));
    return Padding(
        padding: EdgeInsets.only(left: 5,right: 5),
        child: Column(
            children: <Widget> [
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0,top:10),
                child : Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
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
                                      fontSize: 15
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
                            child: Image.memory(base64Decode(image),width: 100,height: 100)
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.favorite_border,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(child: Container()),
                  IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.bookmark,
                      size: 30,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${post['description']}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15
                    ),
                  ),
                  Text(
                    '${post['likes'].length} likes',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: TextField(
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                fillColor: Colors.white10,
                                filled: true,
                                hintText: 'Add your comment',
                                hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                              ),
                            ),
                          ),
                      ),
                      IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.send,
                          size: 40,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  Text(
                    '${post['date']}',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10
                    ),
                  ),
                ],
              )
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
