

import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/database/messageData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatData {

  String? id;
  String? involvedCode;
  List<String>? involved;
  List<Map<String, dynamic>>? involvedInfo;
  MessageData? lastMessage;
  DateTime? created;
  DateTime? updated;

  ChatData({this.id, this.involvedCode, this.involved, this.involvedInfo, this.lastMessage, this.created, this.updated});


  ChatData.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {

    id = doc.id;
    involvedCode = doc.data()?[AppDatabase.involvedCode];

    List<dynamic> involvedData = doc.data()?[AppDatabase.involved];

    involved = [];
    for(String s in involvedData) {
      involved?.add(s);
    }

    List<dynamic> involvedInfoData = doc.data()?[AppDatabase.involvedInfo];
    involvedInfo = [];

    for(Map<String, dynamic> info in involvedInfoData) {
      involvedInfo?.add(info);
    }


    Map<String, dynamic>? lastMessageMap = doc.data()?[AppDatabase.lastMessage];

    if(lastMessageMap != null) {
      lastMessage = MessageData.fromMap(lastMessageMap);
    }

    created = (doc.data()?[AppDatabase.created] as Timestamp).toDate();
    updated = (doc.data()?[AppDatabase.updated] as Timestamp).toDate();



  }

}