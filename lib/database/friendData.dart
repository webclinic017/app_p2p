
import 'package:app_p2p/database/appDatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendData {

  String? id;
  String? userID;
  DateTime? created;

  FriendData({this.id, this.userID,
  this.created});

  FriendData.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    id = doc.id;
    userID = doc.data()?[AppDatabase.userID];
    created = (doc.data()?[AppDatabase.created] as Timestamp).toDate();

  }

}