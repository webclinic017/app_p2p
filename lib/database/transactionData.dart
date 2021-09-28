
import 'package:app_p2p/database/appDatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionData {

  String? id;
  String? type;
  String? originBalance;
  String? destinationBalance;
  String? senderID;
  String? receiverID;
  double? amount;
  DateTime? created;

  TransactionData({this.id, this.type, this.originBalance, this.destinationBalance,
  this.senderID, this.receiverID, this.amount, this.created});

  TransactionData.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    id = doc.id;
    type = doc.data()?[AppDatabase.type];
    originBalance = doc.data()?[AppDatabase.originBalance];
    destinationBalance = doc.data()?[AppDatabase.destinationBalance];
    senderID = doc.data()?[AppDatabase.senderID];
    receiverID = doc.data()?[AppDatabase.receiverID];
    amount = double.parse(doc.data()?[AppDatabase.amount].toString() as String);
    created = (doc.data()?[AppDatabase.created] as Timestamp).toDate();
  }

}