import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class Firestore {
  static FirebaseFirestore? firestore;
  static FirebaseStorage? storage;

  static FirebaseFirestore? getInstance(){
    if(firestore==null){
      firestore = FirebaseFirestore.instance;
    }
    return firestore;
  }

  static FirebaseStorage? getStorageInstance(){
    if(storage==null){
      return FirebaseStorage.instance;
    }
    return storage;
  }
}

