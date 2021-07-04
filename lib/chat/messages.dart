import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:first_flutter_project/futils/auth.dart';
import 'package:first_flutter_project/futils/chat.dart';
import 'package:first_flutter_project/futils/posts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'package:first_flutter_project/error/error.dart';

class MessagesPage extends StatefulWidget {
  final userId1;
  final userId2;
  final currentUserId;
  final chatId;
  final postId;

  const MessagesPage({
    Key? key,
    required this.userId1,
    required this.userId2,
    required this.currentUserId,
    this.chatId,
    this.postId
  }) : super(key: key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {

  String? chatId;
  List<dynamic>? messages;
  var _messageController = new TextEditingController(text: '');
   
  @override
  initState(){
    super.initState();
  }

  Future<String> getChatId() async {
    var chat = {
      'participants' : [widget.userId1,widget.userId2],
      'messages' : []
    };
    chatId = await Chat().createChat(chat);
    return chatId!;
  }

  Future<void> sendMessage(postId) async {
    var message;
    if(postId!=null){
      message = {
        'author' : widget.currentUserId,
        'type' : 'post',
        'text' : null,
        'post_id' : postId,
        'image_Url' : null,
        'timestamp' : DateTime.now().toString(),
        'status' : 0
      };
      await Chat().createPostMessage(chatId!,message);
    } else {
      message = {
        'author' : widget.currentUserId,
        'type' : 'text',
        'text' : _messageController.text,
        'post_id' : null,
        'image_Url' : null,
        'timestamp' : DateTime.now().toString(),
        'status' : 0
      };
      var updatedMessages = messages;
      updatedMessages!.add(message);
      await Chat().createMessage(chatId!, updatedMessages);
    }
    _messageController.clear();
  }

  Widget renderMessage(message) {
  if(message['type']=='post'){
    return Row(
      mainAxisAlignment: message['author'] == widget.currentUserId ? 
      MainAxisAlignment.end : MainAxisAlignment.start,
        children: [ 
        Container(
          margin: EdgeInsets.all(5),
          width: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color:Colors.grey[850]
          ),
        child: FutureBuilder(
          future: Post().getPostById(message['post_id']),
          builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot){
            if(snapshot.hasData){
              var post = snapshot.data;
                  return Column(
                    children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Row(
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
                                      onPressed: null,
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
                      ),
                      CachedNetworkImage(
                          imageUrl: post['images'][0],
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(15),
                        child:  RichText(
                          text: TextSpan(
                            text: '${post['user_name']} ',
                            style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(text: '${post['description']}', style:TextStyle(fontSize: 15,fontWeight: FontWeight.normal)),
                            ],
                          ),
                        )
                      )
                    ],
                  );
            }
            if(snapshot.hasError){
              Error.showError(context,snapshot.error.toString());
              return Center(child: Error.errorContainer(snapshot.error.toString()));
            }
            return Center(child: CircularProgressIndicator());
          }
        )
      ) 
    ]    
  );
    }

    return Padding(
      padding : const EdgeInsets.all(5.0),
      child : Row(
        mainAxisAlignment: message['author'] == widget.currentUserId ? 
        MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: message['author'] == widget.currentUserId ? Colors.blue : Colors.grey[800]
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(message['text'],style: TextStyle(color: Colors.white,fontSize: 15)),
            )
          )
        ],
      )
    );
  }

  Widget displayUI(recepient) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: <Widget> [
            CircleAvatar(
                radius: 20.0,
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
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: messages!.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return renderMessage(messages![index]);
                }
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color:Colors.grey[850]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget> [
                RawMaterialButton(
                  onPressed: () {},
                  elevation: 2.0,
                  fillColor: Colors.blue,
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 25.0,
                  ),
                  padding: EdgeInsets.all(10.0),
                  shape: CircleBorder(),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: TextField(
                      controller: _messageController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Message...',
                        hintStyle: TextStyle(fontSize: 15, color: Colors.white),
                        isDense: true,
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
                Transform.rotate(
                  angle: 60 * math.pi / 180,
                  child: IconButton(
                    icon: Icon(
                      Icons.details_sharp,
                      size: 25,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      await sendMessage(null);
                    },
                  )
                )
              ],
            )
          )
        ],
      ),
    );
  }

  Future<Uint8List> compressImage(imageUrl) async {
    var rng = new math.Random();
    // get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
    // get temporary path from temporary directory.
    String tempPath = tempDir.path;
    // create a new file in temporary path with random file name.
    File file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
    http.Response response = await http.get(Uri.parse(imageUrl));
    file = await file.writeAsBytes(response.bodyBytes);
    Im.Image? image = Im.decodeImage(file.readAsBytesSync());
    Im.copyResize(image!, width : 500);
    return image.getBytes();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Auth().getUserbyId(widget.userId2),
      builder:(BuildContext context,AsyncSnapshot<dynamic> snapshot){
        if(snapshot.hasData){
          var recepient = snapshot.data;
          if(widget.chatId==null){
            return FutureBuilder(
              future: getChatId(),
              builder:(BuildContext context,AsyncSnapshot<dynamic> snapshot){
                if(snapshot.hasData){
                  chatId = snapshot.data;
                  if(widget.postId!=null){
                    sendMessage(widget.postId);
                  } 
                  return StreamBuilder<dynamic>(
                      stream: Chat().getChat(chatId!),
                      builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot){
                        messages = [];
                        if(snapshot.hasData){
                          chatId = snapshot.data.id;
                          snapshot.data['messages'].forEach((message)=>messages!.add(message));
                          return displayUI(recepient);
                        }
                        if(snapshot.hasError){
                          Error.showError(context,snapshot.error.toString());
                          return Center(child: Error.errorContainer(snapshot.error.toString()));
                        }
                        return Center(child: CircularProgressIndicator());
                      }
                  );
                }
                if(snapshot.hasError){
                  Error.showError(context,snapshot.error.toString());
                  return Center(child: Error.errorContainer(snapshot.error.toString()));
                }
                return Center(child: CircularProgressIndicator());
              }
            );
          }
          chatId = widget.chatId;
          if(widget.postId!=null){
            sendMessage(widget.postId);
          } 
          return StreamBuilder<dynamic>(
              stream: Chat().getChat(widget.chatId),
              builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot){
                messages = [];
                if(snapshot.hasData){
                  snapshot.data['messages'].forEach((message)=>messages!.add(message));
                  return displayUI(recepient);
                }
                if(snapshot.hasError){
                  Error.showError(context,snapshot.error.toString());
                  return Center(child: Error.errorContainer(snapshot.error.toString()));
                }
                return Center(child: CircularProgressIndicator());
              }
          );
        }
        if(snapshot.hasError){
          Error.showError(context,snapshot.error.toString());
          return Center(child: Error.errorContainer(snapshot.error.toString()));
        }
         return Center(child: CircularProgressIndicator());
      }
    );
  }

}