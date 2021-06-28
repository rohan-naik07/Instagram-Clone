import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:first_flutter_project/chat/chats.dart';
import 'package:first_flutter_project/chat/messages.dart';
import 'package:first_flutter_project/futils/posts.dart';
import 'package:first_flutter_project/home/userInfo.dart';
import 'package:first_flutter_project/posts/comments.dart';
import 'package:first_flutter_project/profile/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class PostsPage extends StatefulWidget {
  final List<dynamic> posts;

  const PostsPage({
    Key? key,
    required this.posts
  }) : super(key: key);
  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {

  Map<String,List<dynamic>>? likes;
  Map<String,List<dynamic>>? comments;
  var user;

  void likePost(post) async {
    if(likes![post.id]!.contains(user['_id'])){
      likes![post.id]!.remove(user['_id']);
    } else {
      likes![post.id]!.add(user['_id']);
    }
    setState(() {
      likes = likes;
    });

    Post().updatePost(post.id,{"likes" : likes![post.id]});
  }

  @override
  void initState() {
    super.initState();
    likes = new Map<String,List<dynamic>>();
    comments = new Map<String,List<dynamic>>();
    widget.posts.forEach((post) {
      likes![post.id] = post['likes'];
      comments![post.id] = post['comments'];
    });
  }

  Widget? renderPost (post,user){
    List<String> images = [];
    final _commentController = TextEditingController(text: '');
    post['images'].forEach((image)=>images.add(image));
    return Padding(
        padding: EdgeInsets.only(left: 5,right: 5),
        child: Column(
            children: <Widget> [
              Row(
                  children: [
                    CircleAvatar(
                      radius: 15.0,
                      backgroundImage: CachedNetworkImageProvider("${post['photoUrl']}"),
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
              Divider(
                thickness: 0.5,
                color: Colors.grey,
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
                           decoration: BoxDecoration(
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(image),
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
                    icon : post['likes'].contains(user['_id']) ?
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
                    '${likes![post.id]!.length} likes',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    '${post['description']}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15
                    ),
                  ),
                  Padding(padding: const EdgeInsets.only(top:5.0)),
                  post['comments'].length!=0 ? GestureDetector(
                    onTap: (){
                      Navigator.push(context,
                        MaterialPageRoute(
                          builder: (context) => CommentsPage(post:post)
                        ),
                      );
                    },
                    child: Text(
                    'View all ${comments![post.id]!.length} comments',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15
                      ),
                    )
                  ) : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                       CircleAvatar(
                        radius: 15.0,
                        backgroundImage:
                        CachedNetworkImageProvider("${user['photoUrl']}"),
                        backgroundColor: Colors.transparent,
                      ),
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10,left: 10),
                            child: TextField(
                              controller: _commentController,
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
                        onPressed: (){
                          var comment = {
                            'comment' : _commentController.text,
                            'post_id' : post.id,
                            'user_name' : user['user_name'],
                            'user-photo' : user['photoUrl'],
                            'timestamp' : DateTime.now().toString()
                          };
                          var postService = new Post();
                          postService.postComments(comment).then(
                            (value) {
                              comments![post.id]!.add(value);
                              setState(() {
                                comments = comments;
                              });
                              postService.updatePost(post.id, {'comments' : comments![post.id]});
                            }
                          );
                        },
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
        title: Text('Posts')
      ),
      body: new ListView.builder(
        itemCount: widget.posts.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return renderPost(widget.posts[index],user)!;
        }
      )
    );   
  }
}
