
import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/database/balanceData.dart';
import 'package:app_p2p/database/transactionData.dart';
import 'package:app_p2p/database/userData.dart';
import 'package:app_p2p/localizations/appLocalizations.dart';
import 'package:app_p2p/screens/login/login.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:app_p2p/utilities/appUtilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TransactionItem extends StatefulWidget {
  TransactionData? data;

  TransactionItem({this.data});

  @override
  _TransactionItemState createState() => _TransactionItemState(data: data);
}

class _TransactionItemState extends State<TransactionItem> {

  TransactionData? data;
  _TransactionItemState({this.data});

  BalanceData? userWallet;

  UserData? otherUser;



  @override
  void initState() {
    if(data?.type == "send") {

      loadBalance(data?.originBalance as String);
      loadOtherUser(data?.receiverID as String);

    }else if(data?.type == "receive") {
      loadBalance(data?.destinationBalance as String);
      loadOtherUser(data?.senderID as String);
    }
    super.initState();
  }

  void loadBalance (String id) {
    var firestore = FirebaseFirestore.instance;

    firestore.collection(AppDatabase.users).doc(userID)
        .collection(AppDatabase.balances).doc(id).get().then((doc) {


      setState(() {
        userWallet = BalanceData.fromDoc(doc);
      });

    }).catchError((onError) {

      print("Error loading balance: ${onError.toString()}");
    });


  }


  void loadOtherUser(String id) {
    var firestore = FirebaseFirestore.instance;
    firestore.collection(AppDatabase.users).doc(id).get().then((doc) {

      setState(() {
        otherUser = UserData.fromDoc(doc);
      });

    }).catchError((onError) {

      print("Error loading user: ${onError.toString()}");
    });
  }


  String get conditionedString {

    if(data?.type == "send") {

      return loc(context, "sent");

    }else {
      return loc(context, "received");
    }
  }

  Color get transactionColor {
    if(data?.type == "send") {

      return Colors.red;

    }else {
      return Colors.green;
    }
  }

  String get recipientOrSenderText {
    if(data?.type == "send") {

      return "${loc(context, "to")} ${otherUser?.firstName} ${otherUser?.lastName}";

    }else {
      return "${loc(context, "from")} ${otherUser?.firstName} ${otherUser?.lastName}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
        spreadRadius: 1, blurRadius: 4, offset: Offset(0, 4))]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          SizedBox(height: 20,),

          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: userWallet != null && otherUser != null?
            Row(
              children: [Text("${data?.amount?.toString()}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
              color: transactionColor),),
              SizedBox(width: 5,),
                Text("${userWallet?.currencyCode?.substring(0, 3)} ")],
            ) : Text("-"),
          ),

          SizedBox(height: 5,),

          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: userWallet != null && otherUser != null?Row(
              children: [
                Text(conditionedString, style: TextStyle(
                    color: transactionColor.withOpacity(0.6), fontWeight: FontWeight.w600
                ),),


              ],
            ) : Text("-", style: TextStyle(color: transactionColor),)
          ),

          SizedBox(height: 10,),

          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              children: [
                Text(AppUtilities.dateFormatted(data?.created as DateTime),
                  style: TextStyle(
                      color: AppColors.mediumGray, fontWeight: FontWeight.w600
                  ),),

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      Text(recipientOrSenderText, style: TextStyle(
                        fontSize: 12, color: AppColors.mediumGray,
                        fontWeight: FontWeight.w600
                      ),)
                    ],
                  ),
                )
              ],
            )
          ),


          SizedBox(height: 20,),




        ],
      )
    );
  }
}
