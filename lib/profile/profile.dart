import 'dart:convert';
import 'package:first_flutter_project/futils/posts.dart';
import 'package:first_flutter_project/home/userInfo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final String userName;

  const ProfilePage({
    Key? key,
    required this.userName,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Post post = new Post();
  @override
  Widget build(BuildContext context) {
    var provider = context.read<UserModel>().info!;
    var user = widget.userName == "" ? provider['user_name'] : widget.userName;
    return Scaffold(
      appBar: AppBar(
        title: Text(user, style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder(
      future: post.getUserProfileInfo(user),
      builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot){
          if(snapshot.hasData){
            var info = snapshot.data;
            return Column(
                children: <Widget> [
                 Padding(padding:const EdgeInsets.only(left: 10,right: 10),
                 child:  Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: <Widget> [
                        CircleAvatar(
                          radius: 50.0,
                          backgroundImage:
                          NetworkImage("${info['photoUrl']}"),
                          backgroundColor: Colors.transparent,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                               Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget> [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget> [
                                  Text('${info['no_of_posts']}',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold)),
                                  Text('Posts',style: TextStyle(color: Colors.white,fontSize: 12))        
                                ],
                              )
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget> [
                                  Text('${info['followers']}',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold)),
                                  Text('Followers',style: TextStyle(color: Colors.white,fontSize: 12))        
                                ],
                              )
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget> [
                                  Text('${info['following']}',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold)),
                                  Text('Following',style: TextStyle(color: Colors.white,fontSize: 12))        
                                ],
                              )
                            )
                          ],
                        )
                            ],
                          )
                        )
                     ],
                  )
                 ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget> [
                              Padding(padding: const EdgeInsets.only(top:5)),
                              Text('${info['email']}',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold)),
                              Padding(padding: const EdgeInsets.only(top:5)),
                              Text('${info['bio']}',style: TextStyle(color: Colors.white,fontSize: 15))
                            ]
                          )
                        )
                      ]
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0,bottom: 20.0),
                            child: OutlinedButton(
                              onPressed: null,
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(width: 1.0, color: Colors.grey)
                              ),
                              child: const Text("Edit Profile",style: TextStyle(color: Colors.white,fontSize: 15)),
                            )
                          ),
                        )
                      ],
                    ),
                  ),
                   Expanded(
                      child: SizedBox(
                        height: 200,
                        child:GridView.count(
                          crossAxisCount: 3,
                          children: List.generate(info['posts'].length, (index) {
                            String file = info['posts'][index]['images'][0];
                            return Padding(
                              padding: EdgeInsets.all(5.0),
                                child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: Image.memory(base64Decode(file)).image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: null
                              )
                            );
                          }),
                        )
                      )
                   )
                ]
              );
          }
          return Container();
        }
      ),
    );
  } 
}