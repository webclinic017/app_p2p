

import 'package:app_p2p/database/appDatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BalanceData {

  String? id;
  double? amount;
  String? currencyName;
  String? currencyCode;
  bool? isFiat;
  DateTime? created;



  BalanceData({this.amount, this.currencyName, this.currencyCode, this.isFiat,
  this.created});

  BalanceData.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    id = doc.id;
    try {
      amount = double.parse(doc.data()?[AppDatabase.amount].toString() as String);
    }catch(e) {
      amount = 0.0;
    }

    currencyName = doc.data()?[AppDatabase.currencyName];
    currencyCode = doc.data()?[AppDatabase.currencyCode];
    isFiat = doc.data()?[AppDatabase.isFiat];
    created = (doc.data()?[AppDatabase.created] as Timestamp).toDate();
  }

  BalanceData.fromMap(Map<String, dynamic> map) {

    amount = map[AppDatabase.amount];
    currencyName = map[AppDatabase.currencyName];
    currencyCode = map[AppDatabase.currencyCode];


  }


  Map<String, dynamic> toMap() => {
    AppDatabase.amount: amount,
    AppDatabase.currencyName: currencyName,
    AppDatabase.currencyCode: currencyCode,
    AppDatabase.isFiat: isFiat,
    AppDatabase.created: created
  };


}