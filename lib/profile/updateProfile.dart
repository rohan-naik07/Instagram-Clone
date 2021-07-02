import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_flutter_project/home/userInfo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  var user;
  var _messageController = new TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var infoProvider = context.read<UserModel>();
    user = infoProvider.info;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Edit Profile'),
        leading: IconButton(
          onPressed: ()=>Navigator.pop(context),
          icon: Icon(
            Icons.cancel,
            size: 30,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: null,
            icon: Icon(
              Icons.check,
              size: 30,
              color: Colors.blue,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20,left: 5,right: 5),
        child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 55.0,
            backgroundImage: CachedNetworkImageProvider("${user['photoUrl']}"),
            backgroundColor: Colors.transparent,
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              'Change profile photo',
              style: TextStyle(color: Colors.blue,fontSize: 20)
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              controller: _messageController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.grey,fontSize: 15)
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              controller: _messageController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'User Name',
                labelStyle: TextStyle(color: Colors.grey,fontSize: 15)
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              controller: _messageController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Bio',
                labelStyle: TextStyle(color: Colors.grey,fontSize: 15)
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Divider(color: Colors.grey[800],thickness: 0.4)
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'Personal Information Settings',
                  style: TextStyle(color: Colors.blue,fontSize: 20)
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                  controller: _messageController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.grey,fontSize: 15)
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      )
    ); 
  }

}