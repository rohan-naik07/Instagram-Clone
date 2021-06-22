import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:first_flutter_project/futils/instance.dart';

class Auth {

  Future<void> addUser(user_name,email,bio,url) {
    // Call the user's CollectionReference to add a new user
    return Firestore.getInstance()!.collection("users").add({
      'user_name': user_name,
      'email': email,
      'bio': bio,
      'photoUrl': url,
      'connections':[],
      'stories':[],
      'posts': []
    });
  }

  Future<dynamic> getUser (email) async {
    var user = await Firestore.getInstance()!.collection("users").where('email',isEqualTo: email).get();
    return {
      "email" : user.docs[0]['email'],
      "user_name" : user.docs[0]['user_name'],
      "photoUrl" : user.docs[0]['photoUrl']
    };
  }

  Future<String> uploadPhoto(File file,String user_name) async {
    try {
      await Firestore.getStorageInstance()!
      .ref('uploads/profile_images/${user_name}.jpg').putFile(file);
    } on FirebaseException catch (e) {
      throw e;
    }
    try {
      String url = await downloadURL(user_name);
      return url;
    } on FirebaseException catch (e) {
      throw e;
    }
  }

  Future<String> downloadURL(String user_name) async {
    String downloadURL = await Firestore.getStorageInstance()!
    .ref('uploads/profile_images/${user_name}.jpg').getDownloadURL();
    return downloadURL;
  }

}

