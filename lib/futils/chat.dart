import 'package:cloud_firestore/cloud_firestore.dart';
import 'instance.dart';

class Chat{

  Stream<DocumentSnapshot<Map<String, dynamic>>> getChat(String chatId) =>
   Firestore.getInstance()!
      .collection('chats')
      .doc(chatId)
      .snapshots();

  Future<List<DocumentSnapshot>> getYourChats(String userId) =>
   Firestore.getInstance()!
      .collection('chats')
      .where('participants', arrayContains: userId)
      .get()
      .then((snapshot) {
        return snapshot.docs;
    });

  Future<void> createMessage(String chatId, var messages) =>
   Firestore.getInstance()!
      .collection('chats')
      .doc(chatId)
      .update({'messages' : messages});
     

  Future<String> createChat(chat) =>
   Firestore.getInstance()!
      .collection('chats')
      .add(chat)
      .then((snapshot) {
        return snapshot.id;
    });
  
}