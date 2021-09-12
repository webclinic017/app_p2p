import 'package:app_p2p/database/appDatabase.dart';
import 'package:app_p2p/database/messageData.dart';
import 'package:app_p2p/screens/login/login.dart';
import 'package:app_p2p/utilities/appColors.dart';
import 'package:app_p2p/utilities/appUtilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageItem extends StatefulWidget {

  MessageData? data;
  String? id;

  MessageItem({this.data, this.id});

  @override
  _MessageItemState createState() => _MessageItemState(
    data: data, id: id
  );
}

class _MessageItemState extends State<MessageItem> {

  MessageData? data;
  String? id;
  _MessageItemState({this.data, this.id});






  Widget get mineMessage => Row(
    children: [


      Expanded(
        child: Container(),
      ),



      _creatingMessage? Container(
        width: 35,
        height: 35,
        child: FittedBox(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),),
        ),
      ) : (data?.seen == true? Row(
        children: [
          Icon(Icons.check, color: AppColors.primary,),
          SizedBox(width: 2,),
          Icon(Icons.check, color: AppColors.primary,)
        ],
      ) : Row(
        children: [
          Icon(Icons.check, color: AppColors.mediumGray,),
          SizedBox(width: 2,),
          Icon(Icons.check, color: AppColors.mediumGray,)
        ],
      )),

      SizedBox(width: 10,),

      Text(AppUtilities.formatDateToTime(data?.created as DateTime),
      style: TextStyle(color: AppColors.mediumGray),),


      SizedBox(width: 10,),


      ConstrainedBox(
          constraints: BoxConstraints(minHeight: 50, minWidth: 30, maxWidth: 200),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
            decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1, blurRadius: 6, offset: Offset(0, 6))]
            ),
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text(data?.message as String, style: TextStyle(color: Colors.white),),
            ),
          )
      ),

      SizedBox(width: 20,),
    ],
  );




  Widget get otherMessage => Row(
    children: [
      SizedBox(width: 20,),

      ConstrainedBox(
          constraints: BoxConstraints(minHeight: 50, minWidth: 30, maxWidth: 200),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1, blurRadius: 6, offset: Offset(0, 6))]
            ),
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text(data?.message as String),
            ),
          )
      ),


      SizedBox(width: 10,),

      Text(AppUtilities.formatDateToTime(data?.created as DateTime),
        style: TextStyle(color: AppColors.mediumGray),),





      Expanded(
        child: Container(),
      ),

    ],
  );



  bool get isMine => data?.senderID == userID;


  @override
  void initState() {

    if(id != null) {
      createMessage();
    }

    if(!isMine && data?.seen == false) {
      setSeen();
    }
    super.initState();
  }


  void setSeen() {
    var firestore = FirebaseFirestore.instance;

    firestore.collection(AppDatabase.chats).doc(data?.chatID)
    .collection(AppDatabase.messages).doc(data?.id).update({
      AppDatabase.seen: true
    }).then((result) {

      setState(() {
        data?.seen = true;
      });

    }).catchError((onError) {

      print("Error setting seen: ${onError.toString()}");
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: isMine? mineMessage : otherMessage
    );
  }

  bool _creatingMessage = false;

  void createMessage() {
    var firestore = FirebaseFirestore.instance;

    setState(() {
      _creatingMessage = true;
    });

    var batch = firestore.batch();

    var messageDoc = firestore.collection(AppDatabase.chats).doc(data?.chatID)
        .collection(AppDatabase.messages).doc(id);

    batch.set(messageDoc, data?.toMap() as Map<String, dynamic>);


    var chatDoc = firestore.collection(AppDatabase.chats).doc(data?.chatID);

    batch.update(chatDoc, {
      AppDatabase.lastMessage: {
        AppDatabase.chatID: data?.chatID,
        AppDatabase.message: data?.message,
        AppDatabase.senderID: data?.senderID,
        AppDatabase.seen: data?.seen,
        AppDatabase.created: data?.created
      }
    });

    batch.commit().then((result) {

      if(!mounted) {
        return;
      }

      setState(() {
        _creatingMessage = false;
      });
    }).catchError((onError) {

      if(!mounted) {
        return;
      }

      setState(() {
        _creatingMessage = false;
      });

      print("Error creating message: ${onError.toString()}");
    });
  }
}
