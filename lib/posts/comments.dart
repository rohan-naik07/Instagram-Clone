import 'package:first_flutter_project/futils/posts.dart';
import 'package:first_flutter_project/home/userInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentsPage extends StatefulWidget {
  final post;

  const CommentsPage({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  var comments;
  
  Widget renderComment(var comment){
    var date = DateTime.parse(comment['timestamp']);
    return Padding(
      padding: const EdgeInsets.all(5),
      child:Row(
        children: [
          CircleAvatar(
            radius: 20.0,
            backgroundImage:
            NetworkImage("${comment['user-photo']}"),
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
                      child: RichText(
                        text: TextSpan(
                          text: '${comment['user_name']} ',
                          style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                            TextSpan(text: '${comment['comment']}', style:TextStyle(fontSize: 15,fontWeight: FontWeight.normal)),
                          ],
                        ),
                      )
                    )
                ),
                Container(
                    padding: const EdgeInsets.only(left: 8),
                    child:Material(
                      type: MaterialType.transparency,
                      child: Text(
                        '${date.day}/${date.month}/${date.year}',
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 10
                        ),
                      ),
                    )
                )
              ],
            ),
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    var post = widget.post;
    var user = context.read<UserModel>().info;
    List<dynamic> comments;
    final _commentController = TextEditingController(text: '');

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Comments', style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<dynamic>(
        future: Post().getComments(post.id),
        builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot){
          if(snapshot.hasData){
            comments = [];
            var commentDocs = snapshot.data.docs;
            commentDocs.forEach((comment){
              comments.add({
                'comment' : comment['comment'],
                'post_id' : comment['post_id'],
                'user_name' : comment['user_name'],
                'user-photo' : comment['user-photo'],
                'timestamp' : comment['timestamp']
              });
            });

            return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20.0,
                          backgroundImage:
                          NetworkImage("${post['photoUrl']}"),
                          backgroundColor: Colors.transparent,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: RichText(
                                      text: TextSpan(
                                        text: '${post['user_name']} ',
                                        style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                                        children: <TextSpan>[
                                          TextSpan(text: '${post['description']}', style:TextStyle(fontSize: 15,fontWeight: FontWeight.normal)),
                                        ],
                                      ),
                                    )
                                  )
                              ),
                              Container(
                                  padding: const EdgeInsets.only(left: 8),
                                  child:Material(
                                    type: MaterialType.transparency,
                                    child: Text(
                                      '${post['date']}',
                                      style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 10
                                      ),
                                    ),
                                  )
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5,right: 5),
                    child: Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: comments.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return renderComment(comments[index]);
                        }
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                        CircleAvatar(
                        radius: 15.0,
                        backgroundImage:
                        NetworkImage("${user['photoUrl']}"),
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
                          var updatedComments = comments;
                          updatedComments.add(comment);
                          setState(() {
                            comments = updatedComments;
                          });
                         var postService = new Post();
                          postService.postComments(comment).then(
                            (value) {
                              var commentIds = [];
                              post['comments'].forEach((commentId){
                                commentIds.add(commentId.toString());
                              });
                              commentIds.add(value);
                              postService.updatePost(post.id, {'comments' : commentIds});
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
                ],
            );
          }
          return Center(child: CircularProgressIndicator());
        }
      )
    );   
  }
}
