

import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/database/positionData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {

  String? id;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? phoneCode;
  String? email;
  String? imagePath;
  String? imageUrl;
  bool? active;
  GeoPoint? position;


  UserData({this.id, this.firstName, this.lastName, this.phoneNumber, this.phoneCode,
  this.email, this.imagePath, this.imageUrl});

  UserData.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    id = doc.data()?[AppDatabase.id];
    firstName = doc.data()?[AppDatabase.firstName];
    lastName = doc.data()?[AppDatabase.lastName];
    phoneNumber = doc.data()?[AppDatabase.phoneNumber];
    phoneCode = doc.data()?[AppDatabase.phoneCode];
    email = doc.data()?[AppDatabase.email];
    imagePath = doc.data()?[AppDatabase.imagePath];
    imageUrl = doc.data()?[AppDatabase.imageUrl];
    active = doc.data()?[AppDatabase.active];

    try {
      position = doc.data()?[AppDatabase.currentPosition];
    }catch(e) {
      position = null;
    }



  }

  static Future<UserData> fromID(String id) async{
    var firestore = FirebaseFirestore.instance;

    var doc = await firestore.collection(AppDatabase.users).doc(id).get();

    return UserData.fromDoc(doc);

  }
}