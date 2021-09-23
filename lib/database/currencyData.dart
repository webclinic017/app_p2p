import 'package:app_p2p/database/appDatabase.dart';
import 'package:flutter/material.dart';

class CurrencyData {

  String? name;
  String? code;


  CurrencyData({this.name, this.code});

  Map<String, dynamic> toMap() => {
    AppDatabase.currencyName: name,
    AppDatabase.code: code
  };

  Map<String, dynamic> toLocalDatabaseMap() => {
    "name" : name,
    "code" : code
  };

  String toDatabaseString () =>"('$name','$code')";

  CurrencyData.fromMap(Map<String, dynamic> map) {

    name = map["name"];
    code = "${map["code"]}.${map["exchange"]}";

  }
}