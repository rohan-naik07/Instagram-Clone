import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_flutter_project/futils/instance.dart';

class Post{
  Future<void>? addPost(
      String userName,
      String url,
      List<String> images,
      String description,
      DateTime date
      ) {
    return Firestore.getInstance()!.collection("posts")!.add({
      'user_name': userName,
      'images': images,
      'description': description,
      'likes': [],
      'comments': [],
      'date' : '${date.day}/${date.month}/${date.year}',
      'photoUrl': url,
      'saved' : false
    });
  }

  Future<Object>? getPosts() async {
    var posts = await Firestore.getInstance()!.collection("posts")!.get();
    return posts.docs;
  }

  Future<List<String>> uploadImages(
      List<File> images,
      String user_name,
      var date
      ) async {
    List<String> uploadUrls = [];

    await Future.wait(
        images.map((File file) async {
          List<String> names = file.path.split('/');
          String name = names[names.length-1];
          try {
            TaskSnapshot snapshot =  await Firestore.getStorageInstance()!.ref(
                'uploads/posts/${user_name}/${date.toString()}/image_${name}.jpg'
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
}