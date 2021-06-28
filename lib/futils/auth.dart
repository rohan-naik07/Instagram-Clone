import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:first_flutter_project/futils/instance.dart';

class Auth {

  Future<void> addUser(userName,fullName,email,bio,url) {
    // Call the user's CollectionReference to add a new user
    return Firestore.getInstance()!.collection("users").add({
      'user_name': userName,
      'email': email,
      'fullName' : fullName,
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
      "_id" : user.docs[0].id,
      "email" : user.docs[0]['email'],
      "user_name" : user.docs[0]['user_name'],
      "photoUrl" : user.docs[0]['photoUrl']
    };
  }

  Future<void> updateUser(id,update)=>Firestore.getInstance()!.collection("users").doc(id).update(update);

  Future<dynamic> getUserbyId (id) async {
    var user = await Firestore.getInstance()!.collection("users").doc(id).get();
    return {
      "_id" : user.id,
      "email" : user['email'],
      "user_name" : user['user_name'],
      "photoUrl" : user['photoUrl']
    };
  }

  Future<List<DocumentSnapshot>> getSuggestion(String searchkey) =>
  Firestore.getInstance()!
      .collection('users')
      .orderBy('user_name')
      .startAt([searchkey])
      .endAt([searchkey + '\uf8ff'])
      .get()
      .then((snapshot) {
        return snapshot.docs;
      });

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

