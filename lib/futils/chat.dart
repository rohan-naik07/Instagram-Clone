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

  Future<dynamic> getChatId(String userId,String recepientId) =>
   Firestore.getInstance()!
      .collection('chats')
      .where('participants', arrayContains: userId)
      .get()
      .then((snapshot) {
        var chatId;
        snapshot.docs.forEach((element) {
          if(element['participants'].length==2 && element['participants'].contains(recepientId)){
            chatId=element.id;
          }
          return chatId;
        });
        return chatId;
    });

  Future<void> createMessage(String chatId, var messages) =>
   Firestore.getInstance()!
      .collection('chats')
      .doc(chatId)
      .update({'messages' : messages});
  
  Future<void> createPostMessage(String chatId, var message) async {
    var chat = await Firestore.getInstance()!
      .collection('chats')
      .doc(chatId).get();
    List<dynamic> messages = chat['messages'];
    messages.add(message);
    await createMessage(chatId, messages);
  }
     

  Future<String> createChat(chat) =>
   Firestore.getInstance()!
      .collection('chats')
      .add(chat)
      .then((snapshot) {
        return snapshot.id;
    });
  
}