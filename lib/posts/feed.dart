import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:first_flutter_project/futils/posts.dart';
import 'package:first_flutter_project/home/userInfo.dart';
import 'package:first_flutter_project/profile/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<dynamic>? posts;
  Map<String,List<dynamic>>? likes;
  var user;

  likePost(post) async {
    if(likes![post.id]!.contains(user['email'])){
      print('disliked');
      likes![post.id]!.remove(user['email']);
    } else {
      print('liked');
      likes![post.id]!.add(user['email']);
    }
    print(likes![post.id]);
    setState(() {
      likes = likes;
    });

    Post().updatePost(post.id,{"likes" : likes![post.id]});
  }

  Widget? renderPost (post,user){
    List<String> images = [];
    post['images'].forEach((image)=>images.add(image));
    return Padding(
        padding: EdgeInsets.only(left: 5,right: 5),
        child: Column(
            children: <Widget> [
              Row(
                  children: [
                    CircleAvatar(
                      radius: 15.0,
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
                                child: TextButton(
                                onPressed: (){
                                   Navigator.push(context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfilePage(userName:post['user_name'])
                                      ),
                                    );
                                },
                                child: Text(
                                    '${post['user_name']}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15
                                  ),
                                )
                              )
                            )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              CarouselSlider(
                  options: CarouselOptions(
                    height: 400,
                    aspectRatio: 16/9,
                    viewportFraction: 1.0,
                    initialPage: 0,
                    enableInfiniteScroll: false,
                  ),
                  items: images.map((image) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                           margin: EdgeInsets.all(5),
                           decoration: BoxDecoration(
                              image: DecorationImage(
                                image: Image.memory(base64Decode(image)).image,
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: null,
                        );
                      },
                    );
                  }).toList(),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () { likePost(post); },
                    icon : post['likes'].contains(user['email']) ?
                    Icon(
                     Icons.favorite,
                      size: 30,
                      color: Colors.red,
                    ) : 
                    Icon(
                      Icons.favorite_border,
                      size: 30,
                      color: Colors.white,
                    )
                  ),
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
                children: [
                  Text(
                    '${post['description']}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15
                    ),
                  ),
                  Text(
                    '${likes![post.id]!.length} likes',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                       CircleAvatar(
                        radius: 15.0,
                        backgroundImage:
                        NetworkImage("${user['photoUrl']}"),
                        backgroundColor: Colors.transparent,
                      ),
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10,left: 10),
                            child: TextField(
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                hintText: 'Add a comment....',
                                hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                              ),
                            ),
                          ),
                      ),
                      IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.send,
                          size: 30,
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
    var infoProvider = context.read<UserModel>();
    user = infoProvider.info;
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
                  Icons.details_sharp,
                  color: Colors.white,
                ),
                onPressed: null,
              )
          )
        ],
      ),
      body: FutureBuilder<dynamic>(
        future: Post().getPosts(),
        builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot){
          if(snapshot.hasData){
            posts = snapshot.data;
            likes = new Map<String,List<dynamic>>();
            snapshot.data.forEach((post){
              likes![post.id] =  post['likes'];
            });
            return new ListView.builder(
                itemCount: posts!.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return renderPost(posts![index],user)!;
                }
            );
          }
          return Container();
        }
      )
    );   
  }
}
