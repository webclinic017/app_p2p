
import 'package:app_p2p/database/appDatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageData {

  String? id;
  String? chatID;
  String? message;
  String? senderID;
  bool? seen;
  String? fileUrl;
  String? filePath;
  String? fileExtension;
  String? fileName;
  DateTime? created;



  MessageData({this.id, this.chatID, this.message, this.senderID, this.seen,
    this.fileUrl, this.filePath, this.fileExtension, this.fileName, this.created});



  MessageData.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {

    id = doc.id;
    chatID = doc.data()?[AppDatabase.chatID];
    message = doc.data()?[AppDatabase.message];
    senderID = doc.data()?[AppDatabase.senderID];
    seen = doc.data()?[AppDatabase.seen];
    fileUrl = doc.data()?[AppDatabase.fileUrl];
    filePath = doc.data()?[AppDatabase.filePath];
    fileExtension = doc.data()?[AppDatabase.fileExtension];
    fileName = doc.data()?[AppDatabase.fileName];
    created = (doc.data()?[AppDatabase.created] as Timestamp).toDate();



  }

  MessageData.fromMap(Map<String, dynamic> map) {
    id = map[AppDatabase.id];
    chatID = map[AppDatabase.chatID];
    message = map[AppDatabase.message];
    senderID = map[AppDatabase.senderID];
    seen = map[AppDatabase.seen];
    try {
      fileUrl = map[AppDatabase.fileUrl];
    }catch(e) {
      fileUrl = null;
    }

    try {
      filePath = map[AppDatabase.filePath];
    }catch(e) {
      filePath = null;
    }

    try {
      fileExtension = map[AppDatabase.fileExtension];
    }catch(e) {
      fileExtension = null;
    }

    try {
      fileName = map[AppDatabase.fileName];
    }catch(e) {
      fileName = null;
    }

    created = (map[AppDatabase.created] as Timestamp).toDate();
  }

  Map<String, dynamic> toMap() => {
    AppDatabase.chatID: chatID,
    AppDatabase.message: message,
    AppDatabase.senderID: senderID,
    AppDatabase.seen: seen,
    AppDatabase.fileUrl: fileUrl,
    AppDatabase.filePath: filePath,
    AppDatabase.fileExtension: fileExtension,
    AppDatabase.fileName: fileName,
    AppDatabase.created: created
  };

}