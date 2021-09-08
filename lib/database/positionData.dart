
import 'package:app_p2p/database/appDatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PositionData {

  double? lat;
  double? lng;

  PositionData({this.lat, this.lng});

  PositionData.fromMap(Map<String, dynamic> map) {
    lat = map[AppDatabase.lat];
    lng = map[AppDatabase.lng];
  }

}