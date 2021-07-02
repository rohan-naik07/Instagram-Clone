import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_flutter_project/futils/instance.dart';

class Post{

  Future<DocumentReference<Map<String, dynamic>>>? addPost(
      String userName,
      String url,
      List<File> images,
      String description,
      DateTime date,
      String userId,
      ) async {
    List<String> imageUrls = await uploadImages(images, userName, date);
    return Firestore.getInstance()!.collection("posts").add({
      'user_name': userName,
      'user_id' : userId,
      'images': imageUrls,
      'description': description,
      'likes': [],
      'comments': [],
      'date' : '${date.day}/${date.month}/${date.year}',
      'photoUrl': url,
      'saved' : false
    });
  }

  Future<dynamic>? getPosts() async {
    var posts = await Firestore.getInstance()!.collection("posts").get();
    return posts.docs;
  }

  Future<DocumentSnapshot<Map<String,dynamic>>> getPostById(String id)=> Firestore.getInstance()!.collection("posts").doc(id).get();

  Future<List<String>> uploadImages(
      List<File> images,
      String userName,
      var date
      ) async {
    List<String> uploadUrls = [];

    await Future.wait(
        images.map((File file) async {
          List<String> names = file.path.split('/');
          String name = names[names.length-1];
          try {
            TaskSnapshot snapshot =  await Firestore.getStorageInstance()!.ref(
                'uploads/posts/$userName/${date.toString()}/image_$name.jpg'
            ).putFile(file);

            final String downloadUrl = await snapshot.ref.getDownloadURL();
            uploadUrls.add(downloadUrl);

            print('Upload success');
          }  on FirebaseException catch(error) {
            print('Error from image repo ${error.toString()}');
            throw ('This file is not an image');
          }
        }), eagerError: true, cleanUp: (_) {
        print('eager cleaned up');
      }
    );

    return uploadUrls;
  }

  Future<dynamic> getUserProfileInfo (name) async {
    var user = await Firestore.getInstance()!.collection("users").where('user_name',isEqualTo:name).get();
    var posts = await Firestore.getInstance()!.collection("posts").where('user_name',isEqualTo:name).get();
    return {
      "fullName" : user.docs[0]['fullName'],
      "user_name" : user.docs[0]['user_name'],
      "user_id" : user.docs[0].id,
      "photoUrl" : user.docs[0]['photoUrl'],
      "bio" : user.docs[0]['bio'],
      "no_of_posts" : posts.docs.length,
      "followers" :  user.docs[0]['followers'],
      "following" :  user.docs[0]['following'],
      "posts" : posts.docs,
    };
  }

  Future<dynamic> updatePost (var id,var update) async {
    var posts = await Firestore.getInstance()!.collection("posts").doc(id).update(update);
    return posts;
  }

  Future<String> postComments(var comment) =>
    Firestore.getInstance()!.collection('comments').add(comment).then((value) {
      return value.id;
    });
  
  Future<QuerySnapshot<Map<String,dynamic>>> getComments(var postId) =>
    	Firestore.getInstance()!
      .collection('comments')
      .where('post_id',isEqualTo:postId)
      .get();

}