import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:first_flutter_project/chat/chats.dart';
import 'package:first_flutter_project/chat/messages.dart';
import 'package:first_flutter_project/futils/auth.dart';
import 'package:first_flutter_project/futils/chat.dart';
import 'package:first_flutter_project/futils/posts.dart';
import 'package:first_flutter_project/home/userInfo.dart';
import 'package:first_flutter_project/posts/comments.dart';
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
  void dispose() {
    super.dispose();
    Auth().updateUser(user['_id'], {'last_seen' : DateTime.now().toString()});
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                       Transform.rotate(
                        angle: -40 * math.pi / 180,
                        child: IconButton(
                          icon: Icon(
                            Icons.send,
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: (){
                           showModalBottomSheet(context: context, 
                            builder: (context){
                              return chatModal(post.id);
                              }
                            );
                          },
                        )
                      )
                    ],
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
                  RichText(
                    text: TextSpan(
                      text: '${post['user_name']} ',
                      style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(text: '${post['description']}', style:TextStyle(fontSize: 15,fontWeight: FontWeight.normal)),
                      ],
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
                                hintText: 'Add a comment....',
                                hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                                contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                            ),
                          ),
                      ),
                     TextButton(
                        onPressed: () {
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
                        child: Text('Send',style: TextStyle(color: Colors.blue,fontSize: 15)),
                      ),
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

  Widget chatModal(postId){
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(10),
      child: FutureBuilder(
        future: Chat().getYourChats(user['_id']),
        builder:(BuildContext context,AsyncSnapshot<dynamic> snapshot){
          if(snapshot.hasData){
            var chats = snapshot.data;
            return Column(
              children : [
                Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[800]
                    ),
                  child: Padding(
                      padding: const EdgeInsets.only(left: 5,right: 5),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            size: 20,
                            color: Colors.white,
                          ),
                        Expanded(
                            child: TextField(
                                //controller: _searchQueryController,
                                onChanged: (value) async {},
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    hintText: 'Search',
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ),
                            )
                          ],
                        )
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: chats!.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            var chat = chats[index];
                            var recepientId = chat['participants'][0] == user['_id'] ? chat['participants'][1] : chat['participants'][0];
                            return FutureBuilder(
                              future: Auth().getUserbyId(recepientId),
                              builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot){
                                if(snapshot.hasData){
                                  var recepient = snapshot.data;
                                    return GestureDetector(
                                      onTap: (){
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                              builder: (context) => MessagesPage(
                                                userId1: user['_id'],
                                                userId2: recepient['_id'], 
                                                currentUserId: user['_id'],
                                                chatId: chat.id,
                                                postId: postId,
                                              )
                                            ),
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget> [
                                          CircleAvatar(
                                              radius: 25.0,
                                              backgroundImage: CachedNetworkImageProvider("${recepient['photoUrl']}"),
                                              backgroundColor: Colors.transparent,
                                          ),
                                          Expanded(
                                            child: Padding(
                                            padding: const EdgeInsets.only(left: 5),
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget> [
                                                  Text(
                                                      '${recepient['user_name']}',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15
                                                    ),
                                                  ),
                                                  Text(
                                                      '${recepient['email']}',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12
                                                    ),
                                                  )
                                                ],
                                              )
                                            )
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.camera_alt_outlined,
                                              size: 25,
                                              color: Colors.grey,
                                            ),
                                            onPressed: null
                                          )
                                        ],
                                      ),
                                    );
                                }
                                return Center(child: CircularProgressIndicator());
                              }
                            );
                          }
                      ),
                    ),
                  ]
                );
              }
          return Center(child: CircularProgressIndicator());
        }
      ),
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
          height: 40,
        ),
        backgroundColor: Colors.black,
        actions: [
          Transform.rotate(
              angle: 60 * math.pi / 180,
              child: IconButton(
                icon: Icon(
                  Icons.details_sharp,
                  color: Colors.white,
                ),
                onPressed: (){
                  Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context)=>ChatsPage()
                    )
                  );
                },
              )
          )
        ],
      ),
      body: FutureBuilder<dynamic>(
        future: Post().getPosts(),
        builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot){
          if(snapshot.hasData){
            posts = [];
            var postsData = snapshot.data;
            likes = new Map<String,List<dynamic>>();
            comments = new Map<String,List<dynamic>>();
            postsData!.forEach((post) {
              if(user['following'].contains(post['user_name'])){
                posts!.add(post);
                likes![post.id] = post['likes'];
                comments![post.id] = post['comments'];
              }
            });

            if(posts!.length==0){
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                    'No posts to display',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      'Search and follow people to see their posts',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15
                      ),
                    )
                  ],
                )
              );
            }

            return new ListView.builder(
                itemCount: posts!.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return renderPost(posts![index],user)!;
                }
            );
          }
          return Center(child: CircularProgressIndicator());
        }
      )
    );   
  }
}
