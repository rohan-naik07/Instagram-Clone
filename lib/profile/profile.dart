import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_flutter_project/auth/login.dart';
import 'package:first_flutter_project/chat/messages.dart';
import 'package:first_flutter_project/futils/auth.dart';
import 'package:first_flutter_project/futils/chat.dart';
import 'package:first_flutter_project/futils/posts.dart';
import 'package:first_flutter_project/home/userInfo.dart';
import 'package:first_flutter_project/posts/posts.dart';
import 'package:first_flutter_project/profile/updateProfile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  var info;
  int followersCount=0;
  int followingCount=0;

  Future<void> removeCredentials () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('user-email');
  }
  
  List<Widget> getRowChildren(info,user){
    return user["_id"]==info['user_id'] ? [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0,bottom: 20.0),
          child: OutlinedButton(
            onPressed: ()=>Navigator.push(context, 
              MaterialPageRoute( 
                builder: (context)=>UpdateProfilePage()
              )
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(width: 1.0, color: Colors.grey)
            ),
            child: const Text("Edit Profile",style: TextStyle(color: Colors.white,fontSize: 15)),
          )
        ),
      )
    ] : [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0,bottom: 20.0,left: 10,right: 10),
          child: user['following'].contains(info['user-name']) ? 
          OutlinedButton(
            onPressed: () async {
              List<dynamic> followers = info['followers'];
              List<dynamic> following = user['following'];
              followers.add(user['user_name']);
              following.add(info['user_name']);
              setState(() {
                followersCount = followersCount + 1;
              });
              await Auth().updateUser(info['user_id'], {'followers' : followers});
              await Auth().updateUser(user['_id'], {'following' : following});
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(width: 1.0, color: Colors.grey)
            ),
            child: const Text("Follow",style: TextStyle(color: Colors.white,fontSize: 15)),
          ) : OutlinedButton(
            onPressed: null,
            child: const Text("Following",style: TextStyle(color: Colors.grey,fontSize: 15)),
          )
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0,bottom: 20.0,left: 10,right: 10),
          child: OutlinedButton(
            onPressed: ()async{
              var chatId = await Chat().getChatId(user['_id'], info['user_id']);
              Navigator.push(context, 
                MaterialPageRoute( 
                  builder: (context)=>MessagesPage(
                    userId1: user['_id'], 
                    userId2: info['user_id'] , 
                    currentUserId:  user['_id'],
                    chatId: chatId
                  )
                )
              );
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(width: 1.0, color: Colors.grey)
            ),
            child: const Text("Message",style: TextStyle(color: Colors.white,fontSize: 15)),
          )
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.read<UserModel>().info!;
    var user = widget.userName == "" ? provider['user_name'] : widget.userName;
    return FutureBuilder(
      future: post.getUserProfileInfo(user),
      builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot){
          if(snapshot.hasData){
            info = snapshot.data;
            followersCount = snapshot.data['followers'].length;
            followingCount = snapshot.data['following'].length;

            return Scaffold(
              appBar: AppBar(
                title: Text(user, style: TextStyle(color: Colors.white, fontSize: 20)),
                backgroundColor: Colors.black,
              ),
              backgroundColor: Colors.black,
              endDrawer: provider["_id"]==info['user_id'] ? Drawer(
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        await removeCredentials();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context)=>LoginPage()), 
                          (Route<dynamic> route) => false);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.save_alt),
                      title: Text('Saved Posts'),
                      onTap: (){
                        //Navigator.pushNamed(context, '/transactionsList');
                      },
                    ),
                  ]
                )
              ) : null,
              body: Column(
                children: <Widget> [
                 Padding(padding:const EdgeInsets.only(left: 10,right: 10),
                 child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: <Widget> [
                        CircleAvatar(
                          radius: 50.0,
                          backgroundImage: CachedNetworkImageProvider("${info['photoUrl']}"),
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
                                        Text('$followersCount',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold)),
                                        Text('Followers',style: TextStyle(color: Colors.white,fontSize: 12))        
                                      ],
                                    )
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget> [
                                        Text('$followingCount',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold)),
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
                              Padding(padding: const EdgeInsets.only(top:15)),
                              Text('${info['fullName']}',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold)),
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: getRowChildren(info, provider)
                    ),
                  ),
                   Expanded(
                      child: SizedBox(
                        height: 200,
                        child:GridView.count(
                          crossAxisCount: 3,
                          children: List.generate(info['posts'].length, (index) {
                            String url = info['posts'][index]['images'][0];
                            return GestureDetector(
                              onTap: ()=>Navigator.push(context, 
                                MaterialPageRoute( 
                                  builder: (context)=>PostsPage(posts: info['posts'])
                                )
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(5.0),
                                  child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(url),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: null
                                )
                              ),
                            );
                          }
                        ),
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