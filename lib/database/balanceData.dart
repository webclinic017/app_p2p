

import 'package:app_p2p/database/appDatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BalanceData {

  double? amount;
  String? currencyName;
  String? currencyCode;
  bool? isFiat;
  DateTime? created;



  BalanceData({this.amount, this.currencyName, this.currencyCode, this.isFiat,
  this.created});

  BalanceData.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    amount = doc.data()?[AppDatabase.amount];
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
    AppDatabase.currencyCode: currencyCode
  };


}