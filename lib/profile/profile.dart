import 'dart:convert';
import 'package:first_flutter_project/futils/posts.dart';
import 'package:flutter/material.dart';


class ProfilePage extends StatefulWidget {
  final String user_name;

  const ProfilePage({
    Key? key,
    required this.user_name,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Post post = new Post();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
      future: post.getUserProfileInfo(widget.user_name),
      builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot){
          if(snapshot.hasData){
            var info = snapshot.data;
            return Scaffold(
              backgroundColor: Colors.black, 
              body : Column(
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
                              padding: const EdgeInsets.all(10.0),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget> [
                      Text('${info['email']}',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold)),
                      Text('${info['bio']}',style: TextStyle(color: Colors.white,fontSize: 15))
                    ],
                  ),
                  Row(
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
                   Expanded(
                      child: SizedBox(
                        height: 200,
                        child:GridView.count(
                          crossAxisCount: 3,
                          children: List.generate(info['posts'].length, (index) {
                            var post = info['posts'][index];
                            return Padding(
                              padding: EdgeInsets.all(5.0),
                                child: FittedBox(
                                  child: Image.memory(base64Decode(post['images'][0]),width: 100,height: 100,),
                                  fit: BoxFit.fill,
                              ),
                            );
                          }),
                        )
                      )
                   )
                ]
              )
            );
          }
          return Container();
        }
    );
  } 
}