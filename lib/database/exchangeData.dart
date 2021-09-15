

import 'package:app_p2p/database/appDatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExchangeData {

  String? code;
  DateTime? time;
  double? open;
  double? high;
  double? low;
  double? close;
  double? volume;
  double? previousClose;
  double? change;
  double? changeP;

  ExchangeData.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {

    code = doc.data()?[AppDatabase.code];

    time = (doc.data()?[AppDatabase.time] as Timestamp).toDate();

    open = double.parse(doc.data()?[AppDatabase.open].toString() as String);
    high = double.parse(doc.data()?[AppDatabase.high].toString() as String);
    low = double.parse(doc.data()?[AppDatabase.low].toString() as String);
    close = double.parse(doc.data()?[AppDatabase.close].toString() as String);
    volume = double.parse(doc.data()?[AppDatabase.volume].toString() as String);
    previousClose = double.parse(doc.data()?[AppDatabase.previousClose].toString() as String);
    change = double.parse(doc.data()?[AppDatabase.change].toString() as String);
    changeP = double.parse(doc.data()?[AppDatabase.changeP].toString() as String);

  }


  ExchangeData.fromMap(Map<String, dynamic> map) {

    code = map[AppDatabase.code];



    time = DateTime.now();

    open = double.parse(map[AppDatabase.open].toString());
    high = double.parse(map[AppDatabase.high].toString());
    low = double.parse(map[AppDatabase.low].toString());
    close = double.parse(map[AppDatabase.close].toString());
    volume = double.parse(map[AppDatabase.volume].toString());
    previousClose = double.parse(map[AppDatabase.previousClose].toString());
    change = double.parse(map[AppDatabase.change].toString());
    changeP = double.parse(map[AppDatabase.changeP].toString());


  }


  Map<String, dynamic> toMap() => {
    AppDatabase.code: code,
    AppDatabase.time: time,
    AppDatabase.open: open,
    AppDatabase.high: high,
    AppDatabase.low: low,
    AppDatabase.close: close,
    AppDatabase.volume: volume,
    AppDatabase.previousClose: previousClose,
    AppDatabase.change: change,
    AppDatabase.changeP: changeP

  };


}