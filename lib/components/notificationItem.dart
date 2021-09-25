import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/database/notificationData.dart';
import 'package:app_p2p/screens/login/login.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationItem extends StatefulWidget {

  NotificationData? data;
  NotificationItem({this.data});

  @override
  _NotificationItemState createState() => _NotificationItemState(data: data);
}

class _NotificationItemState extends State<NotificationItem> {

  NotificationData? data;
  _NotificationItemState({this.data});

  @override
  void initState() {

    setSeen();
    super.initState();
  }

  void setSeen() {
    var firestore = FirebaseFirestore.instance;

    firestore.collection(AppDatabase.users).doc(userID)
    .collection(AppDatabase.notifications).doc(data?.id).update({
      AppDatabase.seen: true
    }).then((result) {

      print("Seen set!");


    }).catchError((onError) {
      print("Error updating seen: ${onError.toString()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Text(data?.title as String, style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600
            ),),
          ),
          SizedBox(height: 5,),
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Text(data?.content as String,
            style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.mediumGray),),
          ),
        ],
      ),
    );
  }
}
