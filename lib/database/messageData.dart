
import 'package:app_p2p/database/appDatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageData {

  String? id;
  String? chatID;
  String? message;
  String? senderID;
  bool? seen;
  DateTime? created;


  MessageData({this.id, this.chatID, this.message, this.senderID, this.seen, this.created});



  MessageData.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {

    id = doc.id;
    chatID = doc.data()?[AppDatabase.chatID];
    message = doc.data()?[AppDatabase.message];
    senderID = doc.data()?[AppDatabase.senderID];
    seen = doc.data()?[AppDatabase.seen];
    created = (doc.data()?[AppDatabase.created] as Timestamp).toDate();



  }

  MessageData.fromMap(Map<String, dynamic> map) {
    id = map[AppDatabase.id];
    chatID = map[AppDatabase.chatID];
    message = map[AppDatabase.message];
    senderID = map[AppDatabase.senderID];
    seen = map[AppDatabase.seen];
    created = (map[AppDatabase.created] as Timestamp).toDate();
  }

  Map<String, dynamic> toMap() => {
    AppDatabase.chatID: chatID,
    AppDatabase.message: message,
    AppDatabase.senderID: senderID,
    AppDatabase.seen: seen,
    AppDatabase.created: created
  };

}