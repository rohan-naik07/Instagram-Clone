import 'package:cached_network_image/cached_network_image.dart';
import 'package:first_flutter_project/futils/auth.dart';
import 'package:first_flutter_project/profile/profile.dart';
import'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_flutter_project/futils/posts.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> removeCredentials () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('user-email');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[800]
          ),
          child: GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute( builder: (context)=>SearchList() ));
            },
            child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        size: 20,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5), 
                        child : Text('Search', style: TextStyle(color: Colors.grey, fontSize: 15)),
                      )
                    ],
                  )
              )
            ],
          ),
          )
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body:FutureBuilder(
        future: Post().getPosts(),
        builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot){
          if(snapshot.hasData){
            var posts = snapshot.data;
            return new StaggeredGridView.countBuilder(
              crossAxisCount: 4,
              itemCount: posts.length,
              itemBuilder: (BuildContext context, int index) => new Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(posts[index]['images'][0]),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: null
                  ),
              staggeredTileBuilder: (int index) => new StaggeredTile.count(2, index.isEven ? 2 : 1),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            );
          }
          return Container();        
        },
      )
    );
  }
}

 
class SearchList extends StatefulWidget {
  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  final _searchQueryController = TextEditingController(text: '');
  List<dynamic>  users = [];

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[800]
            ),
          child:
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.white,
                    ),
            Padding(
              padding: const EdgeInsets.only(left: 5), 
              child : SizedBox(
                height: 20,
                width: 200,
                child: TextField(
                      controller: _searchQueryController,
                      onChanged: (value) async {
                        var snapshot = await Auth().getSuggestion(value.toLowerCase());
                        setState(() {
                          users = snapshot;
                        });
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ),
                  )
                )
              ],
            )
          )
        ),
      ),
      body:SizedBox(
           height: 400,
           child:  ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute( builder: (context)=>ProfilePage(userName: users[index]['user_name'])));
                },
                child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 30.0,
                    backgroundImage:NetworkImage("${users[index]['photoUrl']}"),
                    backgroundColor: Colors.transparent,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                '${users[index]['user_name']}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20
                                ),
                              ),
                            )
                        ),
                        Container(
                            padding: const EdgeInsets.only(left: 10),
                            child:Material(
                              type: MaterialType.transparency,
                              child: Text(
                                '${users[index]['fullName']}',
                                style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 15
                                ),
                              ),
                            )
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      )
    );
  }
}