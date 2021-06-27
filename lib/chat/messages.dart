import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:first_flutter_project/futils/auth.dart';
import 'package:first_flutter_project/futils/chat.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class MessagesPage extends StatefulWidget {
  final userId1;
  final userId2;
  final currentUserId;
  final chatId;

  const MessagesPage({
    Key? key,
    required this.userId1,
    required this.userId2,
    required this.currentUserId,
    this.chatId
  }) : super(key: key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {

  String? chatId;
  List<dynamic>? messages;
  Paint paint = Paint();
  var _messageController = new TextEditingController(text: '');
   

  @override
  initState(){
    super.initState();
    paint.shader = ui.Gradient.linear(
        const Offset(0, 60),
        const Offset(60, 30),
        <Color>[
          Colors.pinkAccent,
          Colors.amber
        ],
      );
  }

  Future<String> getChatId() async {
    var chat = {
      'participants' : [widget.userId1,widget.userId2],
      'messages' : []
    };
    chatId = await Chat().createChat(chat);
    return chatId!;
  }

  Future<void> sendMessage() async {
    var message = {
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

  Widget renderMessage(message){
    return Padding(
      padding : const EdgeInsets.all(5.0),
      child : Row(
        mainAxisAlignment: message['author'] == widget.currentUserId ? 
        MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: message['author'] == widget.currentUserId ? Colors.blue : Colors.grey
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(message['text'],style: TextStyle(color: Colors.white,fontSize: 18)),
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
        title: Row(
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
          ],
        ),
      ),
      body: Column(
        children: [
          Divider(
            thickness: 0.5,
            color: Colors.grey,
          ),
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color:Colors.grey[800]
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
                          await sendMessage();
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Auth().getUserbyId(widget.currentUserId==widget.userId1 ? widget.userId2 : widget.userId1),
      builder:(BuildContext context,AsyncSnapshot<dynamic> snapshot){
        if(snapshot.hasData){
          var recepient = snapshot.data;
          if(widget.chatId==null){
            return FutureBuilder(
              future: getChatId(),
              builder:(BuildContext context,AsyncSnapshot<dynamic> snapshot){
                if(snapshot.hasData){
                  chatId = snapshot.data;
                  return StreamBuilder<dynamic>(
                      stream: Chat().getChat(chatId!),
                      builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot){
                        messages = [];
                        if(snapshot.hasData){
                          if(snapshot.data.docs.length!=0){
                            chatId = snapshot.data.id;
                            snapshot.data['messages'].forEach((message)=>messages!.add(message));
                          } 
                          return displayUI(recepient);
                        }
                        return Center(child: CircularProgressIndicator());
                      }
                  );
                }
                return Center(child: CircularProgressIndicator());
              }
            );
          }
          return StreamBuilder<dynamic>(
              stream: Chat().getChat(widget.chatId),
              builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot){
                messages = [];
                if(snapshot.hasData){
                  snapshot.data['messages'].forEach((message)=>messages!.add(message)); 
                  return displayUI(recepient);
                }
                return Center(child: CircularProgressIndicator());
              }
          );
        }
         return Center(child: CircularProgressIndicator());
      }
    );
  }

}