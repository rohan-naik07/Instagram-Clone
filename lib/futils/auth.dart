import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class Firestore {
  static FirebaseFirestore? firestore;
  static CollectionReference? users;
  static FirebaseStorage? storage;

  static FirebaseFirestore? getInstance(){
    if(firestore==null){
      firestore = FirebaseFirestore.instance;
    }
    return firestore;
  }

  static CollectionReference? getRef(){
    if(users==null){
      users = getInstance()!.collection('users');
    }
    return users;
  }

  static FirebaseStorage? getStorageInstance(){
    if(storage==null){
      return FirebaseStorage.instance;
    }
    return storage;
  }

  Future<void> addUser(user_name,email,bio,url) {
    // Call the user's CollectionReference to add a new user
    return getRef()!.add({
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
    var user = await getRef()!.where('email',isEqualTo: email).get();
    print(user.docs);
    return user.docs[0].data;
  }

  Future<String> uploadPhoto(File file,String user_name) async {
    try {
      await getStorageInstance()!.ref('uploads/profile_images/${user_name}.jpg').putFile(file);
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
    String downloadURL = await getStorageInstance()!.ref('uploads/profile_images/${user_name}.jpg').getDownloadURL();
    return downloadURL;
  }

}

