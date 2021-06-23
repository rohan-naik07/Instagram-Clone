import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:first_flutter_project/futils/instance.dart';

class Auth {

  Future<void> addUser(userName,email,bio,url) {
    // Call the user's CollectionReference to add a new user
    return Firestore.getInstance()!.collection("users").add({
      'user_name': userName,
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

  Future<String> uploadPhoto(File file,String userName) async {
    try {
      await Firestore.getStorageInstance()!
      .ref('uploads/profile_images/$userName.jpg').putFile(file);
    } on FirebaseException catch (e) {
      throw e;
    }
    try {
      String url = await downloadURL(userName);
      return url;
    } on FirebaseException catch (e) {
      throw e;
    }
  }

  Future<String> downloadURL(String userName) async {
    String downloadURL = await Firestore.getStorageInstance()!
    .ref('uploads/profile_images/$userName.jpg').getDownloadURL();
    return downloadURL;
  }

}

