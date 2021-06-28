import 'package:cached_network_image/cached_network_image.dart';
import 'package:first_flutter_project/chat/messages.dart';
import 'package:first_flutter_project/futils/auth.dart';
import 'package:first_flutter_project/futils/chat.dart';
import 'package:first_flutter_project/home/userInfo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatsPage extends StatefulWidget {
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  var user;
  var chats;

  @override
  Widget build(BuildContext context) {
    var infoProvider = context.read<UserModel>();
    user = infoProvider.info;
    return Scaffold(
      appBar: AppBar(
        title: Text(user['user_name'], style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: Chat().getYourChats(user['_id']),
        builder:(BuildContext context,AsyncSnapshot<dynamic> snapshot){
          if(snapshot.hasData){
            chats = snapshot.data;
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
      )
    );
  }
}
      
