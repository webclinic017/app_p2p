
import 'package:app_p2p/database/appDatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationData {
  String? id;
  String? title;
  String? content;
  DateTime? created;

  NotificationData({this.id, this.title, this.content, this.created});

  NotificationData.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    id = doc.id;
    title = doc.data()?[AppDatabase.title];
    content = doc.data()?[AppDatabase.content];
    created = (doc.data()?[AppDatabase.created] as Timestamp).toDate();
  }


}